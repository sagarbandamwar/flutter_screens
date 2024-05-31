import 'package:flutter/material.dart';
import 'package:flutter_mvvm/utils/routes/routes_names.dart';
import 'package:flutter_mvvm/view/candidate_list_page.dart';
import 'package:flutter_mvvm/view/create_session.dart';
import 'package:flutter_mvvm/view/eveluation_screen.dart';
import 'package:flutter_mvvm/view/home_screen.dart';
import 'package:flutter_mvvm/view/job_desc_page.dart';
import 'package:flutter_mvvm/view/login_scree.dart';

import '../../view/create_candidate.dart';
import '../../view/create_job.dart';
import '../../view/jobs_list_page.dart';

// Manage routing through Route class
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen());
      case RoutesNames.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case RoutesNames.createJob:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CreateJob(
                  title: 'create job',
                ));
      case RoutesNames.createCandidate:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CandidatePage());
      case RoutesNames.candidateList:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CandidateListPage());
      case RoutesNames.jobsList:
        return MaterialPageRoute(
            builder: (BuildContext context) => const JobListPage());
      case RoutesNames.createSession:
        final candidateId = settings.arguments as int;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                CreateSession(candidateId: candidateId));
      /*case RoutesNames.assessmentReviewScreen:
        final candidateId = settings.arguments as int;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                AssessmentReviewScreen(candidateId: candidateId,
                  candidateName: candidateName,));*/
      case RoutesNames.generateJobDesc:
        return MaterialPageRoute(
            builder: (BuildContext context) => const JobDescriptionPage());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No Route defined'),
            ),
          );
        });
    }
  }
}
