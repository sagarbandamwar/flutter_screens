import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../res/components/app_url.dart';

class SessionEvaluationRepository{
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> selectOrRejectCandidate(String candidateId, bool isSelected) async {
    try {
      var data = {
        "isSelected":isSelected,
        "candidateId":candidateId
      };
      var response = await _apiServices.getPostApiResponse(AppUrls.selectCandidate, data);

      return response;
    } catch (e) {
      print('$e');
      rethrow;
    }
  }

}