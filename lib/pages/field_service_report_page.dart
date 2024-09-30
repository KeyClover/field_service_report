import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../database/data_result_api.dart';
import '../models/field_service_model.dart';
import '../database/field_service_report_SQLite.dart';
import '../models/signature_image_model.dart';
import '../models/signature_image_retrieve_model.dart';

class SignatureUploadPost {
  final int docId;
  final String imageType;
  final int createBy;
  final Uint8List? engineer_Signature;
  final Uint8List? customer_Signature;

  SignatureUploadPost({
    required this.docId,
    required this.imageType,
    required this.createBy,
    this.engineer_Signature,
    this.customer_Signature,
  });
}

Future<void> uploadSignatureToAPI(SignatureUploadPost signatureUploadPost) async {
  final restDataSource = RestDataSource();
  final String baseUrl = restDataSource.PostMultiFiles();
  final Uri apiUrl = Uri.parse('$baseUrl?docId=${signatureUploadPost.docId}&imageType=${signatureUploadPost.imageType}&createBy=${signatureUploadPost.createBy}');

  print('Uploading to URL: $apiUrl');

  var request = http.MultipartRequest('POST', apiUrl);
  
  if (signatureUploadPost.engineer_Signature != null) {
    request.files.add(http.MultipartFile.fromBytes(
      'engineer_Signature',
      signatureUploadPost.engineer_Signature!,
      filename: 'engineer_signature.png',
    ));
    print('Engineer signature added to request');
  }
  
  if (signatureUploadPost.customer_Signature != null) {
    request.files.add(http.MultipartFile.fromBytes(
      'customer_Signature',
      signatureUploadPost.customer_Signature!,
      filename: 'customer_signature.png',
    ));
    print('Customer signature added to request');
  }

  try {
    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('API Response: $responseBody');
    
    if (response.statusCode == 200) {
      print('Signature uploaded successfully');
    } else {
      print('Failed to upload signature. Status code: ${response.statusCode}');
      print('Response body: $responseBody');
    }
  } catch (e) {
    print('Error during API call: $e');
  }
}

class FieldServiceReportPage1 extends StatefulWidget {
  @override
  _FieldServiceReportPage1State createState() =>
      _FieldServiceReportPage1State();
}

class _FieldServiceReportPage1State extends State<FieldServiceReportPage1> {
  List<FieldServiceReport> reports = [];
  int CaseID = 0;

  @override
  void initState() {
    super.initState();
    fetchDataFromApi().then((_) {
      if (reports.isNotEmpty) {
        reports.first.fetchSignatures(CaseID);
      }
    });
  }

