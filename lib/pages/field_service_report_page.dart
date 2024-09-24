import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/data_result_api.dart';
import '../models/field_service_model.dart';
import '../database/field_service_report_SQLite.dart';

class FieldServiceReportPage1 extends StatefulWidget {
  @override
  _FieldServiceReportPage1State createState() =>
      _FieldServiceReportPage1State();
}

class _FieldServiceReportPage1State extends State<FieldServiceReportPage1> {
  // Checkbox states
  bool isInstallationChecked = false;
  bool isReparationChecked = false;
  bool isRemoveChecked = false;
  bool isOtherChecked = false;

  bool isMagneticCardReader = false;
  bool isFuelSensor = false;
  bool isTemperatureSensor = false;
  bool isOnOffSensor = false;
  bool isOtherChecked2 = false;

  bool isServiceCompletedYes = false;
  bool isServiceCompletedNo = false;

  // Store API data for customer and vehicle info
  Map<String, dynamic> customerData = {};
  List<Map<String, String>> vehicleData = [];
  int CaseID = 0;
  TextEditingController otherController = TextEditingController();
  TextEditingController otherController2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  @override
  void dispose() {
    otherController.dispose();
    otherController2.dispose();
    super.dispose();
  }

  Future<void> loadServiceData() async {
    final data = await FieldServiceDatabase.instance.getServiceData(CaseID);
    setState(() {
      isInstallationChecked = data['is_installation'] == 1;
      isReparationChecked = data['is_reparation'] == 1;
      isRemoveChecked = data['is_remove'] == 1;
      isOtherChecked = data['is_other'] == 1;
      otherController.text = data['other_text'] ?? '';

      isMagneticCardReader = data['is_magnetic_card_reader'] == 1;
      isFuelSensor = data['is_fuel_sensor'] == 1;
      isTemperatureSensor = data['is_temperature_sensor'] == 1;
      isOnOffSensor = data['is_on_off_sensor'] == 1;
      isOtherChecked2 = data['is_other2'] == 1;
      otherController2.text = data['other_text2'] ?? '';
      isServiceCompletedYes = data['is_service_completed_yes'] == 1;
      isServiceCompletedNo = data['is_service_completed_no'] == 1;
    });
  }

