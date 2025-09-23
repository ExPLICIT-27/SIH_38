import 'package:flutter/material.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';
import 'package:blue_carbon_app/data/models/project_model.dart';
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
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _projects = [
        ProjectModel(
          id: '1',
          orgId: '1',
          name: 'Mangrove Restoration - Sundarbans',
          type: 'Mangrove',
          areaHa: 150.5,
          status: ProjectStatus.approved,
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        ProjectModel(
          id: '2',
          orgId: '1',
          name: 'Seagrass Conservation - Gulf of Mannar',
          type: 'Seagrass',
          areaHa: 75.2,
          status: ProjectStatus.approved,
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          updatedAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        ProjectModel(
          id: '3',
          orgId: '1',
          name: 'Saltmarsh Restoration - Chilika Lake',
          type: 'Saltmarsh',
          areaHa: 95.8,
          status: ProjectStatus.draft,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];
      _isLoading = false;
    });
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
      appBar: AppBar(title: const Text('Projects'), backgroundColor: AppColors.deepOceanBlue),
      body: RefreshIndicator(
        onRefresh: _loadProjects,
        color: AppColors.coastalTeal,
        child: Column(
          children: [
            _buildFilterChips(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _filteredProjects.isEmpty
                  ? _buildEmptyState()
                  : _buildProjectList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.coastalTeal,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateProjectScreen()));
        },
        child: const Icon(Icons.add),
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredProjects.length,
      itemBuilder: (context, index) {
        final project = _filteredProjects[index];
        return ProjectCard(
          project: project,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetailScreen(project: project)));
          },
        );
      },
    );
  }
}
