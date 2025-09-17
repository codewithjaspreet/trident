// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:trident/features/dashboard/widgets/mobile/driver_trip_tracking.dart';
// import 'package:trident/features/dashboard/widgets/mobile/trip_edit_screen.dart';
// import 'package:trident/utils/helpers/helper_functions.dart';
// import '../../../dashboard/controllers/dashboard_controller.dart';
// import '../../controllers/trip_controller.dart';
//
// /// Main trips management screen with professional UI design and role-based features
// class TripsManagementScreen extends StatelessWidget {
//   const TripsManagementScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final DashBoardController controller = Get.find<DashBoardController>();
//     final TripController tripController = Get.put(TripController());
//     final userRole = GetStorage().read('user_role') ?? 'driver';
//
//     return DefaultTabController(
//       length: _getTabCount(userRole),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF8FAFC),
//         body: Column(
//           children: [
//             _buildTabBar(userRole),
//             Expanded(
//               child: TabBarView(
//                 children: _buildTabViews(controller, tripController, userRole),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   int _getTabCount(String userRole) {
//     // Driver has 7 tabs (removes "In Review")
//     // Other roles have 8 tabs (all tabs)
//     return userRole == 'driver' ? 7 : 8;
//   }
//
//   List<Widget> _buildTabViews(DashBoardController controller,
//       TripController tripController, String userRole) {
//     if (userRole == 'driver') {
//       // Driver tabs (without In Review)
//       return [
//         _buildTabContent(controller, tripController, 'all', userRole),
//         _buildTabContent(controller, tripController, 'Completed', userRole),
//         _buildTabContent(controller, tripController, 'Open', userRole),
//         _buildTabContent(controller, tripController, 'Vehicle Dock', userRole),
//         _buildTabContent(
//             controller, tripController, 'Vehicle Loading', userRole),
//         _buildTabContent(controller, tripController, 'Dispatch', userRole),
//         _buildTabContent(
//             controller, tripController, 'Vehicle Return', userRole),
//       ];
//     } else {
//       // All other roles (with In Review)
//       return [
//         _buildTabContent(controller, tripController, 'all', userRole),
//         _buildTabContent(controller, tripController, 'in_review', userRole),
//         _buildTabContent(controller, tripController, 'Completed', userRole),
//         _buildTabContent(controller, tripController, 'Open', userRole),
//         _buildTabContent(controller, tripController, 'Vehicle Dock', userRole),
//         _buildTabContent(
//             controller, tripController, 'Vehicle Loading', userRole),
//         _buildTabContent(controller, tripController, 'Dispatch', userRole),
//         _buildTabContent(
//             controller, tripController, 'Vehicle Return', userRole),
//       ];
//     }
//   }
//
//   Widget _buildHeader(DashBoardController controller,
//       TripController tripController, String userRole) {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Filter status indicator
//           Obx(() => _buildActiveFiltersIndicator(tripController)),
//           _buildActionButtons(controller, tripController, userRole),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActiveFiltersIndicator(TripController tripController) {
//     final hasActiveFilters = tripController.searchQuery.value.isNotEmpty ||
//         tripController.selectedDateFilter.value != 'all' ||
//         tripController.selectedStatusFilter.value != 'all' ||
//         tripController.selectedDriverFilter.value != 'all' ||
//         tripController.selectedSortBy.value != 'date_newest';
//
//     if (!hasActiveFilters) return const SizedBox.shrink();
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//       decoration: BoxDecoration(
//         color: const Color(0xFF3B82F6).withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.filter_alt,
//             size: 14.sp,
//             color: const Color(0xFF3B82F6),
//           ),
//           SizedBox(width: 4.w),
//           Text(
//             'Filters Active',
//             style: TextStyle(
//               fontSize: 11.sp,
//               fontWeight: FontWeight.w600,
//               color: const Color(0xFF3B82F6),
//             ),
//           ),
//           SizedBox(width: 4.w),
//           GestureDetector(
//             onTap: () => tripController.clearAllFilters(),
//             child: Icon(
//               Icons.close,
//               size: 14.sp,
//               color: const Color(0xFF3B82F6),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButtons(DashBoardController controller,
//       TripController tripController, String userRole) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildActionButton(
//           Icons.tune_rounded,
//           const Color(0xFF3B82F6),
//           () => _showFilterSheet(tripController, userRole),
//         ),
//         SizedBox(width: 8.w),
//         _buildActionButton(
//           Icons.sort_rounded,
//           const Color(0xFFF59E0B),
//           () => _showSortSheet(tripController),
//         ),
//         SizedBox(width: 8.w),
//         _buildActionButton(
//           Icons.refresh_rounded,
//           const Color(0xFF10B981),
//           () => _refreshTrips(controller),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
//     return Material(
//       color: color.withOpacity(0.08),
//       shape: const CircleBorder(),
//       child: InkWell(
//         customBorder: const CircleBorder(),
//         onTap: onTap,
//         child: SizedBox(
//           width: 42.w,
//           height: 42.w,
//           child: Center(
//             child: Icon(
//               icon,
//               size: 20.sp,
//               color: color,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSearchBar(TripController tripController) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
//       child: TextField(
//         controller: tripController.searchController,
//         decoration: InputDecoration(
//           hintText: 'Search by destination, driver, vehicle...',
//           hintStyle: TextStyle(
//             fontSize: 13.sp,
//             color: const Color(0xFF94A3B8),
//           ),
//           prefixIcon: Icon(
//             Icons.search_rounded,
//             size: 20.sp,
//             color: const Color(0xFF94A3B8),
//           ),
//           suffixIcon: Obx(() => tripController.searchQuery.value.isNotEmpty
//               ? GestureDetector(
//                   onTap: () {
//                     tripController.searchController.clear();
//                   },
//                   child: Icon(
//                     Icons.clear_rounded,
//                     size: 20.sp,
//                     color: const Color(0xFF94A3B8),
//                   ),
//                 )
//               : const SizedBox.shrink()),
//           filled: true,
//           fillColor: Colors.transparent,
//           contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.w),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.r),
//             borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.r),
//             borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
//           ),
//         ),
//         style: TextStyle(
//           fontSize: 13.sp,
//           color: const Color(0xFF1E293B),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabBar(String userRole) {
//     return Container(
//       color: Colors.white,
//       child: TabBar(
//         isScrollable: true,
//         indicatorColor: const Color(0xFF3B82F6),
//         indicatorWeight: 3.h,
//         indicatorPadding: EdgeInsets.symmetric(horizontal: 8.w),
//         labelColor: const Color(0xFF3B82F6),
//         unselectedLabelColor: const Color(0xFF64748B),
//         labelStyle: TextStyle(
//           fontSize: 13.sp,
//           fontWeight: FontWeight.w600,
//         ),
//         unselectedLabelStyle: TextStyle(
//           fontSize: 13.sp,
//           fontWeight: FontWeight.w500,
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 12.w),
//         tabAlignment: TabAlignment.start,
//         tabs: _buildTabs(userRole),
//       ),
//     );
//   }
//
//   List<Widget> _buildTabs(String userRole) {
//     if (userRole == 'driver') {
//       // Driver tabs (without In Review)
//       return [
//         _buildTab('All', Icons.view_list_rounded, const Color(0xFF3B82F6)),
//         _buildTab('Completed', Icons.check_circle_outline_rounded,
//             const Color(0xFF10B981)),
//         _buildTab('Open', Icons.radio_button_unchecked_rounded,
//             const Color(0xFF8B5CF6)),
//         _buildTab(
//             'Dock', Icons.local_shipping_outlined, const Color(0xFF06B6D4)),
//         _buildTab(
//             'Loading', Icons.inventory_2_outlined, const Color(0xFFEF4444)),
//         _buildTab(
//             'Dispatch', Icons.local_shipping_outlined, const Color(0xFF8B5CF6)),
//         _buildTab('Return', Icons.home_outlined, const Color(0xFF10B981)),
//       ];
//     } else {
//       // All other roles (with In Review)
//       return [
//         _buildTab('All', Icons.view_list_rounded, const Color(0xFF3B82F6)),
//         _buildTab('In Review', Icons.pending_actions_rounded,
//             const Color(0xFFF59E0B)),
//         _buildTab('Completed', Icons.check_circle_outline_rounded,
//             const Color(0xFF10B981)),
//         _buildTab('Open', Icons.radio_button_unchecked_rounded,
//             const Color(0xFF8B5CF6)),
//         _buildTab(
//             'Dock', Icons.local_shipping_outlined, const Color(0xFF06B6D4)),
//         _buildTab(
//             'Loading', Icons.inventory_2_outlined, const Color(0xFFEF4444)),
//         _buildTab(
//             'Dispatch', Icons.local_shipping_outlined, const Color(0xFF8B5CF6)),
//         _buildTab('Return', Icons.home_outlined, const Color(0xFF10B981)),
//       ];
//     }
//   }
//
//   Widget _buildTab(String title, IconData icon, Color color) {
//     return Tab(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 16.sp),
//             SizedBox(width: 6.w),
//             Text(title),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabContent(DashBoardController controller,
//       TripController tripController, String status, String userRole) {
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return _buildLoadingState();
//       }
//
//       print('STATUS IS - $status');
//
//       final filteredTrips = tripController.getFilteredTripsForStatus(
//           controller.allCreatedTrips, status);
//
//       return Column(
//         children: [
//           _buildSearchBar(tripController),
//           _buildHeader(controller, tripController, userRole),
//           if (filteredTrips.isEmpty)
//             Expanded(child: _buildEmptyState(status))
//           else
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.all(16.w),
//                 itemCount: filteredTrips.length,
//                 itemBuilder: (context, index) {
//                   return TripCard(
//                     trip: filteredTrips[index],
//                     index: index,
//                     userRole: userRole, // Pass user role to trip card
//                   );
//                 },
//               ),
//             ),
//         ],
//       );
//     });
//   }
//
//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
//             strokeWidth: 3.w,
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             'Loading trips...',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: const Color(0xFF64748B),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState(String status) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.inbox_outlined,
//             size: 64.sp,
//             color: const Color(0xFFCBD5E1),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             'No ${status == 'all' ? '' : status.replaceAll('_', ' ')} trips found',
//             style: TextStyle(
//               fontSize: 16.sp,
//               color: const Color(0xFF64748B),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             'Try adjusting your search or filters',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: const Color(0xFF94A3B8),
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showFilterSheet(TripController tripController, String userRole) {
//     Get.bottomSheet(
//       FilterBottomSheet(tripController: tripController, userRole: userRole),
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//     );
//   }
//
//   void _showSortSheet(TripController tripController) {
//     Get.bottomSheet(
//       SortBottomSheet(tripController: tripController),
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   void _refreshTrips(DashBoardController controller) async {
//     controller.isLoading.value = true;
//     final role = GetStorage().read('user_role');
//
//     if (role == 'driver') {
//       await controller.getAllDriverAssignedTrips();
//     } else {
//       await controller.getAllCreatedTrips();
//     }
//
//     controller.isLoading.value = false;
//   }
// }
//
// /// Professional trip card with clean design and role-based actions
// class TripCard extends StatelessWidget {
//   const TripCard({
//     super.key,
//     required this.trip,
//     required this.index,
//     required this.userRole,
//   });
//
//   final dynamic trip;
//   final int index;
//   final String userRole;
//
//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       duration: Duration(milliseconds: 200 + (index * 50)),
//       tween: Tween(begin: 0.0, end: 1.0),
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(0, (1 - value) * 20),
//           child: Opacity(
//             opacity: value,
//             child: Container(
//               margin: EdgeInsets.only(bottom: 12.h),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16.r),
//                 border: Border.all(
//                   color: const Color(0xFFF1F5F9),
//                   width: 1,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF0F172A).withOpacity(0.04),
//                     blurRadius: 8.r,
//                     offset: Offset(0, 2.h),
//                   ),
//                 ],
//               ),
//               child: _buildCardContent(),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildCardContent() {
//     final destination = trip.destination?.toString() ?? 'Unknown Destination';
//     final driverName = trip.driverName?.toString() ?? 'SANJAY RATHOUR';
//     final createdAt = trip.createdAt?.toString() ?? '2025-09-10';
//     final status = trip.status?.toString().toLowerCase() ?? 'open';
//
//     return GestureDetector(
//       onTap: () => _onTripCardTap(),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Row with Status and Trip Code
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       destination,
//                       style: TextStyle(
//                         fontSize: 13.sp,
//                         fontWeight: FontWeight.w700,
//                         color: const Color(0xFF0F172A),
//                         fontFamily: 'SF Pro Display',
//                         height: 1.2,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   _buildStatusBadge(status),
//                 ],
//               ),
//
//               SizedBox(height: 12.h),
//
//               // Vertical Data Layout
//               Column(
//                 children: [
//                   _buildEnhancedDataRow(
//                     'Driver',
//                     driverName,
//                     Icons.person_outline_rounded,
//                   ),
//                   SizedBox(height: 8.h),
//                   _buildEnhancedDataRow(
//                     'Date & Time',
//                     THelperFunctions.formatIndianDateTime(createdAt),
//                     Icons.schedule_rounded,
//                   ),
//                   SizedBox(height: 8.h),
//                   _buildEnhancedDataRow(
//                     'Vehicle',
//                     trip.billedVehicle?.toString() ?? 'Not Assigned',
//                     Icons.local_shipping_outlined,
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 12.h),
//
//               // Action Indicator
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Tap to view details',
//                     style: TextStyle(
//                       fontSize: 11.sp,
//                       color: const Color(0xFF94A3B8),
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.italic,
//                       fontFamily: 'SF Pro Text',
//                     ),
//                   ),
//                   Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 12.sp,
//                     color: const Color(0xFF94A3B8),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Builds an enhanced data row with better styling and spacing
//   Widget _buildEnhancedDataRow(String label, String value, IconData icon) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Icon with background
//         Container(
//           width: 18.w,
//           height: 18.w,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(7.r),
//           ),
//           child: Icon(
//             icon,
//             size: 12.sp,
//           ),
//         ),
//
//         SizedBox(width: 8.w),
//
//         // Label with fixed width
//         SizedBox(
//           width: 110.w,
//           child: Text(
//             '$label:',
//             style: TextStyle(
//               fontSize: 10.sp,
//               color: const Color(0xFF64748B),
//               fontWeight: FontWeight.w500,
//               fontFamily: 'SF Pro Text',
//             ),
//           ),
//         ),
//
//         SizedBox(width: 8.w),
//
//         // Value with flexible width
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: 10.sp,
//               color: const Color(0xFF1E293B),
//               fontWeight: FontWeight.w600,
//               fontFamily: 'SF Pro Text',
//               height: 1.2,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Handles trip card tap action with role-based options
//   void _onTripCardTap() {
//     // Add haptic feedback
//     HapticFeedback.lightImpact();
//
//     // Show trip actions bottom sheet with role-based actions
//     _showTripActionsBottomSheet();
//   }
//
//   /// Shows quick actions bottom sheet with role-based options
//   void _showTripActionsBottomSheet() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: EdgeInsets.all(20.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     trip.destination?.toString() ?? 'Trip Details',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xFF0F172A),
//                       fontFamily: 'SF Pro Display',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Always show "View Full Details" for all roles
//             _buildActionTile(
//               'View Full Details',
//               'See complete trip information',
//               Icons.visibility_outlined,
//               const Color(0xFF3B82F6),
//               () {
//                 final dashboardController = Get.find<DashBoardController>();
//                 Get.to(const TripTimelineScreen(), arguments: [
//                   trip.source,
//                   trip.destination,
//                   trip.billedTo,
//                   trip.createdAt,
//                   dashboardController.loggedInUser.value.userRole
//                 ]);
//               },
//             ),
//             // Only show "Edit Trip" for non-driver roles
//             if (userRole != 'driver')
//               _buildActionTile(
//                 'Edit Trip',
//                 'Modify trip details',
//                 Icons.edit_outlined,
//                 const Color(0xFFF59E0B),
//                 () {
//                   Get.to(TripEditScreen(trip: trip));
//                 },
//               ),
//             SizedBox(height: 20.h),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   /// Builds action tile for bottom sheet
//   Widget _buildActionTile(
//     String title,
//     String subtitle,
//     IconData icon,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return ListTile(
//       leading: Container(
//         width: 40.w,
//         height: 40.w,
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(10.r),
//         ),
//         child: Icon(
//           icon,
//           size: 20.sp,
//           color: color,
//         ),
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w600,
//           color: const Color(0xFF0F172A),
//           fontFamily: 'SF Pro Text',
//         ),
//       ),
//       subtitle: Text(
//         subtitle,
//         style: TextStyle(
//           fontSize: 12.sp,
//           color: const Color(0xFF64748B),
//           fontFamily: 'SF Pro Text',
//         ),
//       ),
//       trailing: Icon(
//         Icons.arrow_forward_ios_rounded,
//         size: 14.sp,
//         color: const Color(0xFF94A3B8),
//       ),
//       onTap: onTap,
//     );
//   }
//
//   Widget _buildStatusBadge(String status) {
//     final statusData = _getStatusData(status);
//
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 10.w,
//         vertical: 4.h,
//       ),
//       decoration: BoxDecoration(
//         color: statusData['color'].withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: statusData['color'].withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Text(
//         statusData['text'],
//         style: TextStyle(
//           fontSize: 11.sp,
//           fontWeight: FontWeight.w600,
//           color: statusData['color'],
//         ),
//       ),
//     );
//   }
//
//   Map<String, dynamic> _getStatusData(String status) {
//     switch (status) {
//       case 'completed':
//         return {'text': 'Completed', 'color': const Color(0xFF10B981)};
//       case 'in_review':
//       case 'in review':
//         return {'text': 'In Review', 'color': const Color(0xFFF59E0B)};
//       case 'open':
//         return {'text': 'Open', 'color': const Color(0xFF3B82F6)};
//       case 'vehicle_dock':
//       case 'vehicle dock':
//         return {'text': 'At Dock', 'color': const Color(0xFF06B6D4)};
//       case 'vehicle_loading':
//       case 'vehicle loading':
//         return {'text': 'Loading', 'color': const Color(0xFFEF4444)};
//       case 'dispatch':
//         return {'text': 'Dispatch', 'color': const Color(0xFF8B5CF6)};
//       case 'vehicle_return':
//       case 'vehicle return':
//         return {'text': 'Return', 'color': const Color(0xFF10B981)};
//       default:
//         return {'text': 'Unknown', 'color': const Color(0xFF8B5CF6)};
//     }
//   }
// }
//
// /// Advanced filter bottom sheet with role-based filtering
// class FilterBottomSheet extends StatelessWidget {
//   final TripController tripController;
//   final String userRole;
//
//   const FilterBottomSheet({
//     super.key,
//     required this.tripController,
//     required this.userRole,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildHeader(),
//           _buildContent(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: const BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: Color(0xFFE2E8F0),
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               'Filter Trips',
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF0F172A),
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () => Get.back(),
//             child: Icon(
//               Icons.close_rounded,
//               size: 24.sp,
//               color: const Color(0xFF64748B),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContent() {
//     return Padding(
//       padding: EdgeInsets.all(20.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildFilterSection(
//             'Date Range',
//             tripController.dateFilterOptions,
//             tripController.selectedDateFilter,
//             tripController.updateDateFilter,
//           ),
//           SizedBox(height: 24.h),
//           _buildFilterSection(
//             'Status',
//             tripController.statusFilterOptions,
//             tripController.selectedStatusFilter,
//             tripController.updateStatusFilter,
//           ),
//           SizedBox(height: 24.h),
//           // Only show driver filter for non-driver roles
//           if (userRole != 'driver') ...[
//             _buildDriverFilterSection(),
//             SizedBox(height: 24.h),
//           ],
//           SizedBox(height: 8.h),
//           _buildActionButtons(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterSection(
//     String title,
//     List<Map<String, String>> options,
//     RxString selectedValue,
//     Function(String) onChanged,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF374151),
//           ),
//         ),
//         SizedBox(height: 12.h),
//         Obx(() => Wrap(
//               spacing: 8.w,
//               runSpacing: 8.h,
//               children: options.map((option) {
//                 final isSelected = selectedValue.value == option['value'];
//
//                 return FilterChip(
//                   label: Text(
//                     option['label']!,
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w500,
//                       color:
//                           isSelected ? Colors.white : const Color(0xFF374151),
//                     ),
//                   ),
//                   selected: isSelected,
//                   selectedColor: const Color(0xFF3B82F6),
//                   backgroundColor: const Color(0xFFF8FAFC),
//                   side: BorderSide(
//                     color: isSelected
//                         ? const Color(0xFF3B82F6)
//                         : const Color(0xFFE2E8F0),
//                     width: 1,
//                   ),
//                   onSelected: (selected) {
//                     if (selected) {
//                       onChanged(option['value']!);
//                     }
//                   },
//                 );
//               }).toList(),
//             )),
//       ],
//     );
//   }
//
//   Widget _buildDriverFilterSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Driver',
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF374151),
//           ),
//         ),
//         SizedBox(height: 12.h),
//         Obx(() {
//           final dashboardController = Get.find<DashBoardController>();
//           final drivers = tripController
//               .getUniqueDriversFromTrips(dashboardController.allCreatedTrips);
//
//           final driverOptions = [
//             {'value': 'all', 'label': 'All Drivers'},
//             ...drivers.map((driver) => {'value': driver, 'label': driver}),
//           ];
//
//           return Wrap(
//             spacing: 8.w,
//             runSpacing: 8.h,
//             children: driverOptions.map((option) {
//               final isSelected =
//                   tripController.selectedDriverFilter.value == option['value'];
//
//               return FilterChip(
//                 label: Text(
//                   option['label']!,
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w500,
//                     color: isSelected ? Colors.white : const Color(0xFF374151),
//                   ),
//                 ),
//                 selected: isSelected,
//                 selectedColor: const Color(0xFF3B82F6),
//                 backgroundColor: const Color(0xFFF8FAFC),
//                 side: BorderSide(
//                   color: isSelected
//                       ? const Color(0xFF3B82F6)
//                       : const Color(0xFFE2E8F0),
//                   width: 1,
//                 ),
//                 onSelected: (selected) {
//                   if (selected) {
//                     tripController.updateDriverFilter(option['value']!);
//                   }
//                 },
//               );
//             }).toList(),
//           );
//         }),
//       ],
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: () {
//               tripController.clearAllFilters();
//               Get.back();
//             },
//             style: OutlinedButton.styleFrom(
//               padding: EdgeInsets.symmetric(vertical: 14.h),
//               side: const BorderSide(color: Color(0xFFE2E8F0)),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//             ),
//             child: Text(
//               'Reset Filters',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF374151),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 12.w),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: () => Get.back(),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF3B82F6),
//               padding: EdgeInsets.symmetric(vertical: 14.h),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               elevation: 0,
//             ),
//             child: Text(
//               'Apply Filters',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// /// Sort options bottom sheet
// class SortBottomSheet extends StatelessWidget {
//   final TripController tripController;
//
//   const SortBottomSheet({super.key, required this.tripController});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: EdgeInsets.all(20.w),
//             decoration: const BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: Color(0xFFE2E8F0),
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'Sort Trips',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xFF0F172A),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () => Get.back(),
//                   child: Icon(
//                     Icons.close_rounded,
//                     size: 24.sp,
//                     color: const Color(0xFF64748B),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListView.builder(
//             shrinkWrap: true,
//             itemCount: tripController.sortOptions.length,
//             itemBuilder: (context, index) {
//               final option = tripController.sortOptions[index];
//
//               return Obx(() {
//                 final isSelected =
//                     tripController.selectedSortBy.value == option['value'];
//
//                 return ListTile(
//                   title: Text(
//                     option['label']!,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                       color: isSelected
//                           ? const Color(0xFF3B82F6)
//                           : const Color(0xFF374151),
//                     ),
//                   ),
//                   trailing: isSelected
//                       ? Icon(
//                           Icons.check_rounded,
//                           size: 20.sp,
//                           color: const Color(0xFF3B82F6),
//                         )
//                       : null,
//                   onTap: () {
//                     tripController.updateSortOption(option['value']!);
//                     Get.back();
//                   },
//                 );
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trident/features/dashboard/widgets/mobile/driver_trip_tracking.dart';
import 'package:trident/features/dashboard/widgets/mobile/trip_edit_screen.dart';
import 'package:trident/utils/helpers/helper_functions.dart';
import '../../../dashboard/controllers/dashboard_controller.dart';
import '../../controllers/trip_controller.dart';

