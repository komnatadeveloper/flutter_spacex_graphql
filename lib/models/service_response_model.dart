

class ServiceResponseModel {
  final dynamic apiResponse;
  final List<String>? errorList;
  ServiceResponseModel({
    this.errorList ,
    this.apiResponse
  });
}