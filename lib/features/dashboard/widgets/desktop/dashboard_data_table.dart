import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:trident/common/widgets/containers/rounded_container.dart';
import 'package:trident/features/dashboard/controllers/dashboard_controller.dart';
import 'package:trident/utils/constants/colors.dart';

import '../../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../../data/models/trip_model.dart';
import '../../../../utils/constants/sizes.dart';

class DashboardDataTable extends StatelessWidget {
   DashboardDataTable({super.key});

  DashBoardController dashBoardController  = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( right: TSizes.lg, top: TSizes.lg, bottom: TSizes.lg),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffE5E5E5),
          width: 1,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: Column(
        children:[

          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Text(
                    'Trips',
                    style: GoogleFonts.lexend(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: TColors.textPrimary,
                    ),
                  ),
                ),
               Container(
                 margin: const EdgeInsets.symmetric(horizontal: TSizes.sm),

                 child: TRoundedContainer(
                   borderColor: TColors.grey.withOpacity(0.1),
                   backgroundColor: Colors.white,
                   width: 90,
                   height: 50,
                   child: const Center(
                     child: Flexible(
                       child: Icon(Icons.refresh)
                     ),
                   ),

                 ),
               )
              ],
            ),
          ),
          Obx(() => dashBoardController.allCreatedTrips.isEmpty
              ? const Padding(
            padding: EdgeInsets.all(20),
            child: Text('No Trips Found'),
          )
              : Expanded(
            child: TPaginatedDataTable(
              minWidth: 786,
              dataRowHeight: 56,
              rowsPerPage: 10,
              columns: const [
                DataColumn(label: Text('Trip ID')),
                DataColumn(label: Text('Driver Name')),
                DataColumn(label: Text('Vehicle No.')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Created At')),
              ],
              source: TripDataTableSource(dashBoardController.allCreatedTrips),
            ),
          )),
      ],
      ),
    );
  }
}

/// DataTableSource with 20 mock trip records
class TripDataTableSource extends DataTableSource {
  final List<TripModel> trips;

  TripDataTableSource(this.trips);

  @override
  DataRow? getRow(int index) {
    if (index >= trips.length) return null;
    final trip = trips[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('TRIP ${index + 100}')),
        DataCell(Text(trip.driverName)),
        DataCell(Text(trip.billedVehicle)),
        DataCell(Text(trip.status)),
        DataCell(Text(DateFormat('dd MMM yyyy, hh:mm:ss a', 'en_IN').format(trip.tripDate.toLocal()))),

      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => trips.length;

  @override
  int get selectedRowCount => 0;
}