/// Main trips management screen with professional UI design and role-based features
class TripsManagementScreen extends StatelessWidget {
  const TripsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashBoardController controller = Get.find<DashBoardController>();
    final TripController tripController = Get.put(TripController());
    final userRole = GetStorage().read('user_role') ?? 'driver';

    return DefaultTabController(
      length: _getTabCount(userRole),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            _buildTabBar(userRole),
            Expanded(
              child: TabBarView(
                children: _buildTabViews(controller, tripController, userRole),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getTabCount(String userRole) {
    // Driver has 7 tabs (removes "In Review")
    // Other roles have 8 tabs (all tabs)
    return userRole == 'driver' ? 7 : 8;
  }

  List<Widget> _buildTabViews(DashBoardController controller,
      TripController tripController, String userRole) {
    if (userRole == 'driver') {
      // Driver tabs (without In Review)
      return [
        _buildTabContent(controller, tripController, 'all', userRole),
        _buildTabContent(controller, tripController, 'Completed', userRole),
        _buildTabContent(controller, tripController, 'Open', userRole),
        _buildTabContent(controller, tripController, 'Vehicle Dock', userRole),
        _buildTabContent(
            controller, tripController, 'Vehicle Loading', userRole),
        _buildTabContent(controller, tripController, 'Dispatch', userRole),
        _buildTabContent(
            controller, tripController, 'Vehicle Return', userRole),
      ];
    } else {
      // All other roles (with In Review)
      return [
        _buildTabContent(controller, tripController, 'all', userRole),
        _buildTabContent(controller, tripController, 'in_review', userRole),
        _buildTabContent(controller, tripController, 'Completed', userRole),
        _buildTabContent(controller, tripController, 'Open', userRole),
        _buildTabContent(controller, tripController, 'Vehicle Dock', userRole),
        _buildTabContent(
            controller, tripController, 'Vehicle Loading', userRole),
        _buildTabContent(controller, tripController, 'Dispatch', userRole),
        _buildTabContent(
            controller, tripController, 'Vehicle Return', userRole),
      ];
    }
  }

  Widget _buildHeader(DashBoardController controller,
      TripController tripController, String userRole) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Filter status indicator
          Obx(() => _buildActiveFiltersIndicator(tripController)),
          _buildActionButtons(controller, tripController, userRole),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersIndicator(TripController tripController) {
    final hasActiveFilters = tripController.searchQuery.value.isNotEmpty ||
        tripController.selectedDateFilter.value != 'all' ||
        tripController.selectedStatusFilter.value != 'all' ||
        tripController.selectedDriverFilter.value != 'all' ||
        tripController.selectedSortBy.value != 'date_newest';

    if (!hasActiveFilters) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.filter_alt,
            size: 14.sp,
            color: const Color(0xFF3B82F6),
          ),
          SizedBox(width: 4.w),
          Text(
            'Filters Active',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3B82F6),
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: () => tripController.clearAllFilters(),
            child: Icon(
              Icons.close,
              size: 14.sp,
              color: const Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(DashBoardController controller,
      TripController tripController, String userRole) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          Icons.tune_rounded,
          const Color(0xFF3B82F6),
              () => _showFilterSheet(tripController, userRole),
        ),
        SizedBox(width: 8.w),
        _buildActionButton(
          Icons.sort_rounded,
          const Color(0xFFF59E0B),
              () => _showSortSheet(tripController),
        ),
        SizedBox(width: 8.w),
        _buildActionButton(
          Icons.refresh_rounded,
          const Color(0xFF10B981),
              () => _refreshTrips(controller),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: color.withOpacity(0.08),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42.w,
          height: 42.w,
          child: Center(
            child: Icon(
              icon,
              size: 20.sp,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(TripController tripController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      child: TextField(
        controller: tripController.searchController,
        decoration: InputDecoration(
          hintText: 'Search by destination, driver, vehicle...',
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF94A3B8),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20.sp,
            color: const Color(0xFF94A3B8),
          ),
          suffixIcon: Obx(() => tripController.searchQuery.value.isNotEmpty
              ? GestureDetector(
            onTap: () {
              tripController.searchController.clear();
            },
            child: Icon(
              Icons.clear_rounded,
              size: 20.sp,
              color: const Color(0xFF94A3B8),
            ),
          )
              : const SizedBox.shrink()),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.w),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
          ),
        ),
        style: TextStyle(
          fontSize: 13.sp,
          color: const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildTabBar(String userRole) {
    return Container(
      color: Colors.white,
      child: TabBar(
        isScrollable: true,
        indicatorColor: const Color(0xFF3B82F6),
        indicatorWeight: 3.h,
        indicatorPadding: EdgeInsets.symmetric(horizontal: 8.w),
        labelColor: const Color(0xFF3B82F6),
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        tabAlignment: TabAlignment.start,
        tabs: _buildTabs(userRole),
      ),
    );
  }

  List<Widget> _buildTabs(String userRole) {
    if (userRole == 'driver') {
      // Driver tabs (without In Review)
      return [
        _buildTab('All', Icons.view_list_rounded, const Color(0xFF3B82F6)),
        _buildTab('Completed', Icons.check_circle_outline_rounded,
            const Color(0xFF10B981)),
        _buildTab('Open', Icons.radio_button_unchecked_rounded,
            const Color(0xFF8B5CF6)),
        _buildTab(
            'Dock', Icons.local_shipping_outlined, const Color(0xFF06B6D4)),
        _buildTab(
            'Loading', Icons.inventory_2_outlined, const Color(0xFFEF4444)),
        _buildTab(
            'Dispatch', Icons.local_shipping_outlined, const Color(0xFF8B5CF6)),
        _buildTab('Return', Icons.home_outlined, const Color(0xFF10B981)),
      ];
    } else {
      // All other roles (with In Review)
      return [
        _buildTab('All', Icons.view_list_rounded, const Color(0xFF3B82F6)),
        _buildTab('In Review', Icons.pending_actions_rounded,
            const Color(0xFFF59E0B)),
        _buildTab('Completed', Icons.check_circle_outline_rounded,
            const Color(0xFF10B981)),
        _buildTab('Open', Icons.radio_button_unchecked_rounded,
            const Color(0xFF8B5CF6)),
        _buildTab(
            'Dock', Icons.local_shipping_outlined, const Color(0xFF06B6D4)),
        _buildTab(
            'Loading', Icons.inventory_2_outlined, const Color(0xFFEF4444)),
        _buildTab(
            'Dispatch', Icons.local_shipping_outlined, const Color(0xFF8B5CF6)),
        _buildTab('Return', Icons.home_outlined, const Color(0xFF10B981)),
      ];
    }
  }

  Widget _buildTab(String title, IconData icon, Color color) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.sp),
            SizedBox(width: 6.w),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(DashBoardController controller,
      TripController tripController, String status, String userRole) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingState();
      }

      print('STATUS IS - $status');

      // Get current user mobile for filtering
      final currentUserMobile = controller.loggedInUser.value.userMobileNumber;

      // Use updated filtering method with user exclusion for in_review
      final filteredTrips = tripController.getFilteredTripsForStatus(
        controller.allCreatedTrips,
        status,
        currentUserMobile: currentUserMobile,
      );

      return Column(
        children: [
          _buildSearchBar(tripController),
          _buildHeader(controller, tripController, userRole),
          if (filteredTrips.isEmpty)
            Expanded(child: _buildEmptyState(status))
          else
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: filteredTrips.length,
                itemBuilder: (context, index) {
                  return TripCard(
                    trip: filteredTrips[index],
                    index: index,
                    userRole: userRole,
                    currentUserMobile: currentUserMobile, // Pass current user mobile
                  );
                },
              ),
            ),
        ],
      );
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            strokeWidth: 3.w,
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading trips...',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64.sp,
            color: const Color(0xFFCBD5E1),
          ),
          SizedBox(height: 16.h),
          Text(
            'No ${status == 'all' ? '' : status.replaceAll('_', ' ')} trips found',
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(TripController tripController, String userRole) {
    Get.bottomSheet(
      FilterBottomSheet(tripController: tripController, userRole: userRole),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void _showSortSheet(TripController tripController) {
    Get.bottomSheet(
      SortBottomSheet(tripController: tripController),
      backgroundColor: Colors.transparent,
    );
  }

  void _refreshTrips(DashBoardController controller) async {
    controller.isLoading.value = true;
    final role = GetStorage().read('user_role');

    if (role == 'driver') {
      await controller.getAllDriverAssignedTrips();
    } else {
      await controller.getAllCreatedTrips();
      // Also fetch review trips for non-driver roles
      await controller.getAllReviewingTrips();
    }

    controller.isLoading.value = false;
  }
}

/// Professional trip card with clean design and role-based actions
class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.trip,
    required this.index,
    required this.userRole,
    required this.currentUserMobile,
  });

