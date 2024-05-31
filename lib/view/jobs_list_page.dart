import 'package:flutter/material.dart';
import 'package:flutter_mvvm/data/response/Status.dart';
import 'package:flutter_mvvm/res/components/round_button.dart';
import 'package:flutter_mvvm/utils/routes/routes_names.dart';
import 'package:provider/provider.dart';
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
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
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
                              title: 'Create Job',
                              onPress: () {
                                Navigator.pushNamed(
                                    context, RoutesNames.createJob);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: value.jobsList.data?.jobsList?.length ?? 0,
                        itemBuilder: (context, index) {
                          var job = value.jobsList.data?.jobsList?[index];
                          return  JobCard(
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

  JobCard({
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
      margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.jobTitle,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            // Wrap(
            //   spacing: 8.0,
            //   children: tags.map((tag) => Chip(label: Text(tag))).toList(),
            // ),
            SizedBox(height: 8.0),
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
                child: Text("Show more",textAlign: TextAlign.end),
              ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.work_outline, size: 20.0),
                SizedBox(width: 4.0),
                Text(widget.jobType),
                SizedBox(width: 16.0),
                Icon(Icons.location_on_outlined, size: 20.0),
                SizedBox(width: 4.0),
                Text("India"),
                Spacer(),
                // Icon(Icons.person_outline, size: 20.0),
                // SizedBox(width: 4.0),
                // Text('$appliedCount applied'),
                // SizedBox(width: 16.0),
                Icon(Icons.access_time_outlined, size: 20.0),
                SizedBox(width: 4.0),
                Text('${widget.daysLeft} days left'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}