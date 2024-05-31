import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/data/response/api_response.dart';
import 'package:flutter_mvvm/model/JobNameList.dart';
import 'package:flutter_mvvm/repository/candidate_repository.dart';

import '../model/candidate_list_model.dart';
import '../utils/utils.dart';

class CandidateViewModel with ChangeNotifier {
  final _myRepo = CandidateRepository();
  ApiResponse<CandidateListModel> candidateList = ApiResponse.loading();
  ApiResponse<JobNameList> jobsList = ApiResponse.loading();
  // Call back function
  void Function()? onCandidateCreated;

  setCandidateListList(ApiResponse<CandidateListModel> response) {
    candidateList = response;
    notifyListeners();
  }

  setJobsList(ApiResponse<JobNameList> response) {
    jobsList = response;
    notifyListeners();
  }

  // Create new candidate
  Future<void> createCandidate(
      dynamic data, BuildContext context, PlatformFile? filePath) async {
    _myRepo.createCandidate(data, filePath).then((value) {
      Utils.printLogs('Inside On success');
      Utils.printLogs(value.toString());
      Utils.showFlushBarSuccessMessage(
          'Candidate created successfully!', context);
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
        onCandidateCreated?.call();
      });
      //Navigator.pushNamed(context, RoutesNames.home);
    }).onError((error, stackTrace) {
      Utils.printLogs('Inside On error');
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
      Utils.printLogs(candidateList.data!.candidateList.toString());
    } catch (error) {
      candidateList = ApiResponse.error(error.toString());
      notifyListeners();
    }
  }

  ///  To get the list of jobs name and id
  ///

  Future<void> getJobs(BuildContext context) async {
    try {
      List<Jobs> jobs = await _myRepo.getJobs();
      Utils.printLogs('Inside On get jobs');
      Utils.printLogs(jobs.toString());
      notifyListeners();
      //Utils.showFlushBarErrorMessage(jobs.toString(), context);
      setJobsList(ApiResponse.completed(JobNameList(jobsList: jobs)));
      //Navigator.pushNamed(context, RoutesNames.home);
    } catch (error) {
      Utils.printLogs('Inside On error get jobs');
      setJobsList(ApiResponse.error(error.toString()));
      Utils.showFlushBarErrorMessage(error.toString(), context);
      Utils.printLogs(error.toString());
    }
  }
}
