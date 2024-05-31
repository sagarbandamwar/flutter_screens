import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../repository/create_session_repository.dart';
import '../utils/utils.dart';

class CreateSessionViewModel with ChangeNotifier {
  final _myRepo = CreateSessionRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  Future<void> createSessionWithQueryParam(
      Map<String, String> data, BuildContext context) async {
    setLoading(true);
    final uri = Uri.https(
        'select-sense-apis.azurewebsites.net', 'session/createSession', data);

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle successful response
        Utils.printLogs('Response->${response.body.toString()}');
        Utils.printLogs('Session created successfully');
        Utils.showFlushBarSuccessMessage('Session created successfully', context);
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
        setLoading(false);
      } else {
        Utils.showFlushBarErrorMessage(response.toString(), context);
        // Handle error response
        Utils.printLogs('Failed to create session: ${response.body.toString()}');
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
        setLoading(false);
      }
    } catch (e) {
      // Handle network or other errors
      Utils.printLogs('Error: $e');
      Utils.showFlushBarErrorMessage("Failed to create session", context);
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
      setLoading(false);
    }
  }

  Future<void> createSession(dynamic data, BuildContext context) async {
    _myRepo.createSession(data).then((value) {
      if (kDebugMode) {
        print(value.toString());
        Utils.showFlushBarErrorMessage(value.toString(), context);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        Utils.printLogs('Inside On error');
        Utils.printLogs('Create Session ${error.toString()}');
        Utils.showFlushBarErrorMessage(error.toString(), context);
      }
    });
  }
}
