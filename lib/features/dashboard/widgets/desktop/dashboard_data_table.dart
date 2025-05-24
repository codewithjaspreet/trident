import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trident/common/widgets/containers/rounded_container.dart';
import 'package:trident/utils/constants/colors.dart';

import '../../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../../utils/constants/sizes.dart';

class DashboardDataTable extends StatelessWidget {
  const DashboardDataTable({super.key});

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
                   child: Center(
                     child: Flexible(
                       child: Text("View All" , style: GoogleFonts.lexend(
                          fontSize: TSizes.fontSizeSm,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff7152F3),
                       ),),
                     ),
                   ),

                 ),
               )
              ],
            ),
          ),
          Expanded(
            child: TPaginatedDataTable(
            minWidth: 786,
            dataRowHeight: 56,
            rowsPerPage: 10,
            columns: const [
              DataColumn(label: Text('Trip ID')),
              DataColumn(label: Text('Driver Name')),
              DataColumn(label: Text('Vehicle Type')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Date')),
            ],
            source: TripDataTableSource(),
                    ),
          ),
      ],
      ),
    );
  }
}

/// DataTableSource with 20 mock trip records
class TripDataTableSource extends DataTableSource {
  final List<Map<String, String>> _data = List.generate(20, (index) {
    return {
      'tripId': 'TRIP${100 + index}',
      'driver': 'Driver ${index + 1}',
      'vehicle': ['Sedan', 'SUV', 'Hatchback', 'Van'][index % 4],
      'status': ['Completed', 'In Progress', 'Cancelled'][index % 3],
      'date': '2023-08-${(index % 30 + 1).toString().padLeft(2, '0')}',
    };
  });

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final trip = _data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(trip['tripId']!)),
        DataCell(Text(trip['driver']!)),
        DataCell(Text(trip['vehicle']!)),
        DataCell(Text(trip['status']!)),
        DataCell(Text(trip['date']!)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
