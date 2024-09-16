
import 'package:flutter/material.dart';

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

  // Store API data for customer and vehicle info
  Map<String, dynamic> customerData = {};
  List<Map<String, String>> vehicleData = [];

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
      'date': '2024-09-01',
      'departureTime': '08:00 AM',
      'arrivalTime': '10:00 AM',
      'caseNo': '1'
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
        title: Text('Field Service Report: (Number)'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Information Section - Auto-filled from API
            _buildCustomerInfoSection(),

            SizedBox(height: 16),

            // Checkbox Section for user input
            _buildCheckboxSection(),

            SizedBox(height: 16),

            // Vehicle Information Section - Auto-filled from API
            _buildVehicleInfoSection(),

            SizedBox(height: 24),

            // Next Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FieldServiceReportPage2()),
                  );
                },
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build customer info section using fetched API data
  Widget _buildCustomerInfoSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer: ${customerData['customer'] ?? ''}'),
          Text('Contact: ${customerData['contact'] ?? ''}'),
          Text('Address: ${customerData['address'] ?? ''}'),
          Text('Tel: ${customerData['tel'] ?? ''}'),
          Text('Date: ${customerData['date'] ?? ''}'),
          Text('Departure Time: ${customerData['departureTime'] ?? ''}'),
          Text('Arrival Time: ${customerData['arrivalTime'] ?? ''}'),
          Text('Case No: ${customerData['caseNo']?? ''}')
        ],
      ),
    );
  }

  // Build checkboxes for service type selection
  Widget _buildCheckboxSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vehicle ID: ${vehicle['vehicleId'] ?? ''}'),
              Text('Chassis: ${vehicle['chassis'] ?? ''}'),
              Text('Brand: ${vehicle['brand'] ?? ''}'),
              Text('Type: ${vehicle['type'] ?? ''}'),
              Text('IMEI: ${vehicle['imei'] ?? ''}'),
              Text('SIM: ${vehicle['sim'] ?? ''}'),
              Text('Model: ${vehicle['model'] ?? ''}'),
              Text('Action: ${vehicle['action'] ?? ''}'),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// Page 2 placeholder
class FieldServiceReportPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Field Service Report: (Number)'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go Back'),
        ),
      ),
    );
  }
}


  Widget _buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

