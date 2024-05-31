import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mvvm/res/components/Constants.dart';
import 'package:flutter_mvvm/utils/gradient_app_bar.dart';
import 'package:provider/provider.dart';

import '../res/colors/app_colors.dart';
import '../res/components/round_button.dart';
import '../utils/utils.dart';
import '../view_model/jobs_viewmodel.dart';

class JobDescriptionPage extends StatefulWidget {
  const JobDescriptionPage({super.key});

  @override
  State<JobDescriptionPage> createState() => _JobDescriptionPageState();
}

class _JobDescriptionPageState extends State<JobDescriptionPage> {
  final _formKey = GlobalKey<FormState>();
  String _positionName = '';
  String _roles = '';
  String _experience = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final jobsViewModel = Provider.of<JobsViewModel>(context);
    return Scaffold(
      appBar: GradientAppBar(
        title: AppConstants.jobDescription,
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  TextFormField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: AppColors.borderColor)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: AppColors.borderColor)),
                        labelText: 'Technical Requirements*'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter technical requirements';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _positionName = value!;
                    },
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                      style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          fontSize: 12.0,
                          color: AppColors.grayColor),
                      'Hint:- e.g., Android SDK: Expertise in core components (Activities, Services, etc.), Kotlin/Java: Strong programming skills, UI/UX Design: Experience with Material Design'),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: AppColors.borderColor)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: AppColors.borderColor)),
                        labelText: 'Star Performer Expectations*'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter star performer expectations';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _roles = value!;
                    },
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                      style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          fontSize: 12.0,
                          color: AppColors.grayColor),
                      'Hint- e.g., Analytical Skills: Strong analytical skills, Communication: Excellent verbal and written skills, Teamwork: Collaborative team player'),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: AppColors.borderColor)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: AppColors.borderColor)),
                      labelText: 'Required Experience (in years)*',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter experience in years';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _experience = value!;
                    },
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                    'Hint- e.g., 10',
                    style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        fontSize: 12.0,
                        color: AppColors.grayColor),
                  ),
                  const SizedBox(height: 20.0),
                  RoundedButton(
                    title: "Generate Job Description",
                    onPress: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        Utils.printLogs('Position Name: $_positionName');
                        Utils.printLogs('Roles: $_roles');
                        Utils.printLogs('Experience: $_experience');

                        Map data = {
                          'technicalRequirements': _positionName,
                          'starPerformerExpectations': _roles,
                          'experience': _experience.toString()
                        };
                        Utils.printLogs('Generate Job desc clicked ->');
                        setState(() {
                          isLoading = true;
                        });
                        final result = await jobsViewModel
                            .generateJobDescription(data, context);
                        if (result != null) {
                          Navigator.pop(context, result);
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          if (isLoading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
