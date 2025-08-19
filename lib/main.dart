import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttimer/providers/alarm_provider.dart';
import 'package:smarttimer/providers/stopwatch_provider.dart';
import 'package:smarttimer/providers/timer_provider.dart';
import 'package:smarttimer/screens/dashboard_screen.dart';
import 'screens/timer_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimerProvider()),
        ChangeNotifierProvider(create: (context) => StopwatchProvider()),
        ChangeNotifierProvider(create: (context) => AlarmProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Timer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}

