class RestDataSource {
  String baseAPI = 'http://203.150.53.11:9001/CSCPlusAPIdev/api';

  String GetAllCasebyId({required int CaseID}){
    return '$baseAPI/Case/GetAllCaseById?CaseID=$CaseID';
  }

  String PostMultiFiles() {
    return '$baseAPI/FileUpload/PostMultiFiles';
  }

  String GetListFile({required int docId}) {
    return '${baseAPI}FileUpload/GetListFile?docId=$docId';
  }
}