  final dynamic trip;
  final int index;
  final String userRole;
  final String currentUserMobile;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 200 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: const Color(0xFFF1F5F9),
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
              child: _buildCardContent(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent() {
    final destination = trip.destination?.toString() ?? 'Unknown Destination';
    final driverName = trip.driverName?.toString() ?? 'SANJAY RATHOUR';
    final createdAt = trip.createdAt?.toString() ?? '2025-09-10';
    final status = trip.status?.toString().toLowerCase() ?? 'open';

    return GestureDetector(
      onTap: () => _onTripCardTap(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Status and Trip Code
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      destination,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                        fontFamily: 'SF Pro Display',
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _buildStatusBadge(status),
                ],
              ),

              SizedBox(height: 12.h),

              // Vertical Data Layout
              Column(
                children: [
                  _buildEnhancedDataRow(
                    'Driver',
                    driverName,
                    Icons.person_outline_rounded,
                  ),
                  SizedBox(height: 8.h),
                  _buildEnhancedDataRow(
                    'Date & Time',
                    THelperFunctions.formatIndianDateTime(createdAt),
                    Icons.schedule_rounded,
                  ),
                  SizedBox(height: 8.h),
                  _buildEnhancedDataRow(
                    'Vehicle',
                    trip.billedVehicle?.toString() ?? 'Not Assigned',
                    Icons.local_shipping_outlined,
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Action Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tap to view details',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds an enhanced data row with better styling and spacing
  Widget _buildEnhancedDataRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon with background
        Container(
          width: 18.w,
          height: 18.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: Icon(
            icon,
            size: 12.sp,
          ),
        ),

        SizedBox(width: 8.w),

        // Label with fixed width
        SizedBox(
          width: 110.w,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 10.sp,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
              fontFamily: 'SF Pro Text',
            ),
          ),
        ),

        SizedBox(width: 8.w),

        // Value with flexible width
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 10.sp,
              color: const Color(0xFF1E293B),
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Handles trip card tap action with role-based options
  void _onTripCardTap() {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Show trip actions bottom sheet with role-based actions
    _showTripActionsBottomSheet();
  }

  /// Shows quick actions bottom sheet with role-based options
  void _showTripActionsBottomSheet() {
    // Check if current user can edit this trip (not created by them)
    final tripController = Get.find<TripController>();
    final canEdit = tripController.canEditTrip(trip, currentUserMobile);

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.destination?.toString() ?? 'Trip Details',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ],
              ),
            ),
            // Always show "View Full Details" for all roles
            _buildActionTile(
              'View Full Details',
              'See complete trip information',
              Icons.visibility_outlined,
              const Color(0xFF3B82F6),
                  () {
                final dashboardController = Get.find<DashBoardController>();
                Get.to(const TripTimelineScreen(), arguments: [
                  trip.source,
                  trip.destination,
                  trip.billedTo,
                  trip.createdAt,
                  dashboardController.loggedInUser.value.userRole
                ]);
              },
            ),
            // Show "Edit Trip" only for non-driver roles AND if trip is not created by current user
            if (userRole != 'driver' && canEdit)
              _buildActionTile(
                'Edit Trip',
                'Modify trip details',
                Icons.edit_outlined,
                const Color(0xFFF59E0B),
                    () {
                  Get.to(TripEditScreen(trip: trip));
                },
              ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  /// Builds action tile for bottom sheet
  Widget _buildActionTile(
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0F172A),
          fontFamily: 'SF Pro Text',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF64748B),
          fontFamily: 'SF Pro Text',
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14.sp,
        color: const Color(0xFF94A3B8),
      ),
      onTap: onTap,
    );
  }

  Widget _buildStatusBadge(String status) {
    final statusData = _getStatusData(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: statusData['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: statusData['color'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        statusData['text'],
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: statusData['color'],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusData(String status) {
    switch (status) {
      case 'completed':
        return {'text': 'Completed', 'color': const Color(0xFF10B981)};
      case 'in_review':
      case 'in review':
        return {'text': 'In Review', 'color': const Color(0xFFF59E0B)};
      case 'open':
        return {'text': 'Open', 'color': const Color(0xFF3B82F6)};
      case 'vehicle_dock':
      case 'vehicle dock':
        return {'text': 'At Dock', 'color': const Color(0xFF06B6D4)};
      case 'vehicle_loading':
      case 'vehicle loading':
        return {'text': 'Loading', 'color': const Color(0xFFEF4444)};
      case 'dispatch':
        return {'text': 'Dispatch', 'color': const Color(0xFF8B5CF6)};
      case 'vehicle_return':
      case 'vehicle return':
        return {'text': 'Return', 'color': const Color(0xFF10B981)};
      default:
        return {'text': 'Unknown', 'color': const Color(0xFF8B5CF6)};
    }
  }
}

/// Advanced filter bottom sheet with role-based filtering
class FilterBottomSheet extends StatelessWidget {
  final TripController tripController;
  final String userRole;

  const FilterBottomSheet({
    super.key,
    required this.tripController,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Filter Trips',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.close_rounded,
              size: 24.sp,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterSection(
            'Date Range',
            tripController.dateFilterOptions,
            tripController.selectedDateFilter,
            tripController.updateDateFilter,
          ),
          SizedBox(height: 24.h),
          _buildFilterSection(
            'Status',
            tripController.statusFilterOptions,
            tripController.selectedStatusFilter,
            tripController.updateStatusFilter,
          ),
          SizedBox(height: 24.h),
          // Only show driver filter for non-driver roles
          if (userRole != 'driver') ...[
            _buildDriverFilterSection(),
            SizedBox(height: 24.h),
          ],
          SizedBox(height: 8.h),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
      String title,
      List<Map<String, String>> options,
      RxString selectedValue,
      Function(String) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(() => Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((option) {
            final isSelected = selectedValue.value == option['value'];

            return FilterChip(
              label: Text(
                option['label']!,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color:
                  isSelected ? Colors.white : const Color(0xFF374151),
                ),
              ),
              selected: isSelected,
              selectedColor: const Color(0xFF3B82F6),
              backgroundColor: const Color(0xFFF8FAFC),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFFE2E8F0),
                width: 1,
              ),
              onSelected: (selected) {
                if (selected) {
                  onChanged(option['value']!);
                }
              },
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildDriverFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Driver',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(() {
          final dashboardController = Get.find<DashBoardController>();
          final drivers = tripController
              .getUniqueDriversFromTrips(dashboardController.allCreatedTrips);

          final driverOptions = [
            {'value': 'all', 'label': 'All Drivers'},
            ...drivers.map((driver) => {'value': driver, 'label': driver}),
          ];

          return Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: driverOptions.map((option) {
              final isSelected =
                  tripController.selectedDriverFilter.value == option['value'];

              return FilterChip(
                label: Text(
                  option['label']!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF374151),
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFF3B82F6),
                backgroundColor: const Color(0xFFF8FAFC),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFFE2E8F0),
                  width: 1,
                ),
                onSelected: (selected) {
                  if (selected) {
                    tripController.updateDriverFilter(option['value']!);
                  }
                },
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              tripController.clearAllFilters();
              Get.back();
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Reset Filters',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Apply Filters',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Sort options bottom sheet
class SortBottomSheet extends StatelessWidget {
  final TripController tripController;

  const SortBottomSheet({super.key, required this.tripController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Sort Trips',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close_rounded,
                    size: 24.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: tripController.sortOptions.length,
            itemBuilder: (context, index) {
              final option = tripController.sortOptions[index];

              return Obx(() {
                final isSelected =
                    tripController.selectedSortBy.value == option['value'];

                return ListTile(
                  title: Text(
                    option['label']!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF374151),
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                    Icons.check_rounded,
                    size: 20.sp,
                    color: const Color(0xFF3B82F6),
                  )
                      : null,
                  onTap: () {
                    tripController.updateSortOption(option['value']!);
                    Get.back();
                  },
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
