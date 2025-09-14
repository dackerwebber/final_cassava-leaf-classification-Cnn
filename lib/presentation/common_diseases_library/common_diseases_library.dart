import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/disease_card_widget.dart';
import './widgets/disease_detail_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/search_bar_widget.dart';

class CommonDiseasesLibrary extends StatefulWidget {
  const CommonDiseasesLibrary({Key? key}) : super(key: key);

  @override
  State<CommonDiseasesLibrary> createState() => _CommonDiseasesLibraryState();
}

class _CommonDiseasesLibraryState extends State<CommonDiseasesLibrary>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  List<String> _selectedFilters = [];
  List<String> _bookmarkedDiseases = [];
  bool _isRefreshing = false;
  DateTime _lastUpdated = DateTime.now();

  // Mock data for cassava diseases
  final List<Map<String, dynamic>> _allDiseases = [
    {
      "id": "1",
      "name": "Cassava Mosaic Disease (CMD)",
      "severity": "High",
      "description":
          "A viral disease causing yellow mosaic patterns on leaves, stunted growth, and reduced yield. One of the most devastating cassava diseases in Africa.",
      "imageUrl":
          "https://images.pexels.com/photos/4750270/pexels-photo-4750270.jpeg?auto=compress&cs=tinysrgb&w=800",
      "images": [
        "https://images.pexels.com/photos/4750270/pexels-photo-4750270.jpeg?auto=compress&cs=tinysrgb&w=800",
        "https://images.pexels.com/photos/4750271/pexels-photo-4750271.jpeg?auto=compress&cs=tinysrgb&w=800",
        "https://images.pexels.com/photos/4750272/pexels-photo-4750272.jpeg?auto=compress&cs=tinysrgb&w=800"
      ],
      "affectedRegions": ["West Africa", "East Africa", "Central Africa"],
      "symptoms": [
        "Yellow mosaic patterns on leaves",
        "Leaf distortion and curling",
        "Stunted plant growth",
        "Reduced tuber size and quality",
        "Premature leaf drop"
      ],
      "prevention": [
        "Use certified disease-free planting material",
        "Control whitefly vectors through integrated pest management",
        "Remove and destroy infected plants immediately",
        "Plant resistant cassava varieties",
        "Maintain proper field sanitation"
      ],
      "treatment": [
        "Remove infected plants to prevent spread",
        "Apply systemic insecticides to control whiteflies",
        "Use reflective mulches to deter whiteflies",
        "Implement crop rotation with non-host plants",
        "Monitor fields regularly for early detection"
      ],
      "seasonalInfo": {
        "bestSeason": "Dry season planting reduces whitefly pressure",
        "riskPeriod": "Wet season with high whitefly activity",
        "tips": [
          "Plant during cooler months when whitefly populations are lower",
          "Avoid planting near infected fields",
          "Use intercropping with maize or other tall crops as barriers"
        ]
      }
    },
    {
      "id": "2",
      "name": "Cassava Brown Streak Disease (CBSD)",
      "severity": "High",
      "description":
          "A viral disease causing brown streaks on stems and necrotic lesions in tubers, making them inedible and causing significant economic losses.",
      "imageUrl":
          "https://images.pexels.com/photos/4207892/pexels-photo-4207892.jpeg?auto=compress&cs=tinysrgb&w=800",
      "images": [
        "https://images.pexels.com/photos/4207892/pexels-photo-4207892.jpeg?auto=compress&cs=tinysrgb&w=800",
        "https://images.pexels.com/photos/4207893/pexels-photo-4207893.jpeg?auto=compress&cs=tinysrgb&w=800"
      ],
      "affectedRegions": ["East Africa", "Southern Africa"],
      "symptoms": [
        "Brown streaks on stems and leaf veins",
        "Yellowing and necrosis of leaf margins",
        "Brown necrotic lesions in tubers",
        "Reduced tuber quality and marketability",
        "Premature plant death in severe cases"
      ],
      "prevention": [
        "Use clean, certified planting material",
        "Control whitefly vectors",
        "Remove infected plants promptly",
        "Plant tolerant varieties",
        "Avoid moving planting material from infected areas"
      ],
      "treatment": [
        "Roguing of infected plants",
        "Vector control using appropriate insecticides",
        "Quarantine measures for planting material",
        "Field sanitation practices",
        "Regular monitoring and early detection"
      ],
      "seasonalInfo": {
        "bestSeason": "Plant during periods of low whitefly activity",
        "riskPeriod": "Warm, humid conditions favor disease development",
        "tips": [
          "Harvest tubers early if infection is detected",
          "Store healthy planting material separately",
          "Coordinate with neighboring farmers for area-wide management"
        ]
      }
    },
    {
      "id": "3",
      "name": "Cassava Bacterial Blight (CBB)",
      "severity": "Medium",
      "description":
          "A bacterial disease causing angular leaf spots, stem cankers, and wilting. Can cause significant yield losses if not managed properly.",
      "imageUrl":
          "https://images.pexels.com/photos/4207894/pexels-photo-4207894.jpeg?auto=compress&cs=tinysrgb&w=800",
      "images": [
        "https://images.pexels.com/photos/4207894/pexels-photo-4207894.jpeg?auto=compress&cs=tinysrgb&w=800"
      ],
      "affectedRegions": ["Sub-Saharan Africa", "South America", "Asia"],
      "symptoms": [
        "Angular brown spots on leaves",
        "Water-soaked lesions on stems",
        "Wilting of shoots and branches",
        "Gummy exudate from infected stems",
        "Leaf blight and defoliation"
      ],
      "prevention": [
        "Use pathogen-free planting material",
        "Avoid overhead irrigation",
        "Practice crop rotation",
        "Remove plant debris after harvest",
        "Plant resistant varieties where available"
      ],
      "treatment": [
        "Apply copper-based bactericides",
        "Prune and destroy infected plant parts",
        "Improve field drainage",
        "Reduce plant density for better air circulation",
        "Apply preventive sprays during wet periods"
      ],
      "seasonalInfo": {
        "bestSeason": "Dry season planting reduces infection risk",
        "riskPeriod": "Wet season with high humidity and frequent rains",
        "tips": [
          "Avoid working in fields when plants are wet",
          "Disinfect tools between plants",
          "Plant in well-drained soils"
        ]
      }
    },
    {
      "id": "4",
      "name": "Cassava Anthracnose Disease (CAD)",
      "severity": "Medium",
      "description":
          "A fungal disease causing stem cankers, tip die-back, and leaf spots. More common in humid conditions and can affect plant vigor.",
      "imageUrl":
          "https://images.pexels.com/photos/4207895/pexels-photo-4207895.jpeg?auto=compress&cs=tinysrgb&w=800",
      "images": [
        "https://images.pexels.com/photos/4207895/pexels-photo-4207895.jpeg?auto=compress&cs=tinysrgb&w=800"
      ],
      "affectedRegions": ["Tropical regions worldwide"],
      "symptoms": [
        "Sunken cankers on stems",
        "Tip die-back of shoots",
        "Circular spots on leaves",
        "Premature leaf drop",
        "Reduced plant vigor"
      ],
      "prevention": [
        "Use healthy planting material",
        "Ensure proper plant spacing",
        "Remove infected plant debris",
        "Avoid wounding plants during cultivation",
        "Plant in well-ventilated areas"
      ],
      "treatment": [
        "Apply fungicides containing copper or mancozeb",
        "Prune infected shoots below the canker",
        "Improve air circulation around plants",
        "Apply preventive fungicide sprays",
        "Remove and burn infected plant material"
      ],
      "seasonalInfo": {
        "bestSeason": "Dry season for planting and management",
        "riskPeriod": "Wet season with high humidity",
        "tips": [
          "Avoid overhead watering",
          "Harvest stems for planting during dry weather",
          "Store planting material in dry, ventilated areas"
        ]
      }
    },
    {
      "id": "5",
      "name": "Cassava Root Rot",
      "severity": "Low",
      "description":
          "A soil-borne disease affecting roots and tubers, causing soft rot and reducing storage life. Usually occurs in waterlogged conditions.",
      "imageUrl":
          "https://images.pexels.com/photos/4207896/pexels-photo-4207896.jpeg?auto=compress&cs=tinysrgb&w=800",
      "images": [
        "https://images.pexels.com/photos/4207896/pexels-photo-4207896.jpeg?auto=compress&cs=tinysrgb&w=800"
      ],
      "affectedRegions": ["Global", "Waterlogged areas"],
      "symptoms": [
        "Soft, watery rot of tubers",
        "Foul smell from infected roots",
        "Discoloration of root tissue",
        "Reduced tuber storage life",
        "Plant wilting in severe cases"
      ],
      "prevention": [
        "Ensure proper field drainage",
        "Avoid planting in waterlogged soils",
        "Practice crop rotation",
        "Harvest tubers at proper maturity",
        "Handle tubers carefully to avoid wounds"
      ],
      "treatment": [
        "Improve field drainage systems",
        "Apply organic matter to improve soil structure",
        "Use raised beds in prone areas",
        "Harvest and process tubers quickly",
        "Store tubers in dry, ventilated conditions"
      ],
      "seasonalInfo": {
        "bestSeason": "Plant on well-drained soils during dry season",
        "riskPeriod": "Wet season in poorly drained fields",
        "tips": [
          "Create drainage channels in fields",
          "Harvest before heavy rains",
          "Process infected tubers immediately"
        ]
      }
    },
    {
      "id": "6",
      "name": "Cassava Green Mite Damage",
      "severity": "Medium",
      "description":
          "Damage caused by green spider mites leading to chlorotic leaves, reduced photosynthesis, and yield losses. Common in dry conditions.",
      "imageUrl":
          "https://images.pexels.com/photos/4207897/pexels-photo-4207897.jpeg?auto=compress&cs=tinysrgb&w=800",
      "images": [
        "https://images.pexels.com/photos/4207897/pexels-photo-4207897.jpeg?auto=compress&cs=tinysrgb&w=800"
      ],
      "affectedRegions": ["Africa", "South America"],
      "symptoms": [
        "Chlorotic (yellowing) leaves",
        "Fine webbing on leaf undersides",
        "Bronzing of leaves",
        "Premature leaf drop",
        "Reduced plant vigor and yield"
      ],
      "prevention": [
        "Maintain adequate soil moisture",
        "Encourage natural enemies",
        "Avoid dusty conditions",
        "Plant resistant varieties",
        "Practice intercropping with legumes"
      ],
      "treatment": [
        "Apply miticides when threshold is reached",
        "Use biological control agents",
        "Spray with neem oil or soap solutions",
        "Increase humidity around plants",
        "Remove heavily infested leaves"
      ],
      "seasonalInfo": {
        "bestSeason": "Wet season reduces mite populations",
        "riskPeriod": "Dry season with dusty conditions",
        "tips": [
          "Irrigate during dry spells",
          "Mulch around plants to retain moisture",
          "Monitor regularly during dry periods"
        ]
      }
    }
  ];

  List<Map<String, dynamic>> _filteredDiseases = [];
  List<String> _searchSuggestions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredDiseases = List.from(_allDiseases);
    _generateSearchSuggestions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _generateSearchSuggestions() {
    Set<String> suggestions = {};
    for (var disease in _allDiseases) {
      suggestions.add(disease['name'] as String);
      final symptoms = disease['symptoms'] as List<dynamic>? ?? [];
      for (var symptom in symptoms) {
        suggestions.add(symptom as String);
      }
    }
    _searchSuggestions = suggestions.toList()..sort();
  }

  void _filterDiseases() {
    setState(() {
      _filteredDiseases = _allDiseases.where((disease) {
        // Search filter
        bool matchesSearch = _searchQuery.isEmpty ||
            (disease['name'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (disease['description'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (disease['symptoms'] as List<dynamic>).any((symptom) =>
                (symptom as String)
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()));

        // Severity filters
        bool matchesSeverity = true;
        if (_selectedFilters.contains('high') ||
            _selectedFilters.contains('medium') ||
            _selectedFilters.contains('low')) {
          matchesSeverity = _selectedFilters
              .contains((disease['severity'] as String).toLowerCase());
        }

        // Season filters
        bool matchesSeason = true;
        if (_selectedFilters.contains('dry') ||
            _selectedFilters.contains('wet')) {
          final seasonalInfo =
              disease['seasonalInfo'] as Map<String, dynamic>? ?? {};
          final bestSeason =
              (seasonalInfo['bestSeason'] as String? ?? '').toLowerCase();
          final riskPeriod =
              (seasonalInfo['riskPeriod'] as String? ?? '').toLowerCase();

          if (_selectedFilters.contains('dry')) {
            matchesSeason =
                bestSeason.contains('dry') || riskPeriod.contains('wet');
          }
          if (_selectedFilters.contains('wet')) {
            matchesSeason =
                bestSeason.contains('wet') || riskPeriod.contains('dry');
          }
        }

        return matchesSearch && matchesSeverity && matchesSeason;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterDiseases();
  }

  void _onFilterToggle(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
    });
    _filterDiseases();
  }

  void _onClearFilters() {
    setState(() {
      _selectedFilters.clear();
    });
    _filterDiseases();
  }

  void _onVoiceSearch() {
    // Voice search functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice search feature coming soon'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _showDiseaseDetail(Map<String, dynamic> disease) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DiseaseDetailWidget(
          disease: disease,
          onClose: () => Navigator.of(context).pop(),
          onBookmark: () => _toggleBookmark(disease['id'] as String),
          onShare: () => _shareDisease(disease),
          isBookmarked: _bookmarkedDiseases.contains(disease['id'] as String),
        ),
      ),
    );
  }

  void _toggleBookmark(String diseaseId) {
    setState(() {
      if (_bookmarkedDiseases.contains(diseaseId)) {
        _bookmarkedDiseases.remove(diseaseId);
      } else {
        _bookmarkedDiseases.add(diseaseId);
      }
    });
  }

  void _shareDisease(Map<String, dynamic> disease) {
    // Share functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${disease['name']}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Future<void> _refreshContent() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network refresh
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _lastUpdated = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Content updated successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  List<Map<String, dynamic>> get _bookmarkedDiseasesList {
    return _allDiseases
        .where(
            (disease) => _bookmarkedDiseases.contains(disease['id'] as String))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Disease Library',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            size: 24.sp,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to settings or help
            },
            icon: CustomIconWidget(
              iconName: 'help_outline',
              size: 24.sp,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          indicatorColor: AppTheme.lightTheme.colorScheme.primary,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'library_books',
                    size: 18.sp,
                    color: _tabController.index == 0
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                  ),
                  SizedBox(width: 2.w),
                  Text('All Diseases'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'bookmark',
                    size: 18.sp,
                    color: _tabController.index == 1
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                  ),
                  SizedBox(width: 2.w),
                  Text('Bookmarked (${_bookmarkedDiseases.length})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar (Sticky)
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: SearchBarWidget(
              onSearchChanged: _onSearchChanged,
              onVoiceSearch: _onVoiceSearch,
              suggestions: _searchSuggestions,
            ),
          ),

          // Filter Chips (Sticky)
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: FilterChipsWidget(
              selectedFilters: _selectedFilters,
              onFilterToggle: _onFilterToggle,
              onClearFilters: _onClearFilters,
            ),
          ),

          // Last Updated Info
          if (!_isRefreshing)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              child: Text(
                'Last updated: ${_lastUpdated.day}/${_lastUpdated.month}/${_lastUpdated.year} at ${_lastUpdated.hour}:${_lastUpdated.minute.toString().padLeft(2, '0')}',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Diseases Tab
                RefreshIndicator(
                  onRefresh: _refreshContent,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  child: _filteredDiseases.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 2.h),
                          itemCount: _filteredDiseases.length,
                          itemBuilder: (context, index) {
                            final disease = _filteredDiseases[index];
                            return DiseaseCardWidget(
                              disease: disease,
                              onTap: () => _showDiseaseDetail(disease),
                            );
                          },
                        ),
                ),

                // Bookmarked Diseases Tab
                RefreshIndicator(
                  onRefresh: _refreshContent,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  child: _bookmarkedDiseasesList.isEmpty
                      ? _buildBookmarkedEmptyState()
                      : ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 2.h),
                          itemCount: _bookmarkedDiseasesList.length,
                          itemBuilder: (context, index) {
                            final disease = _bookmarkedDiseasesList[index];
                            return DiseaseCardWidget(
                              disease: disease,
                              onTap: () => _showDiseaseDetail(disease),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 48.sp,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              'No diseases found',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search terms or filters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _selectedFilters.clear();
                });
                _filterDiseases();
              },
              child: Text('Clear All Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkedEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'bookmark_border',
              size: 48.sp,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              'No bookmarked diseases',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Bookmark diseases for quick access by tapping the bookmark icon',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                _tabController.animateTo(0);
              },
              child: Text('Browse All Diseases'),
            ),
          ],
        ),
      ),
    );
  }
}
