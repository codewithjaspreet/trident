import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../dashboard/views/navigation_bar.dart';
import '../controllers/driver_controller.dart';
import '../models/driver_model.dart';
import 'add_driver.dart';
import 'driver_details.dart';
import 'edit_driver.dart';

class DriverListingScreen extends StatelessWidget {
  const DriverListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
          onPressed: () {
            if (Get.isRegistered<NavigationController>()) {
              final navController = Get.find<NavigationController>();
              final navigatorKey = navController.getCurrentNavigatorKey();
              navigatorKey?.currentState?.pop();
            } else {
              Get.back();
            }
          },
        ),
        title: Text(
          'Drivers',
          style: GoogleFonts.nunitoSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black87, size: 24.sp),
            onPressed: () => controller.fetchDrivers(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Search and Add Button Section
            Container(
              padding: EdgeInsets.all(16.w),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => controller.searchQuery.value = value,
                      decoration: InputDecoration(
                        hintText: 'Search by name, mobile, DL number, Aadhar...',
                        prefixIcon: Icon(Icons.search, color: TColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: TColors.borderPrimary),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: TColors.borderPrimary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: TColors.bgPrimary, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton.icon(
                    onPressed: () => Get.to(() => const AddDriverScreen()),
                    icon: Icon(Icons.add, size: 20.sp),
                    label: Text('Add Driver', style: TextStyle(fontSize: 14.sp)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.bgPrimary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Paginated List Section
            Expanded(
              child: controller.filteredDrivers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_off, size: 64.sp, color: TColors.primary),
                          SizedBox(height: 16.h),
                          Text(
                            'No drivers found',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16.sp,
                              color: TColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildPaginatedList(controller),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPaginatedList(DriverController controller) {
    return PaginatedListView<DriverModel>(
      items: controller.filteredDrivers,
      itemsPerPage: 10,
      itemBuilder: (context, driver, index) => _buildDriverCard(driver, controller),
      emptyWidget: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 64.sp, color: TColors.primary),
            SizedBox(height: 16.h),
            Text(
              'No drivers found',
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                color: TColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard(DriverModel driver, DriverController controller) {
    return Builder(
      builder: (context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: TColors.bgPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.person,
                    color: TColors.bgPrimary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      driver.driverName,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      driver.mobileNo,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12.sp,
                        color: TColors.textSecondary,
                      ),
                    ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: TColors.textSecondary),
                  onSelected: (value) {
                    switch (value) {
                      case 'view':
                        Get.to(() => DriverDetailsScreen(driver: driver));
                        break;
                      case 'edit':
                        Get.to(() => EditDriverScreen(driver: driver));
                        break;
                      case 'delete':
                        _showDeleteDialog(context, controller, driver);
                        break;
                    }
                  },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 18.sp, color: TColors.bgPrimary),
                        SizedBox(width: 8.w),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18.sp, color: Colors.orange),
                        SizedBox(width: 8.w),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18.sp, color: Colors.red),
                        SizedBox(width: 8.w),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: TColors.grey.withOpacity(0.3)),
          SizedBox(height: 12.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem('DL No', driver.dlNo),
              SizedBox(height: 8.h),
              _buildInfoItem('Aadhar', driver.aadharNo),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 11.sp,
            color: TColors.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.nunitoSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, DriverController controller, DriverModel driver) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Driver',
          style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete ${driver.driverName}? This action cannot be undone.',
          style: GoogleFonts.nunitoSans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: TColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              if (driver.id != null) {
                controller.deleteDriver(driver.id!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Paginated List View Widget
class PaginatedListView<T> extends StatefulWidget {
  final List<T> items;
  final int itemsPerPage;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final Widget? emptyWidget;

  const PaginatedListView({
    super.key,
    required this.items,
    required this.itemsPerPage,
    required this.itemBuilder,
    this.emptyWidget,
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  int _currentPage = 0;
  late int _totalPages;

  @override
  void initState() {
    super.initState();
    _totalPages = (widget.items.length / widget.itemsPerPage).ceil();
  }

  @override
  void didUpdateWidget(PaginatedListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _totalPages = (widget.items.length / widget.itemsPerPage).ceil();
      if (_currentPage >= _totalPages && _totalPages > 0) {
        _currentPage = _totalPages - 1;
      }
    }
  }

  List<T> get _currentPageItems {
    final startIndex = _currentPage * widget.itemsPerPage;
    final endIndex = (startIndex + widget.itemsPerPage).clamp(0, widget.items.length);
    return widget.items.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return widget.emptyWidget ?? const SizedBox.shrink();
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: _currentPageItems.length,
            itemBuilder: (context, index) {
              final item = _currentPageItems[index];
              return widget.itemBuilder(context, item, index);
            },
          ),
        ),
        if (_totalPages > 1)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: TColors.grey.withOpacity(0.3)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: _currentPage > 0
                      ? () => setState(() => _currentPage--)
                      : null,
                  color: _currentPage > 0 ? TColors.bgPrimary : TColors.grey,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Page ${_currentPage + 1} of $_totalPages',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: _currentPage < _totalPages - 1
                      ? () => setState(() => _currentPage++)
                      : null,
                  color: _currentPage < _totalPages - 1 ? TColors.bgPrimary : TColors.grey,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
