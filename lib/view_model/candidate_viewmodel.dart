import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/data/response/api_response.dart';
import 'package:flutter_mvvm/repository/candidate_repository.dart';

import '../model/candidate_list_model.dart';
import '../utils/utils.dart';

class CandidateViewModel with ChangeNotifier {
  final _myRepo = CandidateRepository();
  ApiResponse<CandidateListModel> candidateList = ApiResponse.loading();

  setMovieList(ApiResponse<CandidateListModel> response) {
    candidateList = response;
    notifyListeners();
  }

  // Create new candidate
  Future<void> createCandidate(dynamic data, BuildContext context,PlatformFile? filePath) async {
    _myRepo.createCandidate(data,filePath).then((value) {
      Utils.printLogs(value.toString());
      Utils.printLogs('Inside On success');
      Utils.showFlushBarErrorMessage(value.toString(), context);
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
      //Navigator.pushNamed(context, RoutesNames.home);
    }).onError((error, stackTrace) {
      print('Inside On error');
      Utils.showFlushBarErrorMessage('Failed to create candidate', context);
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
      Utils.printLogs(error.toString());
    });
  }

// Get list of all registered candidates
  Future<void> getCandidatesList(BuildContext context) async {
    try {
      List<Candidate> candidates = await _myRepo.getCandidatesList();
      candidateList =
          ApiResponse.completed(CandidateListModel(candidateList: candidates));
      notifyListeners();
      Utils.printLogs('Inside On success');
      print(candidateList.data?.candidateList.toString());
    } catch (error) {
      candidateList = ApiResponse.error(error.toString());
      notifyListeners();
    }
  }
}
