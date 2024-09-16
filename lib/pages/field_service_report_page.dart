import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';

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

  // Store API data for customer and vehicle info
  Map<String, dynamic> customerData = {};
  List<Map<String, String>> vehicleData = [];

  TextEditingController otherController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  // Simulating API data fetching
  Future<void> fetchDataFromApi() async {
    // Mocking customer data API response
    customerData = {
      'customer': 'John Doe',
      'contact': 'johndoe@example.com',
      'address': '123 Main St, Springfield',
      'tel': '123-456-7890',
      'customer email': 'sample@gmail.com',
      'date': '2024-09-01',
      'departureTime': '08:00 AM',
      'arrivalTime': '10:00 AM',
      'caseNo': '1',
      'remark':
          'ส่งเซนเซอร์ลนยางตัวใหม่ จำนวน 6 ตัว  เพื่อเปลี่ยนให้กับ  บริษัท รถเจาะไทย จำกัด MA-001 (CAT740-01) ติดต่อช่างหน้างาน ช่างไพโรจน์ 0936697041 \nที่อยู่ \nคุณสมคิด ปกครอง  086 272 2278\n123/27\nม.3 ต.บางนอน\nอ.เมือง จ.ระนอง 85000'
    };

    // Mocking vehicle data API response
    vehicleData = [
      {
        'vehicleId': 'ABC123',
        'chassis': 'XYZ987',
        'brand': 'Toyota',
        'type': 'Sedan',
        'imei': '123456789012345',
        'sim': '0987654321',
        'model': 'Camry',
        'action': 'Maintenance'
      },
      {
        'vehicleId': 'DEF456',
        'chassis': 'LMN654',
        'brand': 'Honda',
        'type': 'SUV',
        'imei': '987654321098765',
        'sim': '1234567890',
        'model': 'CR-V',
        'action': 'Repair'
      },
      {
        'vehicleId': 'DEF456',
        'chassis': 'LMN654',
        'brand': 'Honda',
        'type': 'SUV',
        'imei': '987654321098765',
        'sim': '1234567890',
        'model': 'CR-V',
        'action': 'Repair'
      }
    ];

    // Update state to display fetched data
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Field Service: (Number)',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: HexColor("#2e3150"),
      ),
      body: SingleChildScrollView(
        
        padding: EdgeInsets.all(16.0),
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
                childAspectRatio: 3, // Adjusts the height of grid items
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              children: [
                _buildGridField('Date', customerData['date']),
                _buildGridField('Case No.', customerData['caseNo']),
                _buildGridField('Arrival Time', customerData['arrivalTime']),
                _buildGridField(
                    'Departure Time', customerData['departureTime']),
              ],
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
          ],
        ),
      ),
      backgroundColor: Colors.white,
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
            },
          ),
          CheckboxListTile(
            title: Text('Reparation'),
            value: isReparationChecked,
            onChanged: (bool? value) {
              setState(() {
                isReparationChecked = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Remove & Reinstall'),
            value: isRemoveChecked,
            onChanged: (bool? value) {
              setState(() {
                isRemoveChecked = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Other'),
            value: isOtherChecked,
            onChanged: (bool? value) {
              setState(() {
                isOtherChecked = value ?? false;
              });
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
            },
          ),
          CheckboxListTile(
            title: Text('Fuel Sensor'),
            value: isFuelSensor,
            onChanged: (bool? value) {
              setState(() {
                isFuelSensor = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Temperature Sensor'),
            value: isTemperatureSensor,
            onChanged: (bool? value) {
              setState(() {
                isTemperatureSensor = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text('On/Off Sensor'),
            value: isOnOffSensor,
            onChanged: (bool? value) {
              setState(() {
                isOnOffSensor = value ?? false;
              });
            },
          ),
          if (isOnOffSensor) // Conditionally display text field for "Other"
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                maxLines: null,
                controller: otherController,
                decoration: InputDecoration(
                  labelText: 'Specify Other',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          CheckboxListTile(
            title: Text('Other'),
            value: isOtherChecked2,
            onChanged: (bool? value) {
              setState(() {
                isOtherChecked2 = value ?? false;
              });
            },
          ),
          if (isOtherChecked2) // Conditionally display text field for "Other"
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                maxLines: null,
                controller: otherController,
                decoration: InputDecoration(
                  labelText: 'Specify Other',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Build vehicle info section with dynamic fields based on API data
  Widget _buildVehicleInfoSection() {
    return Column(
      children: vehicleData.map((vehicle) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             _buildVehicleField('Vehicle ID', vehicle['vehicleId']),
            _buildVehicleField('Chassis', vehicle['chassis']),
            _buildVehicleField('Brand', vehicle['brand']),
            _buildVehicleField('Type', vehicle['type']),
            _buildVehicleField('IMEI', vehicle['imei']),
            _buildVehicleField('SIM', vehicle['sim']),
            _buildVehicleField('Model', vehicle['model']),
            _buildVehicleField('Action', vehicle['action']),
            ],
          ),
        );
      }).toList(),
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

  Widget _buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        maxLines: null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildGridField(String label, String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      maxLines: null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
