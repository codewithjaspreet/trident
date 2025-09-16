import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ComingSoonPage extends StatelessWidget {
  final String featureName;
  final String description;

  const ComingSoonPage({
    super.key,
    this.featureName = "New Feature",
    this.description = "We're working hard to bring you something amazing!",
  });

  @override
  Widget build(BuildContext context) {
    final userRole = GetStorage().read('user_role') ?? 'driver';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Icon Container
                TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 2),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.3),
                              blurRadius: 20.r,
                              offset: Offset(0, 10.h),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getFeatureIcon(userRole),
                          size: 50.sp,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 40.h),

                // Coming Soon Text
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16.h),

                // Feature Name
                Text(
                  _getFeatureName(userRole),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B82F6),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Description
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withOpacity(0.04),
                        blurRadius: 8.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _getFeatureDescription(userRole),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF64748B),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 20.h),

                      // Feature Highlights
                      _buildFeatureHighlights(userRole),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),

                // Progress Indicator
                _buildProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getFeatureIcon(String userRole) {
    switch (userRole) {
      case 'admin':
        return Icons.analytics_outlined;
      case 'driver':
        return Icons.upcoming_outlined;
      default:
        return Icons.insights_outlined;
    }
  }

  String _getFeatureName(String userRole) {
    switch (userRole) {
      case 'admin':
        return 'Advanced Analytics';
      case 'driver':
        return 'Upcoming Trips';
      default:
        return 'Insights Dashboard';
    }
  }

  String _getFeatureDescription(String userRole) {
    switch (userRole) {
      case 'admin':
        return 'Get powerful insights into your fleet operations with advanced analytics, performance metrics, and predictive dashboards.';
      case 'driver':
        return 'View your upcoming trips, route optimizations, and personalized schedule management all in one place.';
      default:
        return 'Access comprehensive insights and analytics to optimize your trip management and performance tracking.';
    }
  }

  Widget _buildFeatureHighlights(String userRole) {
    List<String> features;

    switch (userRole) {
      case 'admin':
        features = [
          'Real-time fleet analytics',
          'Performance dashboards',
          'Predictive insights',
          'Cost optimization tools',
        ];
        break;
      case 'driver':
        features = [
          'Upcoming trip notifications',
          'Route optimization',
          'Schedule management',
          'Performance tracking',
        ];
        break;
      default:
        features = [
          'Trip insights',
          'Performance metrics',
          'Trend analysis',
          'Custom reports',
        ];
    }

    return Column(
      children: features
          .map((feature) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF374151),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Development Progress',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
              ),
            ),
            Text(
              '75%',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
      ],
    );
  }

}
