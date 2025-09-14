import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_history_state.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/monthly_group_header.dart';
import './widgets/scan_result_card.dart';
import './widgets/search_filter_bar.dart';

class ScanHistory extends StatefulWidget {
  const ScanHistory({Key? key}) : super(key: key);

  @override
  State<ScanHistory> createState() => _ScanHistoryState();
}

class _ScanHistoryState extends State<ScanHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String _sortBy = 'newest';
  Map<String, dynamic> _activeFilters = {};
  Map<String, bool> _expandedMonths = {};
  bool _isRefreshing = false;
  bool _isOnline = true;

  // Mock scan history data
  final List<Map<String, dynamic>> _allScanHistory = [
    {
      'id': 1,
      'disease': 'Cassava Mosaic Disease',
      'confidence': 0.92,
      'date': '25 Aug 2025',
      'location': 'Farm Block A, Kumasi',
      'image':
          'https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'timestamp': DateTime(2025, 8, 25, 14, 30),
      'treatment': 'Remove infected plants and apply resistant varieties',
      'severity': 'High',
    },
    {
      'id': 2,
      'disease': 'Healthy',
      'confidence': 0.88,
      'date': '24 Aug 2025',
      'location': 'Farm Block B, Kumasi',
      'image':
          'https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'timestamp': DateTime(2025, 8, 24, 10, 15),
      'treatment': 'Continue regular care and monitoring',
      'severity': 'None',
    },
    {
      'id': 3,
      'disease': 'Cassava Brown Streak',
      'confidence': 0.76,
      'date': '23 Aug 2025',
      'location': 'Farm Block C, Accra',
      'image':
          'https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'timestamp': DateTime(2025, 8, 23, 16, 45),
      'treatment': 'Apply fungicide and improve drainage',
      'severity': 'Medium',
    },
    {
      'id': 4,
      'disease': 'Cassava Bacterial Blight',
      'confidence': 0.84,
      'date': '20 Aug 2025',
      'location': 'Farm Block A, Kumasi',
      'image':
          'https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'timestamp': DateTime(2025, 8, 20, 9, 20),
      'treatment': 'Use copper-based bactericide',
      'severity': 'Medium',
    },
    {
      'id': 5,
      'disease': 'Healthy',
      'confidence': 0.95,
      'date': '18 Aug 2025',
      'location': 'Farm Block D, Tamale',
      'image':
          'https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'timestamp': DateTime(2025, 8, 18, 11, 30),
      'treatment': 'Maintain current care routine',
      'severity': 'None',
    },
    {
      'id': 6,
      'disease': 'Cassava Green Mite',
      'confidence': 0.67,
      'date': '15 Aug 2025',
      'location': 'Farm Block B, Kumasi',
      'image':
          'https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'timestamp': DateTime(2025, 8, 15, 13, 10),
      'treatment': 'Apply miticide and increase humidity',
      'severity': 'Low',
    },
    {
      'id': 7,
      'disease': 'Cassava Mosaic Disease',
      'confidence': 0.89,
      'date': '10 Jul 2025',
      'location': 'Farm Block C, Accra',
      'image':
          'https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'timestamp': DateTime(2025, 7, 10, 15, 25),
      'treatment': 'Quarantine affected area',
      'severity': 'High',
    },
    {
      'id': 8,
      'disease': 'Healthy',
      'confidence': 0.91,
      'date': '05 Jul 2025',
      'location': 'Farm Block A, Kumasi',
      'image':
          'https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'timestamp': DateTime(2025, 7, 5, 8, 45),
      'treatment': 'Continue monitoring',
      'severity': 'None',
    },
  ];

  List<Map<String, dynamic>> _filteredHistory = [];
  Map<String, List<Map<String, dynamic>>> _groupedHistory = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 2; // Set History tab as active
    _filteredHistory = List.from(_allScanHistory);
    _groupHistoryByMonth();
    _initializeExpandedMonths();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeExpandedMonths() {
    for (String month in _groupedHistory.keys) {
      _expandedMonths[month] = true;
    }
  }

  void _groupHistoryByMonth() {
    _groupedHistory.clear();

    for (var scan in _filteredHistory) {
      final DateTime timestamp = scan['timestamp'] as DateTime;
      final String monthYear =
          '${_getMonthName(timestamp.month)} ${timestamp.year}';

      if (!_groupedHistory.containsKey(monthYear)) {
        _groupedHistory[monthYear] = [];
      }
      _groupedHistory[monthYear]!.add(scan);
    }

    // Sort months by date (newest first)
    final sortedKeys = _groupedHistory.keys.toList()
      ..sort((a, b) {
        final aDate = _parseMonthYear(a);
        final bDate = _parseMonthYear(b);
        return bDate.compareTo(aDate);
      });

    final sortedMap = <String, List<Map<String, dynamic>>>{};
    for (String key in sortedKeys) {
      sortedMap[key] = _groupedHistory[key]!;
    }
    _groupedHistory = sortedMap;
  }

  DateTime _parseMonthYear(String monthYear) {
    final parts = monthYear.split(' ');
    final month = _getMonthNumber(parts[0]);
    final year = int.parse(parts[1]);
    return DateTime(year, month);
  }

  int _getMonthNumber(String monthName) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months.indexOf(monthName) + 1;
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  void _onScroll() {
    // Handle scroll events for potential pagination
  }

  void _applyFilters() {
    setState(() {
      _filteredHistory = _allScanHistory.where((scan) {
        // Search query filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          if (!scan['disease'].toString().toLowerCase().contains(query) &&
              !scan['location'].toString().toLowerCase().contains(query) &&
              !scan['date'].toString().toLowerCase().contains(query)) {
            return false;
          }
        }

        // Disease type filter
        if (_activeFilters['diseases'] != null &&
            (_activeFilters['diseases'] as List).isNotEmpty) {
          if (!(_activeFilters['diseases'] as List).contains(scan['disease'])) {
            return false;
          }
        }

        // Confidence level filter
        if (_activeFilters['confidenceLevels'] != null &&
            (_activeFilters['confidenceLevels'] as List).isNotEmpty) {
          final confidence = scan['confidence'] as double;
          bool matchesConfidence = false;

          for (String level in _activeFilters['confidenceLevels'] as List) {
            if (level.contains('High') && confidence >= 0.8) {
              matchesConfidence = true;
              break;
            } else if (level.contains('Medium') &&
                confidence >= 0.6 &&
                confidence < 0.8) {
              matchesConfidence = true;
              break;
            } else if (level.contains('Low') && confidence < 0.6) {
              matchesConfidence = true;
              break;
            }
          }

          if (!matchesConfidence) return false;
        }

        // Location filter
        if (_activeFilters['location'] != null &&
            _activeFilters['location'].toString().isNotEmpty) {
          if (!scan['location']
              .toString()
              .toLowerCase()
              .contains(_activeFilters['location'].toString().toLowerCase())) {
            return false;
          }
        }

        // Date range filter
        if (_activeFilters['dateRange'] != null) {
          final dateRange = _activeFilters['dateRange'] as DateTimeRange;
          final scanDate = scan['timestamp'] as DateTime;
          if (scanDate.isBefore(dateRange.start) ||
              scanDate.isAfter(dateRange.end)) {
            return false;
          }
        }

        return true;
      }).toList();

      _sortHistory();
      _groupHistoryByMonth();
      _initializeExpandedMonths();
    });
  }

  void _sortHistory() {
    switch (_sortBy) {
      case 'newest':
        _filteredHistory.sort((a, b) =>
            (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
        break;
      case 'oldest':
        _filteredHistory.sort((a, b) =>
            (a['timestamp'] as DateTime).compareTo(b['timestamp'] as DateTime));
        break;
      case 'disease':
        _filteredHistory.sort((a, b) =>
            a['disease'].toString().compareTo(b['disease'].toString()));
        break;
      case 'confidence':
        _filteredHistory.sort((a, b) =>
            (b['confidence'] as double).compareTo(a['confidence'] as double));
        break;
    }
  }

  Future<void> _refreshHistory() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network refresh
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 80.h,
        child: FilterBottomSheet(
          currentFilters: _activeFilters,
          onFiltersApplied: (filters) {
            setState(() {
              _activeFilters = filters;
            });
            _applyFilters();
          },
        ),
      ),
    );
  }

  void _deleteScan(int scanId) {
    setState(() {
      _allScanHistory.removeWhere((scan) => scan['id'] == scanId);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scan result deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Implement undo functionality
          },
        ),
      ),
    );
  }

  void _shareScan(Map<String, dynamic> scan) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${scan['disease']} scan result...'),
      ),
    );
  }

  void _viewScanDetails(Map<String, dynamic> scan) {
    Navigator.pushNamed(context, '/disease-detection-results', arguments: scan);
  }

  void _startScan() {
    Navigator.pushNamed(context, '/camera-scan-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'CassavaGuard',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              // Export functionality
              _showExportDialog();
            },
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings-panel');
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home-dashboard');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/camera-scan-screen');
                break;
              case 2:
                // Already on History tab
                break;
            }
          },
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'home',
                color: _tabController.index == 0
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              text: 'Home',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'camera_alt',
                color: _tabController.index == 1
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              text: 'Scan',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'history',
                color: _tabController.index == 2
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              text: 'History',
            ),
          ],
        ),
      ),
      body: _filteredHistory.isEmpty
          ? EmptyHistoryState(onStartScan: _startScan)
          : Column(
              children: [
                // Search and Filter Bar
                SearchFilterBar(
                  onSearchChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                    _applyFilters();
                  },
                  onSortChanged: (sortBy) {
                    setState(() {
                      _sortBy = sortBy;
                    });
                    _applyFilters();
                  },
                  onFilterTap: _showFilterBottomSheet,
                ),

                // Online/Offline Status
                if (!_isOnline)
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    color: Colors.orange.withValues(alpha: 0.1),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'cloud_off',
                          color: Colors.orange,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Offline mode - Some features may be limited',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange.shade700,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                // History List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshHistory,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: _isRefreshing
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount:
                                _groupedHistory.length * 2, // Headers + content
                            itemBuilder: (context, index) {
                              if (index.isEven) {
                                // Month header
                                final monthIndex = index ~/ 2;
                                final monthYear =
                                    _groupedHistory.keys.elementAt(monthIndex);
                                final scanCount =
                                    _groupedHistory[monthYear]!.length;
                                final isExpanded =
                                    _expandedMonths[monthYear] ?? true;

                                return MonthlyGroupHeader(
                                  monthYear: monthYear,
                                  scanCount: scanCount,
                                  isExpanded: isExpanded,
                                  onToggle: () {
                                    setState(() {
                                      _expandedMonths[monthYear] = !isExpanded;
                                    });
                                  },
                                );
                              } else {
                                // Scan results for the month
                                final monthIndex = index ~/ 2;
                                final monthYear =
                                    _groupedHistory.keys.elementAt(monthIndex);
                                final isExpanded =
                                    _expandedMonths[monthYear] ?? true;

                                if (!isExpanded) {
                                  return SizedBox.shrink();
                                }

                                final scans = _groupedHistory[monthYear]!;
                                return Column(
                                  children: scans
                                      .map((scan) => ScanResultCard(
                                            scanData: scan,
                                            onTap: () => _viewScanDetails(scan),
                                            onDelete: () =>
                                                _deleteScan(scan['id']),
                                            onShare: () => _shareScan(scan),
                                          ))
                                      .toList(),
                                );
                              }
                            },
                          ),
                  ),
                ),
              ],
            ),
      floatingActionButton: _filteredHistory.isNotEmpty
          ? FloatingActionButton(
              onPressed: _startScan,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              child: CustomIconWidget(
                iconName: 'camera_alt',
                color: Colors.white,
                size: 6.w,
              ),
            )
          : null,
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Export Scan History',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'description',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                title: Text('Export as PDF Report'),
                onTap: () {
                  Navigator.pop(context);
                  _exportAsPDF();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'table_chart',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                title: Text('Export as CSV'),
                onTap: () {
                  Navigator.pop(context);
                  _exportAsCSV();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _exportAsPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating PDF report...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _exportAsCSV() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting CSV file...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
