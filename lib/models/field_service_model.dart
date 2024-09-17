// To parse this JSON data, do
//
//     final testModel = testModelFromJson(jsonString);

import 'dart:convert';

TestModel testModelFromJson(String str) => TestModel.fromJson(json.decode(str));

String testModelToJson(TestModel data) => json.encode(data.toJson());

class TestModel {
    int? caseId;
    List<Case>? testModelCase;
    List<Problem>? problem;
    List<TaskCase>? taskCase;

    TestModel({
        this.caseId,
        this.testModelCase,
        this.problem,
        this.taskCase,
    });

    factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
        caseId: json["CaseID"],
        testModelCase: json["Case"] == null ? [] : List<Case>.from(json["Case"]!.map((x) => Case.fromJson(x))),
        problem: json["Problem"] == null ? [] : List<Problem>.from(json["Problem"]!.map((x) => Problem.fromJson(x))),
        taskCase: json["TaskCase"] == null ? [] : List<TaskCase>.from(json["TaskCase"]!.map((x) => TaskCase.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "CaseID": caseId,
        "Case": testModelCase == null ? [] : List<dynamic>.from(testModelCase!.map((x) => x.toJson())),
        "Problem": problem == null ? [] : List<dynamic>.from(problem!.map((x) => x.toJson())),
        "TaskCase": taskCase == null ? [] : List<dynamic>.from(taskCase!.map((x) => x.toJson())),
    };
}

class Problem {
    int? problemId;
    String? problemItem;
    int? vehicleId;
    int? caseId;
    int? mainProcessId;
    int? subProcessId;
    String? appointmentDescription;
    String? appointmentDate;
    String? appointmentTime;
    int? appointmentBy;
    String? recoveryDescription;
    String? recoveryDate;
    String? recoveryTime;
    int? recoveryBy;
    int? recoveryTypeId;
    int? exceptRepeatRepairFlag;
    String? remark;
    dynamic projectId;
    int? statusId;
    DateTime? createDate;
    int? createBy;
    DateTime? modifyDate;
    int? modifyBy;
    String? appointmentDateTime;
    String? mainProcessName;
    dynamic licenseNo;
    String? type;
    String? status;

    Problem({
        this.problemId,
        this.problemItem,
        this.vehicleId,
        this.caseId,
        this.mainProcessId,
        this.subProcessId,
        this.appointmentDescription,
        this.appointmentDate,
        this.appointmentTime,
        this.appointmentBy,
        this.recoveryDescription,
        this.recoveryDate,
        this.recoveryTime,
        this.recoveryBy,
        this.recoveryTypeId,
        this.exceptRepeatRepairFlag,
        this.remark,
        this.projectId,
        this.statusId,
        this.createDate,
        this.createBy,
        this.modifyDate,
        this.modifyBy,
        this.appointmentDateTime,
        this.mainProcessName,
        this.licenseNo,
        this.type,
        this.status,
    });

    factory Problem.fromJson(Map<String, dynamic> json) => Problem(
        problemId: json["ProblemID"],
        problemItem: json["ProblemItem"],
        vehicleId: json["VehicleID"],
        caseId: json["CaseID"],
        mainProcessId: json["MainProcessID"],
        subProcessId: json["SubProcessID"],
        appointmentDescription: json["AppointmentDescription"],
        appointmentDate: json["AppointmentDate"],
        appointmentTime: json["AppointmentTime"],
        appointmentBy: json["AppointmentBy"],
        recoveryDescription: json["RecoveryDescription"],
        recoveryDate: json["RecoveryDate"],
        recoveryTime: json["RecoveryTime"],
        recoveryBy: json["RecoveryBy"],
        recoveryTypeId: json["RecoveryTypeID"],
        exceptRepeatRepairFlag: json["ExceptRepeatRepairFlag"],
        remark: json["Remark"],
        projectId: json["ProjectID"],
        statusId: json["StatusID"],
        createDate: json["CreateDate"] == null ? null : DateTime.parse(json["CreateDate"]),
        createBy: json["CreateBy"],
        modifyDate: json["ModifyDate"] == null ? null : DateTime.parse(json["ModifyDate"]),
        modifyBy: json["ModifyBy"],
        appointmentDateTime: json["AppointmentDateTime"],
        mainProcessName: json["MainProcessName"],
        licenseNo: json["LicenseNO"],
        type: json["Type"],
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "ProblemID": problemId,
        "ProblemItem": problemItem,
        "VehicleID": vehicleId,
        "CaseID": caseId,
        "MainProcessID": mainProcessId,
        "SubProcessID": subProcessId,
        "AppointmentDescription": appointmentDescription,
        "AppointmentDate": appointmentDate,
        "AppointmentTime": appointmentTime,
        "AppointmentBy": appointmentBy,
        "RecoveryDescription": recoveryDescription,
        "RecoveryDate": recoveryDate,
        "RecoveryTime": recoveryTime,
        "RecoveryBy": recoveryBy,
        "RecoveryTypeID": recoveryTypeId,
        "ExceptRepeatRepairFlag": exceptRepeatRepairFlag,
        "Remark": remark,
        "ProjectID": projectId,
        "StatusID": statusId,
        "CreateDate": createDate?.toIso8601String(),
        "CreateBy": createBy,
        "ModifyDate": modifyDate?.toIso8601String(),
        "ModifyBy": modifyBy,
        "AppointmentDateTime": appointmentDateTime,
        "MainProcessName": mainProcessName,
        "LicenseNO": licenseNo,
        "Type": type,
        "Status": status,
    };
}

class TaskCase {
    int? caseId;
    int? taskId;
    String? beginDate;
    String? beginTime;
    String? beginDateTime;
    String? endDate;
    String? endTime;
    String? endDateTime;
    String? remark;
    int? userId;
    String? userName;
    int? employeeId;
    String? employee;
    String? callerName;
    String? customer;
    dynamic contact;
    String? caseCode;
    String? status;