  Future<void> saveServiceData() async {
    final data = {
      'is_installation': isInstallationChecked ? 1 : null,
      'is_reparation': isReparationChecked ? 1 : null,
      'is_remove': isRemoveChecked ? 1 : null,
      'is_other': isOtherChecked ? 1 : null,
      'other_text': isOtherChecked ? otherController.text : null,
      'is_magnetic_card_reader': isMagneticCardReader ? 1 : null,
      'is_fuel_sensor': isFuelSensor ? 1 : null,
      'is_temperature_sensor': isTemperatureSensor ? 1 : null,
      'is_on_off_sensor': isOnOffSensor ? 1 : null,
      'is_other2': isOtherChecked2 ? 1 : null,
      'other_text2': isOtherChecked2 ? otherController2.text : null,
      'is_service_completed_yes': isServiceCompletedYes ? 1 : null,
      'is_service_completed_no': isServiceCompletedNo ? 1 : null,
    };
    await FieldServiceDatabase.instance.saveServiceData(CaseID, data);
  }

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  final SignatureController _customerSignatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Future<void> fetchDataFromApi() async {
    try {
      final restDataSource = RestDataSource();
      final url = restDataSource.GetAllCasebyId(
          CaseID: 40003); // noted: I use 40003, 40002, 40001 as an example
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final testModel = TestModel.fromJson(jsonData);

        setState(() {
          CaseID = testModel.caseId ?? 0;

          if (testModel.testModelCase != null &&
              testModel.testModelCase!.isNotEmpty) {
            final caseData = testModel.testModelCase![0];
            customerData = {
              'customer': caseData.customer ?? '',
              'contact': caseData.contact ?? '',
              'address': caseData.address ?? '',
              'tel': caseData.contactPhone ?? '',
              'customer email': caseData.contactEmail ?? '',
              'date': caseData.openDateTime ?? '',
              'departureTime': caseData.endTime ?? '',
              'arrivalTime': caseData.beginTime ?? '',
              'caseNo': caseData.caseCode ?? '',
              'remark': caseData.remark ?? '',
            };
          }

          vehicleData = testModel.problem
                  ?.map((problem) => {
                        'license no.': problem.licenseNo ?? '',
                        'create by': problem.createBy?.toString() ?? '',
                        'chassis': problem.chassisNo ?? '',
                        'brand': problem.catalogName ?? '',
                        'type': problem.type ?? '',
                        'imei': problem.mobileUnitIncomeId?.toString() ?? '',
                        'sim': problem.mobileUnitSimIncomeId?.toString() ?? '',
                        'model': problem.modelName ?? '',
                        'action': problem.mainProcessName ?? '',
                      })
                  .toList() ??
              [];
        });

        // Load saved service data after fetching API data
        await loadServiceData();
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Field Service : ${CaseID} ',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: HexColor("#2e3150"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              color: HexColor("E0E0E0"), // Inside container color
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldServiceReportDisplay(),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildFieldServiceReportDisplay() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Information Section - Auto-filled from API
          _buildTextField('Customer', customerData['customer']),
          _buildTextField('Contact', customerData['contact']),
          _buildTextField('Address', customerData['address']),
          _buildTextField('Tel', customerData['tel']),
          _buildTextField('Email', customerData['customer email']),

          SizedBox(height: 16),

          GridView(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Prevent scroll within the grid
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2, // Adjusts the height of grid items
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            children: [
              _buildGridField('Date', customerData['date']),
              _buildGridField('Case No.', customerData['caseNo']),
              _buildGridField('Arrival Time', customerData['arrivalTime']),
              _buildGridField('Departure Time', customerData['departureTime']),
            ],
          ),

          SizedBox(
            height: 16,
          ),
          // Checkbox Section for user input
          _buildCheckboxSection(),

          SizedBox(height: 16),

          _buildCheckboxSection2(),

          SizedBox(height: 16),

          // Vehicle Information Section - Auto-filled from API
          _buildVehicleInfoSection(),

          SizedBox(height: 16),

          _buildTextField('Remark', customerData['remark']),

          SizedBox(height: 16),

          _buildSignatureSection(),

          SizedBox(
            height: 16,
          ),

          _buildSignatureSectionForCustomer(),
        ],
      ),
    );
  }

  // Build checkboxes for service type selection
  Widget _buildCheckboxSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service Type', style: TextStyle(fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: Text('Installation'),
            value: isInstallationChecked,
            onChanged: (bool? value) {
              setState(() {
                isInstallationChecked = value ?? false;
              });
              saveServiceData();
            },
          ),
          CheckboxListTile(
            title: Text('Reparation'),
            value: isReparationChecked,
            onChanged: (bool? value) {
              setState(() {
                isReparationChecked = value ?? false;
              });
              saveServiceData();
            },
          ),
          CheckboxListTile(
            title: Text('Remove & Reinstall'),
            value: isRemoveChecked,
            onChanged: (bool? value) {
              setState(() {
                isRemoveChecked = value ?? false;
              });
              saveServiceData();
            },
          ),
          CheckboxListTile(
            title: Text('Other'),
            value: isOtherChecked,
            onChanged: (bool? value) {
              setState(() {
                isOtherChecked = value ?? false;
              });
              saveServiceData();
            },
          ),
          if (isOtherChecked) // Conditionally display text field for "Other"
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: otherController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Specify Other',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => saveServiceData(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckboxSection2() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tools', style: TextStyle(fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: Text('Magnetic Card Reader'),
            value: isMagneticCardReader,
            onChanged: (bool? value) {
              setState(() {
                isMagneticCardReader = value ?? false;
              });
              saveServiceData();
            },
          ),
          CheckboxListTile(
            title: Text('Fuel Sensor'),
            value: isFuelSensor,
            onChanged: (bool? value) {
              setState(() {
                isFuelSensor = value ?? false;
              });
              saveServiceData();
            },
          ),
          CheckboxListTile(
            title: Text('Temperature Sensor'),
            value: isTemperatureSensor,
            onChanged: (bool? value) {
              setState(() {
                isTemperatureSensor = value ?? false;
              });
              saveServiceData();
            },
          ),
          CheckboxListTile(
            title: Text('On/Off Sensor'),
            value: isOnOffSensor,
            onChanged: (bool? value) {
              setState(() {
                isOnOffSensor = value ?? false;
              });
              saveServiceData();
            },
          ),
          CheckboxListTile(
            title: Text('Other'),
            value: isOtherChecked2,
            onChanged: (bool? value) {
              setState(() {
                isOtherChecked2 = value ?? false;
              });
              saveServiceData();
            },
          ),
          if (isOtherChecked2) // Conditionally display text field for "Other"
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                maxLines: null,
                controller: otherController2,
                decoration: InputDecoration(
                  labelText: 'Specify Other',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => saveServiceData(),
              ),
            ),
        ],
      ),
    );
  }

  // Build vehicle info section with dynamic fields based on API data
  Widget _buildVehicleInfoSection() {
    final validVehicles = vehicleData.where((vehicle) {
      final licenseNo = vehicle['license no.'];
      return licenseNo != null &&
          licenseNo != 'null' &&
          licenseNo.trim().isNotEmpty;
    }).toList();

    if (validVehicles.isEmpty) {
      return SizedBox
          .shrink(); // Return an empty widget if there are no valid vehicles
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (validVehicles.length > 1)
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Multiple Vehicles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ...validVehicles.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, String> vehicle = entry.value;
          return Container(
            margin: EdgeInsets.symmetric(vertical: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (validVehicles.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Vehicle ${index + 1}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ...vehicle.entries
                    .where((e) =>
                        e.value != null &&
                        e.value != 'null' &&
                        e.value.trim().isNotEmpty)
                    .map((e) => _buildVehicleField(e.key, e.value)),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildVehicleField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        maxLines: null,
        readOnly: true,
        initialValue: value ?? '',
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align the label to the left
        children: [
          // Custom Label on Top of the TextFormField
          Text(
            label, // Label is shown above the TextFormField
            style: TextStyle(
              fontSize: 16, // Adjust the size of the label
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 5), // Add some space between the label and the input
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Inside container color
              borderRadius:
                  BorderRadius.circular(8.0), // Optional rounded corners
            ),
            child: TextFormField(
              initialValue: value ??
                  '', // Provide empty string as default if value is null
              readOnly: true, // Make it read-only if necessary
              maxLines: null, // Allow multi-line input if needed
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16), // Adjust padding inside the field
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]),
        ),
        Container(
          decoration: BoxDecoration(
            color: HexColor("FFFFFF"),
          ),
          child: TextFormField(
            initialValue: value,
            readOnly: true,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  // Signature Pad and Actions for Field Service Engineer
  Widget _buildSignatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Field Service Engineer Signature',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Signature(
            controller: _signatureController,
            backgroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                _signatureController.clear(); // Clear the signature
              },
              child: Text('Clear Signature'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignatureSectionForCustomer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Service Completed',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 16),
            Row(
              children: [
                Checkbox(
                  value: isServiceCompletedYes,
                  onChanged: (bool? value) {
                    setState(() {
                      isServiceCompletedYes = value ?? false;
                      if (isServiceCompletedYes) {
                        isServiceCompletedNo = false;
                      }
                    });
                    saveServiceData();
                  },
                ),
                Text('YES'),
                SizedBox(width: 16),
                Checkbox(
                  value: isServiceCompletedNo,
                  onChanged: (bool? value) {
                    setState(() {
                      isServiceCompletedNo = value ?? false;
                      if (isServiceCompletedNo) {
                        isServiceCompletedYes = false;
                      }
                    });
                    saveServiceData();
                  },
                ),
                Text('NO'),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Signature(
            controller: _customerSignatureController,
            backgroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                _customerSignatureController.clear(); // Clear the signature
              },
              child: Text('Clear Signature'),
            ),
          ],
        ),
      ],
    );
  }
}
