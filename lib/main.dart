import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: FieldServiceReport()));
}

class FieldServiceReport extends StatefulWidget {
  @override
  _FieldServiceReportState createState() => _FieldServiceReportState();
}

class _FieldServiceReportState extends State<FieldServiceReport> {
  bool installation = false;
  bool reparation = false;
  bool removeReinstall = false;
  bool other = false;

  bool magneticCardReader = false;
  bool fuelSensor = false;
  bool temperatureSensor = false;
  bool onOffSensor = false;

  String? serviceCompleted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Field Service Report'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Customer'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Contact'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Tel'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Date'),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Arrival Time'),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Departure Time'),
                  ),
                ),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Case No.'),
            ),
            SizedBox(height: 16.0),
            Text('Service Options:'),
            Row(
              children: [
                Checkbox(
                  value: installation,
                  onChanged: (bool? value) {
                    setState(() {
                      installation = value!;
                    });
                  },
                ),
                Text('Installation'),
                Checkbox(
                  value: reparation,
                  onChanged: (bool? value) {
                    setState(() {
                      reparation = value!;
                    });
                  },
                ),
                Text('Reparation'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: removeReinstall,
                  onChanged: (bool? value) {
                    setState(() {
                      removeReinstall = value!;
                    });
                  },
                ),
                Text('Remove & Reinstall'),
                Checkbox(
                  value: other,
                  onChanged: (bool? value) {
                    setState(() {
                      other = value!;
                    });
                  },
                ),
                Text('Other'),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Sensors:'),
            Row(
              children: [
                Checkbox(
                  value: magneticCardReader,
                  onChanged: (bool? value) {
                    setState(() {
                      magneticCardReader = value!;
                    });
                  },
                ),
                Text('Magnetic Card Reader'),
                Checkbox(
                  value: fuelSensor,
                  onChanged: (bool? value) {
                    setState(() {
                      fuelSensor = value!;
                    });
                  },
                ),
                Text('Fuel Sensor'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: temperatureSensor,
                  onChanged: (bool? value) {
                    setState(() {
                      temperatureSensor = value!;
                    });
                  },
                ),
                Text('Temperature Sensor'),
                Checkbox(
                  value: onOffSensor,
                  onChanged: (bool? value) {
                    setState(() {
                      onOffSensor = value!;
                    });
                  },
                ),
                Text('On/Off Sensor'),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Vehicle Information:'),
            TextFormField(
              decoration: InputDecoration(labelText: 'Vehicle ID'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Chassis'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Brand'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'IMEI'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'SIM'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Model'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Action'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Remark'),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            Text('Service Completed:'),
            Row(
              children: [
                Radio<String>(
                  value: 'YES',
                  groupValue: serviceCompleted,
                  onChanged: (String? value) {
                    setState(() {
                      serviceCompleted = value;
                    });
                  },
                ),
                Text('YES'),
                Radio<String>(
                  value: 'NO',
                  groupValue: serviceCompleted,
                  onChanged: (String? value) {
                    setState(() {
                      serviceCompleted = value;
                    });
                  },
                ),
                Text('NO'),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle form submission logic
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