  // This function fetches data from the API and populates the reports list
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
            // Populate customer data from API response
            Map<String, dynamic> customerData = {
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

            // Create a FieldServiceReport for each unique license number
            Set<String> uniqueLicenseNumbers = Set();
            testModel.problem?.forEach((problem) {
              String licenseNo = problem.licenseNo ?? '';
              if (licenseNo.isNotEmpty &&
                  !uniqueLicenseNumbers.contains(licenseNo)) {
                uniqueLicenseNumbers.add(licenseNo);
                // Populate vehicle data from API response
                reports.add(FieldServiceReport(
                  customerData: customerData,
                  vehicleData: {
                    'license no.': licenseNo,
                    'create by': problem.createBy?.toString() ?? '',
                    'chassis': problem.chassisNo ?? '',
                    'brand': problem.catalogName ?? '',
                    'type': problem.type ?? '',
                    'imei': problem.mobileUnitIncomeId?.toString() ?? '',
                    'sim': problem.mobileUnitSimIncomeId?.toString() ?? '',
                    'model': problem.modelName ?? '',
                    'detail': problem.mainProcessName ?? '',
                  },
                ));
              }
            });
          }
        });

        // Load saved service data after fetching API data
        for (var report in reports) {
          await report.loadServiceData(CaseID);
        }
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
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              // Map through reports and build a container for each report
              ...reports.map((report) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: HexColor("E0E0E0"),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldServiceReport(report),
                    ],
                  ),
                );
              }).toList(),
              // If there are reports, add signature sections
              if (reports.isNotEmpty) ...[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: HexColor("E0E0E0"),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      _buildSignatureSection(reports.first),
                      SizedBox(height: 20),
                      _buildSignatureSectionForCustomer(reports.first),
                    ],
                  ),
                )
              ],
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  // This function builds the main content of the field service report
  Widget _buildFieldServiceReport(FieldServiceReport report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Container(
        
           child: Center(
             child: Text(
                'Case: ${CaseID}',
                style: const TextStyle(fontSize: 20, color: Colors.black),
                     ),
           ),
         ),

        // Customer Information Section - Auto-filled from API
        _buildTextField('Customer', report.customerData['customer']),
        _buildTextField('Contact', report.customerData['contact']),
        _buildTextField('Address', report.customerData['address']),
        _buildTextField('Tel', report.customerData['tel']),
        _buildTextField('Email', report.customerData['customer email']),

        SizedBox(height: 16),

        // Grid view for date, case number, arrival and departure times
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          children: [
            _buildGridField('Date', report.customerData['date']),
            _buildGridField('Case No.', report.customerData['caseNo']),
            _buildGridField('Arrival Time', report.customerData['arrivalTime']),
            _buildGridField(
                'Departure Time', report.customerData['departureTime']),
          ],
        ),

        SizedBox(height: 16),
        _buildCheckboxSection(report),

        SizedBox(height: 16),
        _buildCheckboxSection2(report),

        SizedBox(height: 16),
        _buildVehicleInfoSection(report),

        SizedBox(height: 16),
        _buildTextField('Remark', report.customerData['remark']),
      ],
    );
  }

  // This function builds the checkbox section for service type selection
  Widget _buildCheckboxSection(FieldServiceReport report) {
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
          // Checkboxes for different service types
          CheckboxListTile(
            title: Text('Installation'),
            value: report.isInstallationChecked,
            onChanged: (bool? value) {
              setState(() {
                report.isInstallationChecked = value ?? false;
              });
              report.saveServiceData(CaseID);
            },
          ),
          CheckboxListTile(
            title: Text('Reparation'),
            value: report.isReparationChecked,
            onChanged: (bool? value) {
              setState(() {
                report.isReparationChecked = value ?? false;
              });
              report.saveServiceData(CaseID);
            },
          ),
          CheckboxListTile(
            title: Text('Remove & Reinstall'),
            value: report.isRemoveChecked,
            onChanged: (bool? value) {
              setState(() {
                report.isRemoveChecked = value ?? false;
              });
              report.saveServiceData(CaseID);
            },
          ),
          CheckboxListTile(
            title: Text('Other'),
            value: report.isOtherChecked,
            onChanged: (bool? value) {
              setState(() {
                report.isOtherChecked = value ?? false;
              });
              report.saveServiceData(CaseID);
            },
          ),
          // Text field for specifying other service type
          if (report.isOtherChecked)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: report.otherController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Specify Other',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => report.saveServiceData(CaseID),
              ),
            ),
        ],
      ),
    );
  }

  // This function builds the checkbox section for tools selection
  Widget _buildCheckboxSection2(FieldServiceReport report) {
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
          // Checkboxes for different tools
          CheckboxListTile(
            title: Text('Magnetic Card Reader'),
            value: report.isMagneticCardReader,
            onChanged: (bool? value) {
              setState(() {
                report.isMagneticCardReader = value ?? false;
              });
              report.saveServiceData(CaseID);
            },
          ),
          CheckboxListTile(
            title: Text('Fuel Sensor'),
            value: report.isFuelSensor,
            onChanged: (bool? value) {
              setState(() {
                report.isFuelSensor = value ?? false;
              });
              report.saveServiceData(CaseID);
            },
          ),
          CheckboxListTile(
            title: Text('Temperature Sensor'),
            value: report.isTemperatureSensor,
            onChanged: (bool? value) {
              setState(() {
                report.isTemperatureSensor = value ?? false;
              });
              report.saveServiceData(CaseID);
            },
          ),
          CheckboxListTile(
            title: Text('On/Off Sensor'),
            value: report.isOnOffSensor,
            onChanged: (bool? value) {
              setState(() {
                report.isOnOffSensor = value ?? false;
              });
              report.saveServiceData(CaseID);
            },
          ),
          CheckboxListTile(
            title: Text('Other'),
            value: report.isOtherChecked2,
            onChanged: (bool? value) {
              setState(() {
                report.isOtherChecked2 = value ?? false;
              });
              report.saveServiceData(CaseID);
            },
          ),
          // Text field for specifying other tool
          if (report.isOtherChecked2)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                maxLines: null,
                controller: report.otherController2,
                decoration: InputDecoration(
                  labelText: 'Specify Other',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => report.saveServiceData(CaseID),
              ),
            ),
        ],
      ),
    );
  }

  // This function builds the vehicle info section with dynamic fields based on API data
  Widget _buildVehicleInfoSection(FieldServiceReport report) {
    final validVehicles = [report.vehicleData];

    if (validVehicles.isEmpty) {
      return SizedBox
          .shrink(); // Return an empty widget if there are no valid vehicles
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                // Build fields for each non-empty vehicle data
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
              fontSize: 12, // Adjust the size of the label
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(
              height: 5), // Add some space between the label and the input
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
                contentPadding: const EdgeInsets.symmetric(
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
              fontSize: 12,
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

  // This function builds the signature section for the Field Service Engineer
  Widget _buildSignatureSection(FieldServiceReport report) {
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
          child: report.engineerSignatureImage != null
              ? Image.memory(report.engineerSignatureImage!)
              : Signature(
                  controller: report.signatureController,
                  backgroundColor: Colors.white,
                ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  report.signatureController.clear();
                  report.engineerSignatureImage = null;
                });
              },
              child: Text('Clear Signature'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () async {
                await report.saveSignature(CaseID, true);
                setState(() {});
              },
              child: Text('Save Signature'),
            )
          ],
        ),
      ],
    );
  }

  // This function builds the signature section for the Customer
  Widget _buildSignatureSectionForCustomer(FieldServiceReport report) {
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
                // Checkbox for "YES" option
                Checkbox(
                  value: report.isServiceCompletedYes,
                  onChanged: (bool? value) {
                    setState(() {
                      report.isServiceCompletedYes = value ?? false;
                      if (report.isServiceCompletedYes) {
                        report.isServiceCompletedNo = false;
                      }
                    });
                    report.saveServiceData(CaseID);
                  },
                ),
                Text('YES'),
                SizedBox(width: 16),
                // Checkbox for "NO" option
                Checkbox(
                  value: report.isServiceCompletedNo,
                  onChanged: (bool? value) {
                    setState(() {
                      report.isServiceCompletedNo = value ?? false;
                      if (report.isServiceCompletedNo) {
                        report.isServiceCompletedYes = false;
                      }
                    });
                    report.saveServiceData(CaseID);
                  },
                ),
                Text('NO'),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),
        // Signature pad for customer
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: report.customerSignatureImage != null
              ? Image.memory(report.customerSignatureImage!)
              : Signature(
                  controller: report.customerSignatureController,
                  backgroundColor: Colors.white,
                ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  report.customerSignatureController.clear();
                  report.customerSignatureImage = null;
                });
              },
              child: Text('Clear Signature'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () async {
                await report.saveSignature(CaseID, false);
                setState(() {});
              },
              child: Text('Save Signature'),
            ),
          ],
        ),
      ],
    );
  }
}

