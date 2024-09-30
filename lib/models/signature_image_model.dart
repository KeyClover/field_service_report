// To parse this JSON data, do
//
//     final signatureModel = signatureModelFromJson(jsonString);

import 'dart:convert';

SignatureModel signatureModelFromJson(String str) => SignatureModel.fromJson(json.decode(str));

String signatureModelToJson(SignatureModel data) => json.encode(data.toJson());

class SignatureModel {
    int? docId;
    String? imageType;
    int? createBy;
    String? engineer_Signature;
    String? customer_Signature;

    SignatureModel({
        this.docId,
        this.imageType,
        this.createBy,
        this.engineer_Signature,
        this.customer_Signature,
    });

    factory SignatureModel.fromJson(Map<String, dynamic> json) => SignatureModel(
        docId: json["docId"],
        imageType: json["imageType"],
        createBy: json["createBy"],
        engineer_Signature: json["engineer_Signature"],
        customer_Signature: json["customer_Signature"],
    );

    Map<String, dynamic> toJson() => {
        "docId": docId,
        "imageType": imageType,
        "createBy": createBy,
        "engineer_Signature": engineer_Signature,
        "customer_Signature": customer_Signature,
    };
}
