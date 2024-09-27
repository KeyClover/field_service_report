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
    String? engineerSignature;
    String? customerSignature;

    SignatureModel({
        this.docId,
        this.imageType,
        this.createBy,
        this.engineerSignature,
        this.customerSignature,
    });

    factory SignatureModel.fromJson(Map<String, dynamic> json) => SignatureModel(
        docId: json["docId"],
        imageType: json["imageType"],
        createBy: json["createBy"],
        engineerSignature: json["engineer_Signature"],
        customerSignature: json["customer_Signature"],
    );

    Map<String, dynamic> toJson() => {
        "docId": docId,
        "imageType": imageType,
        "createBy": createBy,
        "engineer_Signature": engineerSignature,
        "customer_Signature": customerSignature,
    };
}
