import 'package:flutter/material.dart';
import 'package:flutter_mvvm/res/components/round_button.dart';
import 'package:flutter_mvvm/utils/utils.dart';
import 'package:flutter_mvvm/view_model/createsession_viewmodel.dart';
import 'package:provider/provider.dart';

import '../res/colors/app_colors.dart';
import '../res/components/Constants.dart';
import '../utils/gradient_app_bar.dart';

class CreateSession extends StatefulWidget {
  final int candidateId;

  const CreateSession({required this.candidateId, super.key});

  @override
  State<CreateSession> createState() => _CreateSessionState();
}

class _CreateSessionState extends State<CreateSession> {
  final _sessionFormKey = GlobalKey<FormState>();
  String _duration = '';
  String _numberOfQuestions = '';
  String _date = '';
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final createSessionViewModel = Provider.of<CreateSessionViewModel>(context);
    Utils.printLogs('CandidateId: ${widget.candidateId}');
    return Scaffold(
      appBar: GradientAppBar(
        title: AppConstants.createSession,
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.grey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: createSessionViewModel.isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: Form(
                key: _sessionFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                        'Note: Please enter duration in minutes i.e. 15,30,45'),
                    const SizedBox(
                      height: 4.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: AppColors.borderColor)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: AppColors.borderColor)),
                          labelText: 'Duration*'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter duration';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _duration = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: AppColors.borderColor)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: AppColors.borderColor)),
                          labelText: 'Number of Questions*'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter number of questions';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _numberOfQuestions = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: AppColors.borderColor)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: AppColors.borderColor)),
                          labelText: 'Select Date*'),
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter date';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _date = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    RoundedButton(
                      title: 'Create Session',
                      onPress: () {
                        if (_sessionFormKey.currentState?.validate() ?? false) {
                          _sessionFormKey.currentState?.save();
                          Map<String, String> data = {
                            'candidateId': widget.candidateId.toString(),
                            'duration': _duration,
                            'numberOfQuestions': _numberOfQuestions,
                            'date':
                                _selectedDate!.millisecondsSinceEpoch.toString()
                          };
                          Utils.printLogs(
                              'CreateSession ${'Duration: $_duration No of questions: $_numberOfQuestions Selected Date: ${_selectedDate!.millisecondsSinceEpoch}'}');
                          createSessionViewModel.createSessionWithQueryParam(
                              data, context);
                        }
                      },
                    ),
                    if (createSessionViewModel.isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
        _date = _selectedDate!.millisecondsSinceEpoch.toString();
        Utils.printLogs('Selected Date: $_selectedDate');
        Utils.printLogs('Selected Date in millis: $_date');
      });
    }
  }
}
