import 'package:flutter/material.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/data/models/project_model.dart';
import 'package:blue_carbon_app/data/services/api_service.dart';
import 'package:blue_carbon_app/presentation/screens/projects/create_project_screen.dart';
import 'package:blue_carbon_app/presentation/screens/projects/project_detail_screen.dart';
import 'package:blue_carbon_app/presentation/widgets/project/project_card.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  bool _isLoading = true;
  List<ProjectModel> _projects = [];
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    try {
      final api = ApiService();
      final items = await api.getProjects();
      if (!mounted) return;
      setState(() {
        _projects = items;
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

  List<ProjectModel> get _filteredProjects {
    if (_selectedFilter == 'All') {
      return _projects;
    } else if (_selectedFilter == 'Draft') {
      return _projects.where((p) => p.status == ProjectStatus.draft).toList();
    } else if (_selectedFilter == 'Approved') {
      return _projects.where((p) => p.status == ProjectStatus.approved).toList();
    }
    return _projects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadProjects,
        color: AppColors.coastalTeal,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 160,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.deepOceanBlue,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Blue Carbon Projects',
                  style: TextStyle(
                    color: AppColors.pearlWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.oceanDepthGradient,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -30,
                        top: 20,
                        child: Icon(
                          Icons.eco,
                          size: 120,
                          color: AppColors.pearlWhite.withOpacity(0.1),
                        ),
                      ),
                      Positioned(
                        left: -20,
                        bottom: 10,
                        child: Icon(
                          Icons.waves,
                          size: 80,
                          color: AppColors.pearlWhite.withOpacity(0.1),
                        ),
                      ),
                    ],
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
                      : _filteredProjects.isEmpty
                          ? _buildEmptyState()
                          : _buildProjectList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.coastalTeal,
        onPressed: () async {
          final created =
              await Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateProjectScreen()));
          if (created == true) {
            setState(() {
              _isLoading = true;
            });
            await _loadProjects();
          }
        },
        icon: const Icon(Icons.add, color: AppColors.pearlWhite),
        label: const Text(
          'New Project',
          style: TextStyle(
            color: AppColors.pearlWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All'),
          const SizedBox(width: 8),
          _buildFilterChip('Draft'),
          const SizedBox(width: 8),
          _buildFilterChip('Approved'),
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
    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.coastalTeal)));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forest, size: 80, color: AppColors.deepOceanBlue.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No projects found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.charcoal),
          ),
          const SizedBox(height: 8),
          Text('Create your first blue carbon project', style: TextStyle(color: AppColors.charcoal.withOpacity(0.7))),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateProjectScreen()));
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Project'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.coastalTeal),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: _filteredProjects.map((project) {
          return ProjectCard(
            project: project,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetailScreen(project: project)));
            },
          );
        }).toList(),
      ),
    );
  }
}
