import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trident/features/dashboard/controllers/dashboard_controller.dart';
import 'package:trident/features/dashboard/views/dashboard.dart';

class TridentNavigationBar extends StatelessWidget {
   TridentNavigationBar({super.key});

  DashBoardController dashBoardController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      init: NavigationController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: _buildCurrentScreen(controller.currentIndex.value),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomNavigationBar(
                currentIndex: controller.currentIndex.value,
                onTap: controller.changeIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.blue[700],
                unselectedItemColor: Colors.grey[600],
                elevation: 8,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.local_shipping_outlined),
                    activeIcon: Icon(Icons.local_shipping),
                    label: 'All Trips',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.rate_review_outlined),
                    activeIcon: Icon(Icons.rate_review),
                    label: 'Review Trips',
                  ),
                ],
              ),

            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentScreen(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const DashboardScreen();
      default:
        return const DashboardScreen();
    }
  }
}

// Placeholder controller - you can replace this with your own
class NavigationController extends GetxController {
  // reactive variable to hold the current index
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;

    DashBoardController controller = Get.find<DashBoardController>();
    if (index == 0) {
      controller.getAllCreatedTrips();
    } else if (index == 1) {
      controller.getAllReviewingTrips();
    }
  }
}


// All Trips Screen
class AllTripsScreen extends StatelessWidget {
  const AllTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Trips',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search trips...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Trips List
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.local_shipping,
                          color: Colors.blue[700],
                          size: 24,
                        ),
                      ),
                      title: Text(
                        'Trip #${1000 + index}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Mumbai → Delhi',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Status: In Transit',
                            style: TextStyle(
                              color: Colors.green[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Review Trips Screen
class ReviewTripsScreen extends StatelessWidget {
  const ReviewTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Review Trips',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter Chips
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip('All', true),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending Review', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Completed', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Rejected', false),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Review Trips List
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Trip #${2000 + index}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: index % 2 == 0 ? Colors.orange[50] : Colors.green[50],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  index % 2 == 0 ? 'Pending' : 'Approved',
                                  style: TextStyle(
                                    color: index % 2 == 0 ? Colors.orange[700] : Colors.green[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Route: Chennai → Bangalore',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Driver: John Doe',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.visibility, size: 18),
                                  label: const Text('View Details'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[700],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (index % 2 == 0)
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.check, size: 18),
                                    label: const Text('Approve'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.green[700],
                                      side: BorderSide(color: Colors.green[700]!),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool value) {},
      selectedColor: Colors.blue[100],
      backgroundColor: Colors.grey[100],
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue[700] : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.blue[300]! : Colors.grey[300]!,
        ),
      ),
    );
  }
}