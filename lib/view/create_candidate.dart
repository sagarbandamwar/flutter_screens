import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mvvm/model/JobNameList.dart';
import 'package:flutter_mvvm/res/colors/app_colors.dart';
import 'package:flutter_mvvm/res/components/round_button.dart';
import 'package:flutter_mvvm/view_model/candidate_viewmodel.dart';
import 'package:provider/provider.dart';

import '../res/components/Constants.dart';
import '../utils/GradientAppBar.dart';
import '../utils/utils.dart';

class CandidatePage extends StatefulWidget {
  const CandidatePage({super.key});

  @override
  _CandidatePageState createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {
  final _candidateFormKey = GlobalKey<FormState>();
  String _name = '';
  String _contact = '';
  String _email = '';
  String _jobName = '';
  int _jobId = 0;

  String? selectedFilePath;
  bool isLoading = false;
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedFile;
  File? fileToDisplay;

  List<JobNameList> jobNames = [];

  @override
  void initState() {
    super.initState();
    final candidateViewModel =
        Provider.of<CandidateViewModel>(context, listen: false);
    candidateViewModel.getJobs(context);
  }

  Future<void> pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });

      result = await FilePicker.platform
          .pickFiles(type: FileType.any, allowMultiple: false);
      if (result != null) {
        _fileName = result!.files.first.name;
        pickedFile = result!.files.first;
        selectedFilePath = result!.files.first.path;
        // fileToDisplay = File(pickedFile!.path.toString());
        Utils.printLogs('File Name $_fileName');
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Utils.printLogs('Error:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final candidateViewModel = Provider.of<CandidateViewModel>(context);
    final jobsResponse = candidateViewModel.jobsList;
    return Scaffold(
      appBar: GradientAppBar(
        title: AppConstants.candidateForm,
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 100.0),
        child: Form(
          key: _candidateFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: AppColors.borderColor)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: AppColors.borderColor)),
                    labelText: 'Candidate Name*'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: AppColors.borderColor)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: AppColors.borderColor)),
                    labelText: 'Contact Number*'),
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter valid contact number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contact = value!;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: AppColors.borderColor)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: AppColors.borderColor)),
                    labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter valid Email Id';
                  }
                  if (!_isValidEmail(value!)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  //_showJobNameDropdown(context);
                  _showJobNameDropdown(context, jobsResponse.data!.jobsList!);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: AppColors.borderColor)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: AppColors.borderColor)),
                      labelText: 'Job Name',
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    controller: TextEditingController(text: _jobName),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please Select Job from Drop down menu';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _jobName = value!;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () async {
                  await pickFile();
                  setState(() {
                    isLoading = false;
                  });
                  if (pickedFile != null) {
                    SizedBox(
                      height: 300,
                      width: 400,
                      child: Text(
                        'picked file: $pickedFile',
                        style: const TextStyle(
                          fontFamily: 'sourcesanspro_bold',
                        ),
                      ),
                    );
                  }
                },
                child: isLoading
                    ? const CircularProgressIndicator() // show loading indicator
                    : const Text('Upload Resume'),
              ),
              const SizedBox(height: 20.0),
              _fileName != null
                  ? Text(
                      'File Name: $_fileName',
                      style: const TextStyle(fontSize: 16.0),
                    )
                  : Container(),
              const SizedBox(height: 20.0),
              RoundedButton(
                title: "Submit Candidate",
                onPress: () {
                  if (_candidateFormKey.currentState?.validate() ?? false) {
                    _candidateFormKey.currentState?.save();
                    // Do something with the form data, like submit it
                    Utils.printLogs('fullName: $_name');
                    Utils.printLogs('JobName: $_jobName');
                    Utils.printLogs('Email: $_email');
                    Utils.printLogs('Contact: $_contact');
                    Utils.printLogs('Job Id: $_jobId');
                    Map<String, String> data = {
                      'jobId': _jobId.toString(),
                      'fullName': _name,
                      'email': _email
                    };
                    candidateViewModel.createCandidate(
                        data, context, pickedFile);
                    Utils.showFlushBarSuccessMessage(
                        'Candidate created successfully!', context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    // Regular expression for validating email addresses
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _showJobNameDropdown(BuildContext context, List<Jobs> jobNames) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Job Name'),
          content: SingleChildScrollView(
            child: Column(
              children: jobNames.map((job) {
                return ListTile(
                  title: Text(job.jobName as String),
                  onTap: () {
                    setState(() {
                      _jobName = job.jobName!;
                      _jobId = job.jobId!;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
