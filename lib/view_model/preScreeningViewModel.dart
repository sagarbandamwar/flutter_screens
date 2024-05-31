import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_mvvm/model/questionModel.dart';
import 'package:http/http.dart' as http;

class PreScreeningViewModel extends ChangeNotifier {
  List<QandAScoring> qaScoring = [];
  List<SkillsAssessment> skillsAssessment = [];
  Evaluation? assessment;



  Future<void> submitAnswers(Map<String, String> data) async {
    var uri =
        Uri.https('select-sense-apis.azurewebsites.net', '/session/getEvaluation',data);

    try {
      final response = await http.get(uri,
          headers: {"Content-Type": "application/json"},
          );

     /* body: jsonEncode({
        'questions': answers.map((answer) => answer.toJson()).toList(),
      })*/

      if (response.statusCode == 200 || response.statusCode == 201) {
        // API call was successful, handle the response data here
        print("SUCCESS:${response.body}");
        Map<String, dynamic> jsonMap = json.decode(response.body);
        assessment = AssessmentModel.fromJson(jsonMap).evaluation;

        // qaScoring = assessment.qandAScoring;
        // skillsAssessment = assessment.skillsAssessment;
        notifyListeners();
      } else {
        // API call failed, handle the error
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      // Exception occurred during the API call
      print('Error: $e');
    }
  }

  Future<void> downloadReport(String candidateId) async {
    var uri =
        Uri.https('select-sense-apis.azurewebsites.net', '/session/getEvaluation/report',{'candidateId':candidateId});
    try {
      final response = await http.get(uri,
          headers: {"Content-Type": "application/json"},
          );

     /* body: jsonEncode({
        'questions': answers.map((answer) => answer.toJson()).toList(),
      })*/

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bytes = response.bodyBytes;
        final blob = html.Blob([bytes], 'application/pdf');

        // Create a link element
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', '$candidateId.pdf')
          ..click();
        html.Url.revokeObjectUrl(url);
        // API call was successful, handle the response data here
        //print("SUCCESS:${response.body}");
       /* Map<String, dynamic> jsonMap = json.decode(response.body);
        assessment = AssessmentModel.fromJson(jsonMap).evaluation;*/

        // qaScoring = assessment.qandAScoring;
        // skillsAssessment = assessment.skillsAssessment;
        notifyListeners();
      } else {
        // API call failed, handle the error
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      // Exception occurred during the API call
      print('Error: $e');
    }
  }
}
