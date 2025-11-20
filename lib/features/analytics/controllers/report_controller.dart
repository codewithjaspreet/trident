// lib/features/analytics/controllers/report_controller.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../models/trip_report_model.dart';

class ReportController extends GetxController {
  final _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var isExporting = false.obs;
  var allTrips = <TripReport>[].obs;

  int get totalTrips => allTrips.length;
  int get completedTrips => allTrips.where((t) => t.isCompleted).length;
  int get pendingTrips => allTrips.where((t) => t.isPending).length;

  @override
  void onInit() {
    super.onInit();
    fetchAllTrips();
  }

  Future<void> fetchAllTrips() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('trips')
          .orderBy('trip_date', descending: true)
          .get();

      allTrips.value = snapshot.docs
          .map((doc) => TripReport.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load trips: $e',
          backgroundColor: Colors.red.shade100);
    } finally {
      isLoading.value = false;
    }
  }

  List<TripReport> getDayTrips() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return allTrips.where((t) {
      final tripDate = DateTime(t.tripDate.year, t.tripDate.month, t.tripDate.day);
      final today = DateTime(now.year, now.month, now.day);
      return tripDate.isAtSameMomentAs(today);
    }).toList();
  }

  List<TripReport> getWeekTrips() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(start.year, start.month, start.day);
    return allTrips.where((t) => t.tripDate.isAfter(startDate)).toList();
  }

  List<TripReport> getMonthTrips() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return allTrips.where((t) => t.tripDate.isAfter(start)).toList();
  }

  List<VehicleStats> getTopVehicles() {
    final map = <String, int>{};
    for (var t in allTrips) {
      map[t.billedVehicle] = (map[t.billedVehicle] ?? 0) + 1;
    }
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.map((e) => VehicleStats(e.key, e.value)).toList();
  }

  List<DriverPerformance> getTopDrivers() {
    final map = <String, List<TripReport>>{};
    for (var t in allTrips) {
      if (!map.containsKey(t.driverName)) {
        map[t.driverName] = [];
      }
      map[t.driverName]!.add(t);
    }

    final drivers = <DriverPerformance>[];
    map.forEach((name, trips) {
      final completed = trips.where((t) => t.isCompleted).length;
      drivers.add(DriverPerformance(name, trips.length, completed));
    });

    drivers.sort((a, b) => b.completionRate.compareTo(a.completionRate));
    return drivers;
  }
  Future<void> exportExcel(List<TripReport> trips, String name) async {
    if (trips.isEmpty) {
      Get.snackbar('No Data', 'No trips to export',
          backgroundColor: Colors.orange.shade100);
      return;
    }

    try {
      isExporting.value = true;

      print('Starting Excel export with ${trips.length} trips'); // Debug

      // Create Excel with explicit initialization
      var excel = Excel.createExcel();

      // Delete default sheet and create new one
      var defaultSheet = excel.getDefaultSheet();
      if (defaultSheet != null) {
        excel.delete(defaultSheet);
      }
      excel.copy('Sheet1', 'Report');
      excel.delete('Sheet1');

      Sheet sheet = excel['Report'];

      // Write headers - Row 0
      var headers = ['Date', 'Driver', 'Vehicle', 'Source', 'Destination', 'Status'];
      for (int col = 0; col < headers.length; col++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
            .value = TextCellValue(headers[col]);
      }

      // Write data rows - Starting from Row 1
      for (int row = 0; row < trips.length; row++) {
        var trip = trips[row];


        // Column 0 - Date
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row + 1))
            .value = TextCellValue(DateFormat('dd/MM/yyyy').format(trip.tripDate));

        // Column 1 - Driver
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row + 1))
            .value = TextCellValue(trip.driverName);

        // Column 2 - Vehicle
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row + 1))
            .value = TextCellValue(trip.billedVehicle);



        // Column 4 - Destination
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row + 1))
            .value = TextCellValue(trip.destination);

        // Column 5 - Status
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row + 1))
            .value = TextCellValue(trip.tripStatus);


      }

      print('Excel data written, now saving...'); // Debug

      // Encode - Same as PDF's pdf.save()
      var fileBytes = excel.encode();

      if (fileBytes == null) {
        throw Exception('Failed to encode Excel file');
      }

      print('Excel encoded, file size: ${fileBytes.length} bytes'); // Debug

      // Save to file - Same pattern as PDF
      final dir = await getApplicationDocumentsDirectory();
      final fileName = '${name}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final filePath = '${dir.path}/$fileName';

      print('Saving to: $filePath'); // Debug

      // Write bytes - Same as PDF
      final file = File(filePath);
      await file.writeAsBytes(fileBytes);

      print('File written, now sharing...'); // Debug

      // Share - Same as PDF
      await Share.shareXFiles([XFile(filePath)], text: name);

      Get.snackbar('Success', 'Excel exported successfully',
          backgroundColor: Colors.blue.shade50,
          duration: const Duration(seconds: 2));

    } catch (e, stackTrace) {
      print('Excel Export Error: $e'); // Debug
      print('Stack trace: $stackTrace'); // Debug
      Get.snackbar('Error', 'Export failed: $e',
          backgroundColor: Colors.red.shade100,
          duration: const Duration(seconds: 3));
    } finally {
      isExporting.value = false;
    }
  }

  Future<void> exportPDF(List<TripReport> trips, String name) async {
    try {
      isExporting.value = true;

      final pdf = pw.Document();

      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(name,
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Date', 'Driver', 'Vehicle', 'Route', 'Status'],
              data: trips.map((t) => [
                DateFormat('dd/MM/yy').format(t.tripDate),
                t.driverName,
                t.billedVehicle,
                t.route,
                t.tripStatus,
              ]).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
      ));

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/${name}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await File(path).writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(path)], text: name);
      Get.snackbar('Success', 'PDF exported',
          backgroundColor: Colors.blue.shade50);
    } catch (e) {
      Get.snackbar('Error', 'Export failed: $e',
          backgroundColor: Colors.red.shade100);
    } finally {
      isExporting.value = false;
    }
  }

  // Alias method for compatibility
  Future<void> shareFile() async {
    Get.snackbar('Info', 'Use export buttons to share files',
        backgroundColor: Colors.blue.shade50);
  }
}