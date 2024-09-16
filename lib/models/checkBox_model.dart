class checkBoxModel {
  bool isChecked;
  String label;
  String? otherText;
  String? onOffSensorText;

  checkBoxModel({
    required this.label,
    this.isChecked = false,
    this.otherText = '',
    this.onOffSensorText = '',
  });
}
