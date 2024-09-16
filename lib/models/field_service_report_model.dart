// To parse this JSON data, do
//
//     final fieldServiceReportModelCustomer = fieldServiceReportModelCustomerFromJson(jsonString);

import 'dart:convert';

FieldServiceReportModelCustomer fieldServiceReportModelCustomerFromJson(String str) => FieldServiceReportModelCustomer.fromJson(json.decode(str));

String fieldServiceReportModelCustomerToJson(FieldServiceReportModelCustomer data) => json.encode(data.toJson());

class FieldServiceReportModelCustomer {
    int? fieldServiceReportId;
    String? customer;
    String? contact;
    String? address;
    int? tel;
    DateTime? date;
    String? arrivalTime;
    String? departureTime;
    int? caseNo;

    FieldServiceReportModelCustomer({
        this.fieldServiceReportId,
        this.customer,
        this.contact,
        this.address,
        this.tel,
        this.date,
        this.arrivalTime,
        this.departureTime,
        this.caseNo,
    });

    factory FieldServiceReportModelCustomer.fromJson(Map<String, dynamic> json) => FieldServiceReportModelCustomer(
        fieldServiceReportId: json["fieldServiceReportID"],
        customer: json["customer"],
        contact: json["contact"],
        address: json["address"],
        tel: json["tel"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        arrivalTime: json["arrivalTime"],
        departureTime: json["departureTime"],
        caseNo: json["caseNo"],
    );

    Map<String, dynamic> toJson() => {
        "fieldServiceReportID": fieldServiceReportId,
        "customer": customer,
        "contact": contact,
        "address": address,
        "tel": tel,
        "date": date?.toIso8601String(),
        "arrivalTime": arrivalTime,
        "departureTime": departureTime,
        "caseNo": caseNo,
    };
}
