// To parse this JSON data, do
//
//     final signatureRetrieveModel = signatureRetrieveModelFromJson(jsonString);

import 'dart:convert';

List<SignatureRetrieveModel> signatureRetrieveModelFromJson(String str) => List<SignatureRetrieveModel>.from(json.decode(str).map((x) => SignatureRetrieveModel.fromJson(x)));

String signatureRetrieveModelToJson(List<SignatureRetrieveModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SignatureRetrieveModel {
    int? id;
    String? fileName;
    String? fileData;
    int? fileType;
    int? docId;
    String? imageType;
    String? engineerSignatureName;
    String? engineerSignature;
    String? customerSignatureName;
    String? customerSignature;
    DateTime? createDate;
    int? createBy;

    SignatureRetrieveModel({
        this.id,
        this.fileName,
        this.fileData,
        this.fileType,
        this.docId,
        this.imageType,
        this.engineerSignatureName,
        this.engineerSignature,
        this.customerSignatureName,
        this.customerSignature,
        this.createDate,
        this.createBy,
    });

    factory SignatureRetrieveModel.fromJson(Map<String, dynamic> json) => SignatureRetrieveModel(
        id: json["ID"],
        fileName: json["FileName"],
        fileData: json["FileData"],
        fileType: json["FileType"],
        docId: json["DocId"],
        imageType: json["ImageType"],
        engineerSignatureName: json["Engineer_SignatureName"],
        engineerSignature: json["Engineer_Signature"],
        customerSignatureName: json["Customer_SignatureName"],
        customerSignature: json["Customer_Signature"],
        createDate: json["CreateDate"] == null ? null : DateTime.parse(json["CreateDate"]),
        createBy: json["CreateBy"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "FileName": fileName,
        "FileData": fileData,
        "FileType": fileType,
        "DocId": docId,
        "ImageType": imageType,
        "Engineer_SignatureName": engineerSignatureName,
        "Engineer_Signature": engineerSignature,
        "Customer_SignatureName": customerSignatureName,
        "Customer_Signature": customerSignature,
        "CreateDate": createDate?.toIso8601String(),
        "CreateBy": createBy,
    };
}
