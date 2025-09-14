import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/captured_image_widget.dart';
import './widgets/detailed_results_widget.dart';
import './widgets/disease_classification_widget.dart';
import './widgets/treatment_recommendations_widget.dart';

class DiseaseDetectionResults extends StatefulWidget {
  const DiseaseDetectionResults({Key? key}) : super(key: key);

  @override
  State<DiseaseDetectionResults> createState() =>
      _DiseaseDetectionResultsState();
}

class _DiseaseDetectionResultsState extends State<DiseaseDetectionResults>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Mock detection results data
  final Map<String, dynamic> detectionResults = {
    "imagePath":
        "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "primaryClassification": {
      "name": "Cassava Mosaic Disease",
      "confidence": 0.87,
      "severity": "mild"
    },
    "timestamp": DateTime.now(),
    "location": "Farm Location: 6.5244° N, 3.3792° E"
  };

  final List<Map<String, dynamic>> secondaryClassifications = [
    {"name": "Cassava Brown Streak Disease", "probability": 0.12},
    {"name": "Cassava Bacterial Blight", "probability": 0.08},
    {"name": "Healthy Cassava", "probability": 0.05},
  ];

  final List<Map<String, dynamic>> treatmentRecommendations = [
    {
      "title": "Remove Infected Plants",
      "description":
          "Immediately remove and destroy infected plants to prevent spread of the mosaic virus to healthy cassava plants.",
      "type": "prevention",
      "difficulty": "easy",
      "timeline": "1-2 days",
      "steps": [
        "Identify infected plants with mosaic symptoms",
        "Carefully uproot infected plants",
        "Burn or bury infected plant material",
        "Disinfect tools after use",
        "Monitor surrounding plants daily"
      ]
    },
    {
      "title": "Plant Resistant Varieties",
      "description":
          "Use cassava varieties that are resistant to mosaic virus for future planting to reduce disease incidence.",
      "type": "prevention",
      "difficulty": "medium",
      "timeline": "Next season",
      "steps": [
        "Source certified resistant varieties",
        "Prepare planting materials properly",
        "Plant during optimal season",
        "Maintain proper spacing",
        "Monitor for disease symptoms"
      ]
    },
    {
      "title": "Vector Control",
      "description":
          "Control whitefly populations that spread the mosaic virus using integrated pest management approaches.",
      "type": "organic",
      "difficulty": "medium",
      "timeline": "2-4 weeks",
      "steps": [
        "Apply neem oil spray weekly",
        "Use yellow sticky traps",
        "Encourage beneficial insects",
        "Remove weed hosts nearby",
        "Monitor whitefly populations"
      ]
    },
    {
      "title": "Soil Health Management",
      "description":
          "Improve soil health and plant nutrition to help cassava plants better resist disease infections.",
      "type": "cultural",
      "difficulty": "easy",
      "timeline": "Ongoing",
      "steps": [
        "Apply organic compost",
        "Maintain proper drainage",
        "Practice crop rotation",
        "Test soil pH regularly",
        "Add organic matter seasonally"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _triggerHapticFeedback();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();
  }

  void _triggerHapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _handleSaveToHistory() {
    // Simulate saving to local database
    final historyEntry = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "imagePath": detectionResults["imagePath"],
      "diseaseName": detectionResults["primaryClassification"]["name"],
      "confidence": detectionResults["primaryClassification"]["confidence"],
      "severity": detectionResults["primaryClassification"]["severity"],
      "timestamp": detectionResults["timestamp"],
      "location": detectionResults["location"],
    };

    // In a real app, this would save to local storage/database
    print("Saving to history: \$historyEntry");
  }

  void _handleShareResults() {
    final summary = _generateResultSummary();

    // In a real app, this would use native sharing
    Clipboard.setData(ClipboardData(text: summary));
    Fluttertoast.showToast(
      msg: "Results copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
    );
  }

  String _generateResultSummary() {
    final classification = detectionResults["primaryClassification"];
    return """
🌿 CassavaGuard Disease Detection Results

📊 Primary Classification: ${classification["name"]}
🎯 Confidence: ${(classification["confidence"] * 100).toStringAsFixed(1)}%
⚠️ Severity: ${classification["severity"].toString().toUpperCase()}
📅 Date: ${DateTime.now().toString().split(' ')[0]}
📍 ${detectionResults["location"]}

💡 Key Recommendations:
• Remove infected plants immediately
• Use resistant varieties for replanting
• Control whitefly vectors
• Improve soil health management

Generated by CassavaGuard - AI-powered cassava disease detection
    """
        .trim();
  }

  void _handleScanAnother() {
    Navigator.pushReplacementNamed(context, '/camera-scan-screen');
  }

  void _handleRetakePhoto() {
    Navigator.pushReplacementNamed(context, '/camera-scan-screen');
  }

  @override
  Widget build(BuildContext context) {
    final classification = detectionResults["primaryClassification"];

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Detection Results',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'home',
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/home-dashboard',
              (route) => false,
            ),
          ),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Captured Image Section
                    CapturedImageWidget(
                      imagePath: detectionResults["imagePath"] as String?,
                      onRetake: _handleRetakePhoto,
                    ),

                    SizedBox(height: 2.h),

                    // Primary Disease Classification
                    DiseaseClassificationWidget(
                      diseaseName: classification["name"] as String,
                      confidence: classification["confidence"] as double,
                      severity: classification["severity"] as String,
                    ),

                    SizedBox(height: 2.h),

                    // Detailed Results (Expandable)
                    DetailedResultsWidget(
                      secondaryClassifications: secondaryClassifications,
                    ),

                    SizedBox(height: 2.h),

                    // Treatment Recommendations
                    TreatmentRecommendationsWidget(
                      recommendations: treatmentRecommendations,
                    ),

                    SizedBox(height: 2.h),

                    // Additional Information
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'info',
                                size: 20,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Scan Information',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          _buildInfoRow('Scan Date',
                              DateTime.now().toString().split(' ')[0]),
                          _buildInfoRow(
                              'Scan Time',
                              DateTime.now()
                                  .toString()
                                  .split(' ')[1]
                                  .substring(0, 8)),
                          _buildInfoRow('Location',
                              detectionResults["location"] as String),
                          _buildInfoRow('Model Version', 'CassavaGuard v2.1'),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Offline Mode Indicator (if applicable)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.warningLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.warningLight.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'wifi_off',
                            size: 18,
                            color: AppTheme.warningLight,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Results generated offline. Sync when connected for updated recommendations.',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.warningLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h), // Space for bottom action bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ActionButtonsWidget(
        onSaveToHistory: _handleSaveToHistory,
        onShareResults: _handleShareResults,
        onScanAnother: _handleScanAnother,
        resultSummary: _generateResultSummary(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              '$label:',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
