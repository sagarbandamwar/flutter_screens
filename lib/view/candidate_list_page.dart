import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mvvm/data/response/Status.dart';
import 'package:flutter_mvvm/res/colors/app_colors.dart';
import 'package:flutter_mvvm/res/components/Constants.dart';
import 'package:flutter_mvvm/res/components/round_button.dart';
import 'package:flutter_mvvm/utils/gradient_app_bar.dart';
import 'package:flutter_mvvm/utils/routes/routes_names.dart';
import 'package:flutter_mvvm/view_model/candidate_viewmodel.dart';
import 'package:provider/provider.dart';

import 'create_candidate.dart';
import 'eveluation_screen.dart';

class CandidateListPage extends StatefulWidget {
  const CandidateListPage({super.key});

  @override
  State<CandidateListPage> createState() => _CandidateListPageState();
}

class _CandidateListPageState extends State<CandidateListPage> with RouteAware {
  CandidateViewModel candidateViewModel = CandidateViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      candidateViewModel.getCandidatesList(context);
    });
  }

  @override
  void didPush() {
    // Called when the current route has been pushed
    candidateViewModel.getCandidatesList(context);
  }

  @override
  void didPopNext() {
    // Called when the top route has been popped and the current route shows up again
    candidateViewModel.getCandidatesList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: AppConstants.candidateList,
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.grey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: ChangeNotifierProvider<CandidateViewModel>(
        create: (BuildContext context) => candidateViewModel,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column for buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150.0,
                    child: RoundedButton(
                      color: AppColors.green,
                      title: AppConstants.createCandidate,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider<CandidateViewModel>(
                              create: (_) => CandidateViewModel()
                                ..onCandidateCreated = () {
                                  // Refresh the candidate list after a candidate is created
                                  setState(() {
                                    candidateViewModel
                                        .getCandidatesList(context);
                                  });
                                },
                              child: const CandidatePage(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  SizedBox(
                    width: 150.0,
                    child: RoundedButton(
                      color: AppColors.orange,
                      title: AppConstants.createJob,
                      onPress: () {
                        Navigator.pushNamed(context, RoutesNames.createJob);
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  SizedBox(
                    width: 150.0,
                    child: RoundedButton(
                      color: AppColors.teal,
                      title: AppConstants.jobList,
                      onPress: () {
                        Navigator.pushNamed(context, RoutesNames.jobsList);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: Consumer<CandidateViewModel>(
                  builder: (context, value, child) {
                    switch (value.candidateList.status) {
                      case Status.LOADING:
                        return const Center(child: CircularProgressIndicator());
                      case Status.ERROR:
                        return Center(
                            child:
                                Text(value.candidateList.message.toString()));
                      case Status.COMPLETED:
                        var candidates = value.candidateList.data?.candidateList?.reversed.toList()?? [];
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 250.0, vertical: 6.0),
                          itemCount: candidates.length ?? 0,
                          itemBuilder: (context, index) {
                            var candidate = candidates[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 6.0),
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1.0),
                                ),
                                color: AppColors.white,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(8.0),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                      getRandomAvatar(), // Randomly select an avatar image
                                    ),
                                  ),
                                  title: Text(
                                    '${candidate?.fullName?.toTitleCase()}',
                                    style: const TextStyle(
                                      fontFamily: 'Roboto-Regular',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.orange,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          const Icon(Icons.insert_drive_file,
                                              size: 16.0), // Add file icon here
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'File Name:-> ${candidate?.fileName}',
                                            style: const TextStyle(
                                              fontFamily: 'Roboto-Regular',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          const Icon(Icons.settings,
                                              size: 16.0),
                                          // Add job icon here
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'Job Name:-> ${candidate?.jobName ?? 'No Job Name'}',
                                            style: const TextStyle(
                                              fontFamily: 'Roboto-Regular',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.access_time_filled_sharp,
                                              size: 16.0),
                                          // Add status icon here
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'Status:-> ${formatStatus(candidate?.status?.toString())}',
                                            style: TextStyle(
                                              fontFamily: 'Roboto-Regular',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              color: candidate?.status ==
                                                      AppConstants
                                                          .CANDIDATE_SELECTED
                                                  ? Colors.green
                                                  : candidate?.status ==
                                                          AppConstants
                                                              .CANDIDATE_REJECTED
                                                      ? Colors.red
                                                      : Colors
                                                          .black, // Default color
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          if (candidate?.status ==
                                              AppConstants.SESSION_CREATED)
                                            ElevatedButton(
                                              onPressed: () {
                                                // Navigate to create session
                                                Navigator.pushNamed(
                                                        context,
                                                        RoutesNames
                                                            .createSession,
                                                        arguments: candidate!
                                                            .candidateId)
                                                    .then((_) {
                                                  onSessionSuccess(); // Refresh the list after session creation
                                                });
                                              },
                                              child:
                                                  const Text('Create Session'),
                                            ),
                                          if (candidate?.status ==
                                              AppConstants.SESSION_CREATED)
                                            const SizedBox(width: 8.0),
                                          // Spacing between buttons
                                          if (candidate?.status ==
                                              AppConstants.EVALUATION_COMPLETED)
                                            ElevatedButton(
                                              onPressed: () {
                                                // Navigate to view evaluation
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        AssessmentReviewScreen(
                                                      candidateId: candidate!
                                                          .candidateId,
                                                      candidateName: candidate
                                                          .fullName
                                                          ?.toTitleCase(),
                                                      jobName: candidate.jobName
                                                          ?.toTitleCase(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child:
                                                  const Text('View Evaluation'),
                                            ),
                                          const SizedBox(width: 16.0),
                                        ],
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // Handle tap if needed, e.g., navigate to a detailed view
                                    /*Navigator.pushNamed(
                                        context, RoutesNames.createSession,
                                        arguments: candidate!.candidateId);*/
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      default:
                        return Container(); // or some default widget
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> avatarImages = [
    'assets/images/astronaut_7230232.png',
    'assets/images/avatar_13848299.png',
    'assets/images/emoji_10307988.png',
    'assets/images/eskimo_627106.png',
    'assets/images/jester_1803805.png',
    'assets/images/man_11918402.png',
    'assets/images/profile_11045293.png',
  ];

  String getRandomAvatar() {
    final random = Random();
    int index = random.nextInt(avatarImages.length);
    return avatarImages[index];
  }

  String formatStatus(String? status) {
    switch (status) {
      case 'sessionGenerated':
        return 'Session Generated';
      case 'sessionInitiated':
        return 'Session Initiated';
      case 'evaluationComplete':
        return 'Evaluation Completed';
      default:
        return status ?? 'Unknown Status';
    }
  }

  void onSessionSuccess() {
    candidateViewModel.getCandidatesList(context);
  }
}
