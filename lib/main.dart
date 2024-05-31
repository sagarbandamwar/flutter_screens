import 'package:flutter/material.dart';
import 'package:flutter_mvvm/utils/routes/routes.dart';
import 'package:flutter_mvvm/utils/routes/routes_names.dart';
import 'package:flutter_mvvm/view_model/auth_viewmodel.dart';
import 'package:flutter_mvvm/view_model/candidate_viewmodel.dart';
import 'package:flutter_mvvm/view_model/createsession_viewmodel.dart';
import 'package:flutter_mvvm/view_model/jobs_viewmodel.dart';
import 'package:flutter_mvvm/view_model/preScreeningViewModel.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => JobsViewModel()),
        ChangeNotifierProvider(create: (_) => CandidateViewModel()),
        ChangeNotifierProvider(create: (_) => CreateSessionViewModel()),
        ChangeNotifierProvider(create: (_) => PreScreeningViewModel()),
      ],
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        title: 'Admin',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Roboto-Bold',
        ),
        initialRoute: RoutesNames.candidateList,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}