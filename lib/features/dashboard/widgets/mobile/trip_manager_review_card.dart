// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:get/get.dart';
// // import 'package:intl/intl.dart';
// // import 'package:trident/data/models/trip_model.dart';
// // import '../../../../common/widgets/containers/rounded_container.dart';
// // import '../../../../utils/constants/sizes.dart';
// //
// // class TripManagerReviewCard extends StatelessWidget {
// //   final TripModel trip;
// //
// //   const TripManagerReviewCard({super.key, required this.trip});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final dateFormatted =
// //     DateFormat('d MMMM y \'at\' h:mm a').format(trip.createdAt!);
// //
// //     return TRoundedContainer(
// //       onTap: () {
// //         // Navigate to detailed review screen
// //         // Get.to(const TripReviewDetailScreen(), arguments: [trip]);
// //       },
// //       margin:
// //       EdgeInsets.symmetric(horizontal: TSizes.md.w, vertical: TSizes.sm.h),
// //       padding: EdgeInsets.all(TSizes.md.w),
// //       backgroundColor: Colors.white,
// //       showBorder: true,
// //       borderColor: const Color(0xFFE2E8F0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           /// Header with Priority Badge
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Icon(
// //                           Icons.assignment_outlined,
// //                           size: 16.w,
// //                           color: const Color(0xFF3B82F6),
// //                         ),
// //                         SizedBox(width: 4.w),
// //                         Text(
// //                           'Trip Review Required'.tr,
// //                           style: TextStyle(
// //                             fontWeight: FontWeight.w500,
// //                             color: const Color(0xFF64748B),
// //                             fontSize: 12.sp,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     SizedBox(height: 4.h),
// //                     Text(
// //                       '${trip.billedTo} - ${trip.tripType}',
// //                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
// //                         fontWeight: FontWeight.w700,
// //                         color: const Color(0xFF0F172A),
// //                         fontSize: 16.sp,
// //                         letterSpacing: -0.2,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(width: TSizes.sm.w),
// //               Column(
// //                 children: [
// //                   _buildStatusBadge(),
// //                   SizedBox(height: 4.h),
// //                   _buildPriorityBadge(),
// //                 ],
// //               ),
// //             ],
// //           ),
// //
// //           SizedBox(height: TSizes.md.h),
// //
// //           _buildRouteSection(context),
// //           SizedBox(height: TSizes.md.h),
// //           _buildDetailsGrid(context, dateFormatted),
// //           // SizedBox(height: TSizes.md.h),
// //           // _buildReviewMetrics(context),
// //           SizedBox(height: TSizes.md.h),
// //           _buildActionButtons(context),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStatusBadge() {
// //     final isCompleted = trip.status.toLowerCase() == 'completed';
// //     final isPending = trip.status.toLowerCase() == 'pending';
// //     final isInProgress = trip.status.toLowerCase() == 'in_progress';
// //
// //     Color badgeColor;
// //     Color textColor;
// //     IconData icon;
// //
// //     if (isCompleted) {
// //       badgeColor = const Color(0xFFDCFCE7);
// //       textColor = const Color(0xFF166534);
// //       icon = Icons.check_circle_outline;
// //     } else if (isPending) {
// //       badgeColor = const Color(0xFFFEF3C7);
// //       textColor = const Color(0xFF92400E);
// //       icon = Icons.schedule_outlined;
// //     } else if (isInProgress) {
// //       badgeColor = const Color(0xFFDEF7FF);
// //       textColor = const Color(0xFF0369A1);
// //       icon = Icons.directions_car_outlined;
// //     } else {
// //       badgeColor = const Color(0xFFF1F5F9);
// //       textColor = const Color(0xFF475569);
// //       icon = Icons.info_outline;
// //     }
// //
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
// //       decoration: BoxDecoration(
// //         color: badgeColor,
// //         borderRadius: BorderRadius.circular(16.r),
// //         border: Border.all(color: textColor.withOpacity(0.2), width: 1),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(icon, size: 12.w, color: textColor),
// //           SizedBox(width: 3.w),
// //           Text(
// //             trip.status.toUpperCase(),
// //             style: TextStyle(
// //               fontWeight: FontWeight.w600,
// //               color: textColor,
// //               fontSize: 10.sp,
// //               letterSpacing: 0.3,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPriorityBadge() {
// //     // Assuming priority is determined by trip urgency or type
// //     final isHighPriority = trip.tripType.toLowerCase() == 'emergency' ||
// //         trip.tripType.toLowerCase() == 'urgent';
// //
// //     if (!isHighPriority) return const SizedBox.shrink();
// //
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFFEE2E2),
// //         borderRadius: BorderRadius.circular(12.r),
// //         border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(Icons.priority_high, size: 10.w, color: const Color(0xFFEF4444)),
// //           SizedBox(width: 2.w),
// //           Text(
// //             'HIGH',
// //             style: TextStyle(
// //               fontWeight: FontWeight.w700,
// //               color: const Color(0xFFEF4444),
// //               fontSize: 9.sp,
// //               letterSpacing: 0.5,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRouteSection(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.all(TSizes.sm.w),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFF8FAFC),
// //         borderRadius: BorderRadius.circular(12.r),
// //         border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             padding: EdgeInsets.all(8.w),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF8B5CF6),
// //               borderRadius: BorderRadius.circular(8.r),
// //             ),
// //             child: Icon(Icons.route, size: 16.w, color: Colors.white),
// //           ),
// //           SizedBox(width: TSizes.sm.w),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   'Route for Review'.tr,
// //                   style: TextStyle(
// //                     fontSize: 11.sp,
// //                     fontWeight: FontWeight.w500,
// //                     color: const Color(0xFF64748B),
// //                     letterSpacing: 0.3,
// //                   ),
// //                 ),
// //                 SizedBox(height: 2.h),
// //                 RichText(
// //                   text: TextSpan(
// //                     children: [
// //                       TextSpan(
// //                         text: trip.source,
// //                         style: TextStyle(
// //                           fontSize: 14.sp,
// //                           fontWeight: FontWeight.w600,
// //                           color: const Color(0xFF0F172A),
// //                         ),
// //                       ),
// //                       TextSpan(
// //                         text: ' → ',
// //                         style: TextStyle(
// //                           fontSize: 14.sp,
// //                           fontWeight: FontWeight.w400,
// //                           color: const Color(0xFF64748B),
// //                         ),
// //                       ),
// //                       TextSpan(
// //                         text: trip.destination,
// //                         style: TextStyle(
// //                           fontSize: 14.sp,
// //                           fontWeight: FontWeight.w600,
// //                           color: const Color(0xFF0F172A),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Icon(
// //             Icons.visibility_outlined,
// //             size: 16.w,
// //             color: const Color(0xFF64748B),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDetailsGrid(BuildContext context, String dateFormatted) {
// //     return Column(
// //       children: [
// //         Row(
// //           children: [
// //             Expanded(
// //               child: _buildDetailItem(
// //                 icon: Icons.person_outline,
// //                 label: 'Driver'.tr,
// //                 value: trip.createdBy,
// //                 iconColor: const Color(0xFF8B5CF6),
// //               ),
// //             ),
// //             SizedBox(width: TSizes.sm.w),
// //             Expanded(
// //               child: _buildDetailItem(
// //                 icon: Icons.local_shipping_outlined,
// //                 label: 'Vehicle'.tr,
// //                 value: trip.billedVehicle,
// //                 iconColor: const Color(0xFF06B6D4),
// //               ),
// //             ),
// //           ],
// //         ),
// //         SizedBox(height: TSizes.sm.h),
// //         Row(
// //           children: [
// //             Expanded(
// //               child: _buildDetailItem(
// //                 icon: Icons.schedule_outlined,
// //                 label: 'Completed At'.tr,
// //                 value: dateFormatted,
// //                 iconColor: const Color(0xFF10B981),
// //               ),
// //             ),
// //             SizedBox(width: TSizes.sm.w),
// //             Expanded(
// //               child: _buildDetailItem(
// //                 icon: Icons.timer_outlined,
// //                 label: 'Duration'.tr,
// //                 value: '2h 30m', // This should come from trip model
// //                 iconColor: const Color(0xFFF59E0B),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildDetailItem({
// //     required IconData icon,
// //     required String label,
// //     required String value,
// //     required Color iconColor,
// //   }) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: TSizes.sm.w, vertical: 10.h),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(8.r),
// //         border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(icon, size: 14.w, color: iconColor),
// //               SizedBox(width: 4.w),
// //               Text(
// //                 label,
// //                 style: TextStyle(
// //                   fontSize: 10.sp,
// //                   fontWeight: FontWeight.w500,
// //                   color: const Color(0xFF64748B),
// //                   letterSpacing: 0.3,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 4.h),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: 13.sp,
// //               fontWeight: FontWeight.w600,
// //               color: const Color(0xFF0F172A),
// //             ),
// //             maxLines: 2,
// //             overflow: TextOverflow.ellipsis,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildReviewMetrics(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.all(TSizes.sm.w),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFF0F9FF),
// //         borderRadius: BorderRadius.circular(12.r),
// //         border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(Icons.analytics_outlined,
// //                   size: 16.w, color: const Color(0xFF0369A1)),
// //               SizedBox(width: 6.w),
// //               Text(
// //                 'Review Metrics'.tr,
// //                 style: TextStyle(
// //                   fontSize: 12.sp,
// //                   fontWeight: FontWeight.w600,
// //                   color: const Color(0xFF0369A1),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 8.h),
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: _buildMetricItem(
// //                   label: 'Distance',
// //                   value: '25.4 km',
// //                   icon: Icons.straighten,
// //                 ),
// //               ),
// //               Expanded(
// //                 child: _buildMetricItem(
// //                   label: 'Fuel Used',
// //                   value: '3.2 L',
// //                   icon: Icons.local_gas_station,
// //                 ),
// //               ),
// //               Expanded(
// //                 child: _buildMetricItem(
// //                   label: 'Cost',
// //                   value: '₹450',
// //                   icon: Icons.currency_rupee,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildMetricItem({
// //     required String label,
// //     required String value,
// //     required IconData icon,
// //   }) {
// //     return Column(
// //       children: [
// //         Icon(icon, size: 16.w, color: const Color(0xFF0369A1)),
// //         SizedBox(height: 4.h),
// //         Text(
// //           value,
// //           style: TextStyle(
// //             fontSize: 14.sp,
// //             fontWeight: FontWeight.w700,
// //             color: const Color(0xFF0F172A),
// //           ),
// //         ),
// //         Text(
// //           label,
// //           style: TextStyle(
// //             fontSize: 10.sp,
// //             fontWeight: FontWeight.w500,
// //             color: const Color(0xFF64748B),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildActionButtons(BuildContext context) {
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: _buildActionButton(
// //             onTap: () {
// //               // Handle approve action
// //             },
// //             icon: Icons.check_circle_outline,
// //             label: 'Approve'.tr,
// //             backgroundColor: const Color(0xFFDCFCE7),
// //             textColor: const Color(0xFF166534),
// //             borderColor: const Color(0xFF16A34A),
// //           ),
// //         ),
// //         SizedBox(width: TSizes.sm.w),
// //         Expanded(
// //           child: _buildActionButton(
// //             onTap: () {
// //               // Handle review action
// //             },
// //             icon: Icons.rate_review_outlined,
// //             label: 'Edit'.tr,
// //             backgroundColor: const Color(0xFFFEF3C7),
// //             textColor: const Color(0xFF92400E),
// //             borderColor: const Color(0xFFF59E0B),
// //           ),
// //
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildActionButton({
// //     required VoidCallback onTap,
// //     required IconData icon,
// //     required String label,
// //     required Color backgroundColor,
// //     required Color textColor,
// //     required Color borderColor,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
// //         decoration: BoxDecoration(
// //           color: backgroundColor,
// //           borderRadius: BorderRadius.circular(8.r),
// //           border: Border.all(color: borderColor.withOpacity(0.3), width: 1),
// //         ),
// //         child: Column(
// //           children: [
// //             Icon(icon, size: 16.w, color: textColor),
// //             SizedBox(height: 2.h),
// //             Text(
// //               label,
// //               style: TextStyle(
// //                 fontSize: 11.sp,
// //                 fontWeight: FontWeight.w600,
// //                 color: textColor,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   String _getTimeAgo() {
// //     final now = DateTime.now();
// //     final difference = now.difference(trip.createdAt!);
// //
// //     if (difference.inDays > 0) {
// //       return '${difference.inDays}d ${'ago'.tr}';
// //     } else if (difference.inHours > 0) {
// //       return '${difference.inHours}h ${'ago'.tr}';
// //     } else if (difference.inMinutes > 0) {
// //       return '${difference.inMinutes}m ${'ago'.tr}';
// //     } else {
// //       return 'Just now'.tr;
// //     }
// //   }
// // }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:trident/data/models/trip_model.dart';
// import 'package:trident/features/dashboard/widgets/mobile/trip_edit_screen.dart';
// import '../../../../common/widgets/containers/rounded_container.dart';
// import '../../../../utils/constants/sizes.dart';
//
// class TripManagerReviewCard extends StatelessWidget {
//   final TripModel trip;
//
//   const TripManagerReviewCard({super.key, required this.trip});
//
//   @override
//   Widget build(BuildContext context) {
//     final dateFormatted =
//     DateFormat('d MMMM y \'at\' h:mm a').format(trip.createdAt!);
//
//     return TRoundedContainer(
//       onTap: () {
//         // Navigate to detailed review screen
//         // Get.to(const TripReviewDetailScreen(), arguments: [trip]);
//       },
//       margin:
//       EdgeInsets.symmetric(horizontal: TSizes.md.w, vertical: TSizes.sm.h),
//       padding: EdgeInsets.all(TSizes.md.w),
//       backgroundColor: Colors.white,
//       showBorder: true,
//       borderColor: const Color(0xFFE2E8F0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Header with Priority Badge
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.assignment_outlined,
//                           size: 16.w,
//                           color: const Color(0xFF3B82F6),
//                         ),
//                         SizedBox(width: 4.w),
//                         Text(
//                           'Trip Review Required'.tr,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: const Color(0xFF64748B),
//                             fontSize: 12.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 4.h),
//                     Text(
//                       '${trip.billedTo} - ${trip.tripType}',
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.w700,
//                         color: const Color(0xFF0F172A),
//                         fontSize: 16.sp,
//                         letterSpacing: -0.2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: TSizes.sm.w),
//               Column(
//                 children: [
//                   _buildStatusBadge(),
//                   SizedBox(height: 4.h),
//                   _buildPriorityBadge(),
//                 ],
//               ),
//             ],
//           ),
//
//           SizedBox(height: TSizes.md.h),
//
//           _buildRouteSection(context),
//           SizedBox(height: TSizes.md.h),
//           _buildDetailsGrid(context, dateFormatted),
//           SizedBox(height: TSizes.md.h),
//           _buildActionButtons(context),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusBadge() {
//     final isCompleted = trip.status.toLowerCase() == 'completed';
//     final isPending = trip.status.toLowerCase() == 'pending';
//     final isInProgress = trip.status.toLowerCase() == 'in_progress';
//
//     Color badgeColor;
//     Color textColor;
//     IconData icon;
//
//     if (isCompleted) {
//       badgeColor = const Color(0xFFDCFCE7);
//       textColor = const Color(0xFF166534);
//       icon = Icons.check_circle_outline;
//     } else if (isPending) {
//       badgeColor = const Color(0xFFFEF3C7);
//       textColor = const Color(0xFF92400E);
//       icon = Icons.schedule_outlined;
//     } else if (isInProgress) {
//       badgeColor = const Color(0xFFDEF7FF);
//       textColor = const Color(0xFF0369A1);
//       icon = Icons.directions_car_outlined;
//     } else {
//       badgeColor = const Color(0xFFF1F5F9);
//       textColor = const Color(0xFF475569);
//       icon = Icons.info_outline;
//     }
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//       decoration: BoxDecoration(
//         color: badgeColor,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: textColor.withOpacity(0.2), width: 1),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12.w, color: textColor),
//           SizedBox(width: 3.w),
//           Text(
//             trip.status.toUpperCase(),
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               color: textColor,
//               fontSize: 10.sp,
//               letterSpacing: 0.3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPriorityBadge() {
//     // Assuming priority is determined by trip urgency or type
//     final isHighPriority = trip.tripType.toLowerCase() == 'emergency' ||
//         trip.tripType.toLowerCase() == 'urgent';
//
//     if (!isHighPriority) return const SizedBox.shrink();
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFEE2E2),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.priority_high, size: 10.w, color: const Color(0xFFEF4444)),
//           SizedBox(width: 2.w),
//           Text(
//             'HIGH',
//             style: TextStyle(
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFFEF4444),
//               fontSize: 9.sp,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRouteSection(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(TSizes.sm.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8.w),
//             decoration: BoxDecoration(
//               color: const Color(0xFF8B5CF6),
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: Icon(Icons.route, size: 16.w, color: Colors.white),
//           ),
//           SizedBox(width: TSizes.sm.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Route for Review'.tr,
//                   style: TextStyle(
//                     fontSize: 11.sp,
//                     fontWeight: FontWeight.w500,
//                     color: const Color(0xFF64748B),
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//                 SizedBox(height: 2.h),
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: trip.source,
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xFF0F172A),
//                         ),
//                       ),
//                       TextSpan(
//                         text: ' → ',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           color: const Color(0xFF64748B),
//                         ),
//                       ),
//                       TextSpan(
//                         text: trip.destination,
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xFF0F172A),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Icon(
//             Icons.visibility_outlined,
//             size: 16.w,
//             color: const Color(0xFF64748B),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailsGrid(BuildContext context, String dateFormatted) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: _buildDetailItem(
//                 icon: Icons.person_outline,
//                 label: 'Driver'.tr,
//                 value: trip.driverName,
//                 iconColor: const Color(0xFF8B5CF6),
//               ),
//             ),
//             SizedBox(width: TSizes.sm.w),
//             Expanded(
//               child: _buildDetailItem(
//                 icon: Icons.local_shipping_outlined,
//                 label: 'Vehicle'.tr,
//                 value: trip.billedVehicle,
//                 iconColor: const Color(0xFF06B6D4),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: TSizes.sm.h),
//         Row(
//           children: [
//             Expanded(
//               child: _buildDetailItem(
//                 icon: Icons.schedule_outlined,
//                 label: 'Created At'.tr,
//                 value: dateFormatted,
//                 iconColor: const Color(0xFF10B981),
//               ),
//             ),
//             SizedBox(width: TSizes.sm.w),
//             Expanded(
//               child: _buildDetailItem(
//                 icon: Icons.business_outlined,
//                 label: 'Consignor'.tr,
//                 value: trip.consignor ?? 'N/A',
//                 iconColor: const Color(0xFFF59E0B),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDetailItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color iconColor,
//   }) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: TSizes.sm.w, vertical: 10.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.r),
//         border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 14.w, color: iconColor),
//               SizedBox(width: 4.w),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 10.sp,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF64748B),
//                   letterSpacing: 0.3,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 13.sp,
//               fontWeight: FontWeight.w600,
//               color: const Color(0xFF0F172A),
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButtons(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildActionButton(
//             onTap: () => _handleApproveTrip(),
//             icon: Icons.check_circle_outline,
//             label: 'Approve'.tr,
//             backgroundColor: const Color(0xFFDCFCE7),
//             textColor: const Color(0xFF166534),
//             borderColor: const Color(0xFF16A34A),
//           ),
//         ),
//         SizedBox(width: TSizes.sm.w),
//         Expanded(
//           child: _buildActionButton(
//             onTap: () => _handleEditTrip(),
//             icon: Icons.edit_outlined,
//             label: 'Edit'.tr,
//             backgroundColor: const Color(0xFFFEF3C7),
//             textColor: const Color(0xFF92400E),
//             borderColor: const Color(0xFFF59E0B),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton({
//     required VoidCallback onTap,
//     required IconData icon,
//     required String label,
//     required Color backgroundColor,
//     required Color textColor,
//     required Color borderColor,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(8.r),
//           border: Border.all(color: borderColor.withOpacity(0.3), width: 1),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, size: 16.w, color: textColor),
//             SizedBox(height: 2.h),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 11.sp,
//                 fontWeight: FontWeight.w600,
//                 color: textColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _handleApproveTrip() {
//     Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         title: Row(
//           children: [
//             Icon(
//               Icons.check_circle_outline,
//               color: const Color(0xFF16A34A),
//               size: 24.w,
//             ),
//             SizedBox(width: 8.w),
//             Text(
//               'Approve Trip',
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF0F172A),
//               ),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Are you sure you want to approve this trip?',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: const Color(0xFF64748B),
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Container(
//               padding: EdgeInsets.all(12.w),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF8FAFC),
//                 borderRadius: BorderRadius.circular(8.r),
//                 border: Border.all(color: const Color(0xFFE2E8F0)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Trip Details:',
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xFF374151),
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     '${trip.source} → ${trip.destination}',
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       color: const Color(0xFF64748B),
//                     ),
//                   ),
//                   Text(
//                     'Driver: ${trip.driverName}',
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       color: const Color(0xFF64748B),
//                     ),
//                   ),
//                   Text(
//                     'Vehicle: ${trip.billedVehicle}',
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       color: const Color(0xFF64748B),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               'This action cannot be undone.',
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: const Color(0xFFEF4444),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xFF64748B),
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Get.back();
//               await _approveTrip();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF16A34A),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(6.r),
//               ),
//               elevation: 0,
//             ),
//             child: Text(
//               'Approve',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _handleEditTrip() async {
//     final result = await Get.to(() => TripEditScreen(trip: trip));
//
//     // If result is true, it means the trip was updated successfully
//     if (result == true) {
//       // You can refresh the parent list here if needed
//       // This would typically be handled by the parent widget
//       Get.snackbar(
//         'Success',
//         'Trip updated successfully',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green.shade100,
//         colorText: Colors.green.shade800,
//         margin: EdgeInsets.all(16.w),
//         duration: const Duration(seconds: 2),
//       );
//     }
//   }
//
//   Future<void> _approveTrip() async {
//     try {
//       // Show loading indicator
//       Get.dialog(
//         const Center(
//           child: CircularProgressIndicator(),
//         ),
//         barrierDismissible: false,
//       );
//
//       // Find the trip document
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('trips')
//           .where('created_at', isEqualTo: Timestamp.fromDate(trip.createdAt!))
//           .limit(1)
//           .get();
//
//       if (querySnapshot.docs.isEmpty) {
//         Get.back(); // Close loading dialog
//         Get.snackbar(
//           'Error',
//           'Trip not found',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade800,
//           margin: EdgeInsets.all(16.w),
//         );
//         return;
//       }
//
//       final tripDoc = querySnapshot.docs.first;
//       final storage = GetStorage();
//       final userMobile = await storage.read('user_mobile_no');
//
//       // Update the trip with approval data
//       await FirebaseFirestore.instance
//           .collection('trips')
//           .doc(tripDoc.id)
//           .update({
//         'in_review': false,
//         'is_approved': true,
//         'approved_by': userMobile ?? 'Unknown',
//         'approved_at': FieldValue.serverTimestamp(),
//         'trip_status': 'approved',
//       });
//
//       Get.back(); // Close loading dialog
//
//       // Show success message
//       Get.snackbar(
//         'Success',
//         'Trip approved successfully',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green.shade100,
//         colorText: Colors.green.shade800,
//         margin: EdgeInsets.all(16.w),
//         duration: const Duration(seconds: 3),
//       );
//
//     } catch (e) {
//       Get.back(); // Close loading dialog
//       print('Error approving trip: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to approve trip. Please try again.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade800,
//         margin: EdgeInsets.all(16.w),
//         duration: const Duration(seconds: 4),
//       );
//     }
//   }
//
//   String _getTimeAgo() {
//     final now = DateTime.now();
//     final difference = now.difference(trip.createdAt!);
//
//     if (difference.inDays > 0) {
//       return '${difference.inDays}d ${'ago'.tr}';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h ${'ago'.tr}';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes}m ${'ago'.tr}';
//     } else {
//       return 'Just now'.tr;
//     }
//   }
// }

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:trident/data/models/trip_model.dart';
import 'package:trident/features/dashboard/widgets/mobile/trip_edit_screen.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../trips/controllers/trip_controller.dart';

class TripManagerReviewCard extends StatelessWidget {
  final TripModel trip;

  const TripManagerReviewCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final dateFormatted =
        DateFormat('d MMMM y \'at\' h:mm a').format(trip.createdAt!);

    return TRoundedContainer(
      onTap: () {
        // Navigate to detailed review screen
        // Get.to(const TripReviewDetailScreen(), arguments: [trip]);
      },
      margin:
          EdgeInsets.symmetric(horizontal: TSizes.md.w, vertical: TSizes.sm.h),
      padding: EdgeInsets.all(TSizes.md.w),
      backgroundColor: Colors.white,
      showBorder: true,
      borderColor: const Color(0xFFE2E8F0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header with Priority Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 16.w,
                          color: const Color(0xFF3B82F6),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Trip Review Required'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${trip.billedTo} - ${trip.tripType}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                            fontSize: 16.sp,
                            letterSpacing: -0.2,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: TSizes.sm.w),
              Column(
                children: [
                  _buildStatusBadge(),
                  SizedBox(height: 4.h),
                  _buildPriorityBadge(),
                ],
              ),
            ],
          ),

          SizedBox(height: TSizes.md.h),

          _buildRouteSection(context),
          SizedBox(height: TSizes.md.h),
          _buildDetailsGrid(context, dateFormatted),
          SizedBox(height: TSizes.md.h),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isCompleted = trip.status.toLowerCase() == 'completed';
    final isPending = trip.status.toLowerCase() == 'pending';
    final isInProgress = trip.status.toLowerCase() == 'in_progress';

    Color badgeColor;
    Color textColor;
    IconData icon;

    if (isCompleted) {
      badgeColor = const Color(0xFFDCFCE7);
      textColor = const Color(0xFF166534);
      icon = Icons.check_circle_outline;
    } else if (isPending) {
      badgeColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFF92400E);
      icon = Icons.schedule_outlined;
    } else if (isInProgress) {
      badgeColor = const Color(0xFFDEF7FF);
      textColor = const Color(0xFF0369A1);
      icon = Icons.directions_car_outlined;
    } else {
      badgeColor = const Color(0xFFF1F5F9);
      textColor = const Color(0xFF475569);
      icon = Icons.info_outline;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: textColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.w, color: textColor),
          SizedBox(width: 3.w),
          Text(
            trip.status.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
              fontSize: 10.sp,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge() {
    // Assuming priority is determined by trip urgency or type
    final isHighPriority = trip.tripType.toLowerCase() == 'emergency' ||
        trip.tripType.toLowerCase() == 'urgent';

    if (!isHighPriority) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.priority_high, size: 10.w, color: const Color(0xFFEF4444)),
          SizedBox(width: 2.w),
          Text(
            'HIGH',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: const Color(0xFFEF4444),
              fontSize: 9.sp,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TSizes.sm.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.route, size: 16.w, color: Colors.white),
          ),
          SizedBox(width: TSizes.sm.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Route for Review'.tr,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 2.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: trip.source,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      TextSpan(
                        text: ' → ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      TextSpan(
                        text: trip.destination,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.visibility_outlined,
            size: 16.w,
            color: const Color(0xFF64748B),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context, String dateFormatted) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                icon: Icons.person_outline,
                label: 'Driver'.tr,
                value: trip.driverName,
                iconColor: const Color(0xFF8B5CF6),
              ),
            ),
            SizedBox(width: TSizes.sm.w),
            Expanded(
              child: _buildDetailItem(
                icon: Icons.local_shipping_outlined,
                label: 'Vehicle'.tr,
                value: trip.billedVehicle,
                iconColor: const Color(0xFF06B6D4),
              ),
            ),
          ],
        ),
        SizedBox(height: TSizes.sm.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                icon: Icons.schedule_outlined,
                label: 'Created At'.tr,
                value: dateFormatted,
                iconColor: const Color(0xFF10B981),
              ),
            ),
            SizedBox(width: TSizes.sm.w),
            Expanded(
              child: _buildDetailItem(
                icon: Icons.business_outlined,
                label: 'Consignor'.tr,
                value: trip.consignor ?? 'N/A',
                iconColor: const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: TSizes.sm.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.w, color: iconColor),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            onTap: () => _handleApproveTrip(),
            icon: Icons.check_circle_outline,
            label: 'Approve'.tr,
            backgroundColor: const Color(0xFFDCFCE7),
            textColor: const Color(0xFF166534),
            borderColor: const Color(0xFF16A34A),
          ),
        ),
        SizedBox(width: TSizes.sm.w),
        Expanded(
          child: _buildActionButton(
            onTap: () => _handleEditTrip(),
            icon: Icons.edit_outlined,
            label: 'Edit'.tr,
            backgroundColor: const Color(0xFFFEF3C7),
            textColor: const Color(0xFF92400E),
            borderColor: const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16.w, color: textColor),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleApproveTrip() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: const Color(0xFF16A34A),
              size: 24.w,
            ),
            SizedBox(width: 8.w),
            Text(
              'Approve Trip',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to approve this trip?',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF64748B),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip Details:',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${trip.source} → ${trip.destination}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    'Driver: ${trip.driverName}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    'Vehicle: ${trip.billedVehicle}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFFEF4444),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _approveTrip();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Approve',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleEditTrip() async {
    // Get the existing TripController or create one if it doesn't exist

    final result = await Get.to(() => TripEditScreen(trip: trip));

    // If result is true, it means the trip was updated successfully
    if (result == true) {
      // You can refresh the parent list here if needed
      // This would typically be handled by the parent widget
      Get.snackbar(
        'Success',
        'Trip updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _approveTrip() async {
    try {
      // Show modern loading overlay
      _showLoadingOverlay();

      // Find the trip document with better error handling
      final querySnapshot = await _findTripDocument();

      if (querySnapshot.docs.isEmpty) {
        _hideLoadingOverlay();
        await _showErrorFeedback(
          'Trip Not Found',
          'Unable to locate this trip request.',
          icon: Icons.search_off_rounded,
        );
        return;
      }

      final tripDoc = querySnapshot.docs.first;
      final approverInfo = await _getApproverInfo();

      // Update trip with enhanced approval data
      await _updateTripApproval(tripDoc.id, approverInfo);

      _hideLoadingOverlay();

      // Show enhanced success feedback
      await _showSuccessFeedback();

      // Refresh the trips list
      final tripController = Get.find<TripController>();
      tripController.getTripsForReview();
    } catch (e) {
      _hideLoadingOverlay();
      _logError('Trip approval failed', e);
      await _showErrorFeedback(
        'Approval Failed',
        'Something went wrong. Please check your connection and try again.',
        icon: Icons.error_outline_rounded,
      );
    }
  }

  void _showLoadingOverlay() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 56.w,
                        height: 56.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFF16A34A),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.flight_takeoff_rounded,
                        color: const Color(0xFF16A34A),
                        size: 24.w,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Approving Trip...',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Please wait a moment',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _hideLoadingOverlay() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  Future<QuerySnapshot> _findTripDocument() async {
    return await FirebaseFirestore.instance
        .collection('trips')
        .where('created_at', isEqualTo: Timestamp.fromDate(trip.createdAt!))
        .limit(1)
        .get();
  }

  Future<Map<String, dynamic>> _getApproverInfo() async {
    final storage = GetStorage();
    final userMobile = await storage.read('user_mobile_no') ?? 'Unknown';
    final userName = await storage.read('user_name') ?? 'Admin';

    return {
      'mobile': userMobile,
      'name': userName,
      'timestamp': DateTime.now(),
    };
  }

  Future<void> _updateTripApproval(
      String tripId, Map<String, dynamic> approverInfo) async {
    await FirebaseFirestore.instance.collection('trips').doc(tripId).update({
      'in_review': false,
      'is_approved': true,
      'approved_by': approverInfo['mobile'],
      'approved_by_name': approverInfo['name'],
      'approved_at': FieldValue.serverTimestamp(),
      'trip_status': 'approved',
      'status_history': FieldValue.arrayUnion([
        {
          'status': 'approved',
          'timestamp': FieldValue.serverTimestamp(),
          'approved_by': approverInfo['mobile'],
          'approved_by_name': approverInfo['name'],
        }
      ]),
    });
  }

  Future<void> _showSuccessFeedback() async {
    // Haptic feedback
    HapticFeedback.lightImpact();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated success icon
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: const Color(0xFF16A34A),
                  size: 48.w,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Trip Approved!',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[900],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'The traveler has been notified and can now proceed with their trip.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Auto-dismiss after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    });
  }

  Future<void> _showErrorFeedback(String title, String message,
      {IconData? icon}) async {
    // Error haptic feedback
    HapticFeedback.mediumImpact();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.error_outline_rounded,
                  color: Colors.red.shade600,
                  size: 48.w,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[900],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _approveTrip(); // Retry
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logError(String message, dynamic error) {
    // Enhanced logging for debugging
    print('🔴 $message: $error');
    // You could integrate with crash reporting service here
    // FirebaseCrashlytics.instance.recordError(error, null);
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(trip.createdAt!);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${'ago'.tr}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${'ago'.tr}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ${'ago'.tr}';
    } else {
      return 'Just now'.tr;
    }
  }
}
