import 'package:file_picker/file_picker.dart';
import 'package:flutter_mvvm/model/candidate_list_model.dart';
import 'package:flutter_mvvm/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../model/JobNameList.dart';
import '../res/components/app_url.dart';

class CandidateRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> createCandidate(dynamic data, PlatformFile? filePath) async {
    try {
      var uri =
          Uri.parse('https://select-sense-apis.azurewebsites.net/candidate/');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile.fromBytes('resume', filePath!.bytes!,
          filename: filePath.name));
      request.fields.addAll(data);
      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.printLogs('File uploaded successfully');
      } else {
        Utils.printLogs(
            'File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      Utils.printLogs('$e');
      rethrow;
    }
  }

  Future<List<Candidate>> getCandidatesList() async {
    try {
      dynamic response =
          await _apiServices.getGetApiResponse(AppUrls.getCandidates);
      // Assuming response is already a List<dynamic>
      List<dynamic> responseList = response as List<dynamic>;
      List<Candidate> candidates =
          responseList.map((item) => Candidate.fromJson(item)).toList();
      Utils.printLogs("candidate List ${candidates.toString()}");
      return candidates;
    } catch (e) {
      Utils.printLogs('$e');
      rethrow;
    }
  }

  Future<List<Jobs>> getJobs() async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrls.getJobs);
      List<dynamic> responseList = response as List<dynamic>;
      List<Jobs> jobs =
          responseList.map((item) => Jobs.fromJson(item)).toList();
      Utils.printLogs("Jobs List $jobs");
      return jobs;
    } catch (e) {
      Utils.printLogs('$e');
      rethrow;
    }
  }
}