    TaskCase({
        this.caseId,
        this.taskId,
        this.beginDate,
        this.beginTime,
        this.beginDateTime,
        this.endDate,
        this.endTime,
        this.endDateTime,
        this.remark,
        this.userId,
        this.userName,
        this.employeeId,
        this.employee,
        this.callerName,
        this.customer,
        this.contact,
        this.caseCode,
        this.status,
    });

    factory TaskCase.fromJson(Map<String, dynamic> json) => TaskCase(
        caseId: json["CaseID"],
        taskId: json["TaskID"],
        beginDate: json["BeginDate"],
        beginTime: json["BeginTime"],
        beginDateTime: json["BeginDateTime"],
        endDate: json["EndDate"],
        endTime: json["EndTime"],
        endDateTime: json["EndDateTime"],
        remark: json["Remark"],
        userId: json["UserID"],
        userName: json["UserName"],
        employeeId: json["EmployeeID"],
        employee: json["Employee"],
        callerName: json["CallerName"],
        customer: json["Customer"],
        contact: json["Contact"],
        caseCode: json["CaseCode"],
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "CaseID": caseId,
        "TaskID": taskId,
        "BeginDate": beginDate,
        "BeginTime": beginTime,
        "BeginDateTime": beginDateTime,
        "EndDate": endDate,
        "EndTime": endTime,
        "EndDateTime": endDateTime,
        "Remark": remark,
        "UserID": userId,
        "UserName": userName,
        "EmployeeID": employeeId,
        "Employee": employee,
        "CallerName": callerName,
        "Customer": customer,
        "Contact": contact,
        "CaseCode": caseCode,
        "Status": status,
    };
}

class Case {
    int? caseId;
    String? caseCode;
    String? remark;
    String? openDateTime;
    dynamic beginDate;
    dynamic beginTime;
    dynamic endDate;
    dynamic endTime;
    String? beginProgressDateTime;
    String? endProgressDateTime;
    int? customerId;
    String? callerName;
    String? customer;
    dynamic contact;
    String? status;
    String? communication;
    String? topic;
    int? modifyBy;
    String? modifyByName;
    int? typeId;
    String? modifyDepartment;
    int? createBy;
    String? createByName;
    String? alterDepartment;
    dynamic latitude;
    dynamic longitude;
    dynamic locationName;
    dynamic fieldServiceNo;
    String? closeDescription;

    Case({
        this.caseId,
        this.caseCode,
        this.remark,
        this.openDateTime,
        this.beginDate,
        this.beginTime,
        this.endDate,
        this.endTime,
        this.beginProgressDateTime,
        this.endProgressDateTime,
        this.customerId,
        this.callerName,
        this.customer,
        this.contact,
        this.status,
        this.communication,
        this.topic,
        this.modifyBy,
        this.modifyByName,
        this.typeId,
        this.modifyDepartment,
        this.createBy,
        this.createByName,
        this.alterDepartment,
        this.latitude,
        this.longitude,
        this.locationName,
        this.fieldServiceNo,
        this.closeDescription,
    });

    factory Case.fromJson(Map<String, dynamic> json) => Case(
        caseId: json["CaseID"],
        caseCode: json["CaseCode"],
        remark: json["Remark"],
        openDateTime: json["OpenDateTime"],
        beginDate: json["BeginDate"],
        beginTime: json["BeginTime"],
        endDate: json["EndDate"],
        endTime: json["EndTime"],
        beginProgressDateTime: json["BeginProgressDateTime"],
        endProgressDateTime: json["EndProgressDateTime"],
        customerId: json["CustomerID"],
        callerName: json["CallerName"],
        customer: json["Customer"],
        contact: json["Contact"],
        status: json["Status"],
        communication: json["Communication"],
        topic: json["Topic"],
        modifyBy: json["ModifyBy"],
        modifyByName: json["ModifyByName"],
        typeId: json["TypeID"],
        modifyDepartment: json["ModifyDepartment"],
        createBy: json["CreateBy"],
        createByName: json["CreateByName"],
        alterDepartment: json["ALTERDepartment"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        locationName: json["LocationName"],
        fieldServiceNo: json["FieldServiceNO"],
        closeDescription: json["CloseDescription"],
    );

    Map<String, dynamic> toJson() => {
        "CaseID": caseId,
        "CaseCode": caseCode,
        "Remark": remark,
        "OpenDateTime": openDateTime,
        "BeginDate": beginDate,
        "BeginTime": beginTime,
        "EndDate": endDate,
        "EndTime": endTime,
        "BeginProgressDateTime": beginProgressDateTime,
        "EndProgressDateTime": endProgressDateTime,
        "CustomerID": customerId,
        "CallerName": callerName,
        "Customer": customer,
        "Contact": contact,
        "Status": status,
        "Communication": communication,
        "Topic": topic,
        "ModifyBy": modifyBy,
        "ModifyByName": modifyByName,
        "TypeID": typeId,
        "ModifyDepartment": modifyDepartment,
        "CreateBy": createBy,
        "CreateByName": createByName,
        "ALTERDepartment": alterDepartment,
        "Latitude": latitude,
        "Longitude": longitude,
        "LocationName": locationName,
        "FieldServiceNO": fieldServiceNo,
        "CloseDescription": closeDescription,
    };
}
