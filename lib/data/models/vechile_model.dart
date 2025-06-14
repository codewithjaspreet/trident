class VehicleModel {
  final String vehicle_type;
  final String company_make;
  final String company_model;
  final String veh_sl_no;
  final String vehicle_no;
  final String registration__no;
  final String registration_date;
  final String owner_name;
  final String gvw;
  final String unladen_wt;
  final String payload;
  final String chassis_no;
  final String engine_no;
  final String wheel_base;
  final String no_of_cylinders;
  final String road_tax_status;
  final String tyre_size;
  final String fitness_date;
  final String insurance_date;
  final String np_5_year;
  final String np_annual;
  final String ref_make_model;
  final String crate_capacity;
  VehicleModel({
    required this.vehicle_type,
    required this.company_make,
    required this.company_model,
    required this.veh_sl_no,
    required this.vehicle_no,
    required this.registration__no,
    required this.registration_date,
    required this.owner_name,
    required this.gvw,
    required this.unladen_wt,
    required this.payload,
    required this.chassis_no,
    required this.engine_no,
    required this.wheel_base,
    required this.no_of_cylinders,
    required this.road_tax_status,
    required this.tyre_size,
    required this.fitness_date,
    required this.insurance_date,
    required this.np_5_year,
    required this.np_annual,
    required this.ref_make_model,
    required this.crate_capacity,
  });

  Map<String, dynamic> toMap() {
    return {
      'vehicleType': vehicle_type,
      'companyMake': company_make,
      'companyModel': company_model,
      'vehSlNo': veh_sl_no,
      'vehicleNo': vehicle_no,
      'registrationNo': registration__no,
      'registrationDate': registration_date,
      'ownerName': owner_name,
      'gvw': gvw,
      'unladenWt': unladen_wt,
      'payload': payload,
      'chassisNo': chassis_no,
      'engineNo': engine_no,
      'wheelBase': wheel_base,
      'noOfCylinders': no_of_cylinders,
      'roadTaxStatus': road_tax_status,
      'tyreSize': tyre_size,
      'fitnessDate': fitness_date,
      'insuranceDate': insurance_date,
      'np5Year': np_5_year,
      'npAnnual': np_annual,
      'refMakeModel': ref_make_model,
      'crateCapacity': crate_capacity,
    };
  }


  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      vehicle_type: map["Vehicle Type"]?.toString() ?? "",
      company_make: map["Company Make"]?.toString() ?? "",
      company_model: map["Company Model"]?.toString() ?? "",
      veh_sl_no: map["Veh Sl No"]?.toString() ?? "",
      vehicle_no: map["Vehicle no."]?.toString() ?? "",
      registration__no: map["Registration  No."]?.toString() ?? "",
      registration_date: map["Registration Date"]?.toString() ?? "",
      owner_name: map["Owner Name"]?.toString() ?? "",
      gvw: map["GVW"]?.toString() ?? "",
      unladen_wt: map["Unladen Wt"]?.toString() ?? "",
      payload: map["Payload"]?.toString() ?? "",
      chassis_no: map["Chassis No"]?.toString() ?? "",
      engine_no: map["Engine No"]?.toString() ?? "",
      wheel_base: map["Wheel Base"]?.toString() ?? "",
      no_of_cylinders: map["No Of Cylinders"]?.toString() ?? "",
      road_tax_status: map["Road Tax Status"]?.toString() ?? "",
      tyre_size: map["Tyre Size"]?.toString() ?? "",
      fitness_date: map["Fitness Date"]?.toString() ?? "",
      insurance_date: map["Insurance Date"]?.toString() ?? "",
      np_5_year: map["NP 5 Year"]?.toString() ?? "",
      np_annual: map["NP Annual"]?.toString() ?? "",
      ref_make_model: map["Ref. Make/Model"]?.toString() ?? "",
      crate_capacity: map["Crate Capacity"]?.toString() ?? "",
    );
  }
}


