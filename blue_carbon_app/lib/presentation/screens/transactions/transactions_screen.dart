import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/data/models/transaction_model.dart';
import 'package:blue_carbon_app/data/services/api_service.dart';
import 'package:blue_carbon_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:blue_carbon_app/presentation/widgets/transaction/transaction_card.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool _isLoading = true;
  List<TransactionModel> _transactions = [];
  String _selectedFilter = 'All';
  Map<String, dynamic> _summary = {
    'total': 0.0,
    'spent': 0.0,
    'received': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _loadSummary();
  }

  Future<void> _loadTransactions() async {
    try {
      final api = ApiService();
      final items = await api.getTransactions();
      if (!mounted) return;
      setState(() {
        _transactions = items;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.coralPink),
      );
    }
  }

  Future<void> _loadSummary() async {
    try {
      final api = ApiService();
      final state = context.read<AuthBloc>().state;
      if (state is AuthAuthenticated) {
        final orgId = state.user.orgId;
        if (orgId == null) return;
        final summary = await api.getOrgTransactionSummary(orgId);
        if (!mounted) return;
        setState(() {
          _summary = summary;
        });
      }
    } catch (e) {
      // Silently handle error, as the main transaction list is more important
      debugPrint('Error loading transaction summary: $e');
    }
  }

  List<TransactionModel> get _filteredTransactions {
    if (_selectedFilter == 'All') {
      return _transactions;
    } else if (_selectedFilter == 'Credits') {
      return _transactions.where((t) => t.type == TransactionType.credit).toList();
    } else if (_selectedFilter == 'Debits') {
      return _transactions.where((t) => t.type == TransactionType.debit).toList();
    }
    return _transactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([_loadTransactions(), _loadSummary()]);
        },
        color: AppColors.coastalTeal,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 260,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.deepOceanBlue,
              title: const Text('Transactions'),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.oceanDepthGradient,
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildSummarySection(),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildFilterChips(),
                  _isLoading
                      ? _buildLoadingState()
                      : _filteredTransactions.isEmpty
                          ? _buildEmptyState()
                          : _buildTransactionsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balance Summary',
            style: TextStyle(
              color: AppColors.pearlWhite,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Current Balance',
                  currencyFormat.format(_summary['total'] ?? 0),
                  AppColors.pearlWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Received',
                  currencyFormat.format(_summary['received'] ?? 0),
                  AppColors.seagrassGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Spent',
                  currencyFormat.format(_summary['spent'] ?? 0),
                  AppColors.coralPink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.deepOceanBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.pearlWhite.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.pearlWhite.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All'),
          const SizedBox(width: 8),
          _buildFilterChip('Credits'),
          const SizedBox(width: 8),
          _buildFilterChip('Debits'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: isSelected ? AppColors.coastalTeal.withOpacity(0.1) : AppColors.sandyBeige,
      selectedColor: AppColors.coastalTeal.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.coastalTeal : AppColors.charcoal,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: AppColors.coastalTeal,
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.coastalTeal)),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet, size: 80, color: AppColors.deepOceanBlue.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.charcoal),
          ),
          const SizedBox(height: 8),
          Text(
            'Transactions will appear here',
            style: TextStyle(color: AppColors.charcoal.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.deepOceanBlue),
          ),
          const SizedBox(height: 12),
          ..._filteredTransactions.map((transaction) {
            return TransactionCard(
              transaction: transaction,
              onTap: () {
                // Show transaction details if needed
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
