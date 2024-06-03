import 'package:flutter/material.dart';
import 'package:flutter_mvvm/data/response/Status.dart';
import 'package:flutter_mvvm/res/components/round_button.dart';
import 'package:flutter_mvvm/utils/routes/routes_names.dart';
import 'package:provider/provider.dart';
import '../res/colors/app_colors.dart';
import '../res/components/Constants.dart';
import '../utils/gradient_app_bar.dart';
import '../view_model/jobs_viewmodel.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({super.key});

  @override
  State<JobListPage> createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  late JobsViewModel jobsViewModel;

  @override
  void initState() {
    super.initState();
    jobsViewModel = JobsViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jobsViewModel.getJobs(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: AppConstants.jobList,
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.grey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: ChangeNotifierProvider<JobsViewModel>(
        create: (BuildContext context) => jobsViewModel,
        child: Consumer<JobsViewModel>(
          builder: (context, value, child) {
            switch (value.jobsList.status) {
              case Status.LOADING:
                return const Center(child: CircularProgressIndicator());
              case Status.ERROR:
                return Center(child: Text(value.jobsList.message.toString()));
              case Status.COMPLETED:
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150.0,
                            child: RoundedButton(
                              title: 'Create Candidate',
                              onPress: () {
                                Navigator.pushNamed(
                                    context, RoutesNames.createCandidate);
                              },
                            ),
                          ),
                          const SizedBox(width: 25.0),
                          SizedBox(
                            width: 150.0,
                            child: RoundedButton(
                              color: AppColors.orange,
                              title: 'Create Job',
                              onPress: () {
                                Navigator.pushNamed(
                                    context, RoutesNames.createJob);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: value.jobsList.data?.jobsList?.length ?? 0,
                          itemBuilder: (context, index) {
                            var job = value.jobsList.data?.jobsList?[index];
                            return JobCard(
                              jobTitle: job?.jobName ?? "",
                              jobType: job?.jobType ?? "",
                              description: job?.jobDesc ?? "",
                              appliedCount: 74,
                              daysLeft: 30,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              default:
                return Container(); // or some default widget
            }
          },
        ),
      ),
    );
  }
}

class JobCard extends StatefulWidget {
  final String jobTitle;
  final String jobType;
  final String description;
  final int appliedCount;
  final int daysLeft;

  const JobCard({
    super.key,
    required this.jobTitle,
    required this.jobType,
    required this.description,
    required this.appliedCount,
    required this.daysLeft,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.jobTitle,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.description,
              maxLines: _expanded ? 100 : 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (!_expanded)
              TextButton(
                onPressed: () {
                  setState(() {
                    _expanded = true;
                  });
                },
                child: const Text("Show more", textAlign: TextAlign.end),
              ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.work_outline, size: 20.0),
                const SizedBox(width: 4.0),
                Text(widget.jobType),
                const SizedBox(width: 16.0),
                const Icon(Icons.location_on_outlined, size: 20.0),
                const SizedBox(width: 4.0),
                const Text("India"),
                const Spacer(),
                const Icon(Icons.access_time_outlined, size: 20.0),
                const SizedBox(width: 4.0),
                Text('${widget.daysLeft} days left'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