class FieldServiceReport {
  Map<String, dynamic> customerData;
  Map<String, String> vehicleData;
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
  TextEditingController otherController = TextEditingController();
  TextEditingController otherController2 = TextEditingController();
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  final SignatureController customerSignatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  Uint8List? engineerSignatureImage;
  Uint8List? customerSignatureImage;

  FieldServiceReport({required this.customerData, required this.vehicleData});

  Future<void> loadServiceData(int caseID) async {
    final data = await FieldServiceDatabase.instance.getServiceData(caseID);
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
    
    // Fetch signatures from API
    await fetchSignatures(caseID);
  }

  Future<void> saveServiceData(int caseID) async {
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
    await FieldServiceDatabase.instance.saveServiceData(caseID, data);
  }

  Future<void> saveSignature(int CaseID, bool isEngineer) async {
    print('Saving signature for ${isEngineer ? "engineer" : "customer"}');
    final signatureImage = await (isEngineer ? signatureController : customerSignatureController).toPngBytes();
    if (signatureImage != null) {
      final signatureUploadPost = SignatureUploadPost(
        docId: CaseID,
        imageType: 'Signature',
        createBy: 1001,
        engineer_Signature: isEngineer ? signatureImage : null,
        customer_Signature: isEngineer ? null : signatureImage,
      );

      print('Uploading signature to API...');
      try {
        await uploadSignatureToAPI(signatureUploadPost);
        print('Signature uploaded successfully');

        // Update the local signature image
        if (isEngineer) {
          engineerSignatureImage = signatureImage;
          print('Engineer signature updated locally');
        } else {
          customerSignatureImage = signatureImage;
          print('Customer signature updated locally');
        }
      } catch (e) {
        print('Error uploading signature: $e');
      }
    } else {
      print('No signature image to save');
    }
  }

  Future<void> fetchSignatures(int caseID) async {
    final restDataSource = RestDataSource();
    final url = restDataSource.GetListFile(docId: caseID);
    
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<SignatureRetrieveModel> signatures = signatureRetrieveModelFromJson(response.body);
      for (var signature in signatures) {
        if (signature.engineerSignature != null && signature.engineerSignature!.isNotEmpty) {
          engineerSignatureImage = signature.engineerSignature!;
          signatureController.clear();
        }
        if (signature.customerSignature != null && signature.customerSignature!.isNotEmpty) {
          customerSignatureImage = signature.customerSignature!;
          customerSignatureController.clear();
        }
      }
    } else {
      print('Failed to fetch signatures: ${response.statusCode}');
    }
  }
}
