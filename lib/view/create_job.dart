import 'package:flutter/material.dart';
import 'package:flutter_mvvm/res/components/round_button.dart';
import 'package:flutter_mvvm/utils/routes/routes_names.dart';
import 'package:flutter_mvvm/view_model/jobs_viewmodel.dart';
import 'package:provider/provider.dart';

import '../res/colors/app_colors.dart';
import '../res/components/Constants.dart';
import '../utils/gradient_app_bar.dart';
import '../utils/utils.dart';

class CreateJob extends StatefulWidget {
  const CreateJob({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<CreateJob> createState() => _FormExampleState();
}

class _FormExampleState extends State<CreateJob> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _location = '';
  String _description = '';
  String? _nameError;
  bool isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesNames.candidateList,
          (Route<dynamic> route) => false,
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final jobsViewModel = Provider.of<JobsViewModel>(context);
    return WillPopScope(
      onWillPop:_onWillPop,
      child: Scaffold(
        appBar: GradientAppBar(
          title: AppConstants.createNewJob,
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.grey],
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
                  children: <Widget>[
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: AppColors.borderColor)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: AppColors.borderColor)),
                        labelText: 'Job Title*',
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter job title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showJobLocationDropdown(context);
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
                            labelText: 'Location Type*',
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          controller: TextEditingController(text: _location),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              Utils.showFlushBarErrorMessage(
                                  'Please enter location type', context);
                              return 'Please enter type of location';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _location = value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 7,
                          child: TextFormField(
                            controller: _descriptionController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: AppColors.borderColor)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: AppColors.borderColor)),
                              labelText: 'Description',
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _description = value!;
                            },
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        if (_description.isEmpty)
                          Expanded(
                            flex: 3,
                            child: RoundedButton(
                              color: AppColors.teal,
                              // set data from next screen
                              onPress: () async {
                                final result = await Navigator.pushNamed(
                                    context, RoutesNames.generateJobDesc);
                                if (result != null) {
                                  final data = result as Map<String, String>;
                                  setState(() {
                                    _nameController.text =
                                        data['technicalRequirements']!;
                                    _descriptionController.text =
                                        data['message']!;
                                  });
                                }
                              },
                              title: 'Generate Description with AI',
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedButton(
                          title: 'Create Job',
                          loading: true,
                          onPress: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              _formKey.currentState?.save();
                              // Do something with the form data, like submit it
                              Utils.printLogs('Name: $_name');
                              Utils.printLogs('Location: $_location');
                              Utils.printLogs('Description: $_description');
                              setState(() {
                                isLoading = true;
                              });
                              Map data = {
                                'jobName': _name,
                                'jobDesc': _description,
                                'jobType': _location
                              };
                              Utils.printLogs('data:$data');
                              await jobsViewModel.createJob(data, context);
                              jobsViewModel.onJobCreated = () {
                                setState(() {
                                  isLoading = false;
                                });
                              };
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  void _showJobLocationDropdown(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Location type'),
          content: SingleChildScrollView(
            child: Column(
              children: _locationTypes.map((locationType) {
                return ListTile(
                  title: Text(locationType),
                  onTap: () {
                    setState(() {
                      _location = locationType;
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

  final List<String> _locationTypes = ['On-site', 'Hybrid', 'Remote'];
}
