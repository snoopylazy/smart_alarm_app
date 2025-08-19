import 'package:flutter/material.dart';
import 'dart:async';

class StopwatchProvider extends ChangeNotifier {
  int _milliseconds = 0;
  bool _isRunning = false;
  Timer? _timer;
  List<String> _laps = [];

  /// Getters
  int get milliseconds => _milliseconds;
  bool get isRunning => _isRunning;
  List<String> get laps => _laps;

  void start() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(milliseconds: 10), _onTick);
      notifyListeners();
    }
  }

  void _onTick(Timer timer) {
    _milliseconds += 10;
    notifyListeners();
  }

  void pause() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    _isRunning = false;
    _milliseconds = 0;
    _timer?.cancel();
    _laps.clear();
    notifyListeners();
  }

  void lap() {
    _laps.insert(0, formatTime(_milliseconds));
    notifyListeners();
  }

  String formatMainTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    // String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  String formatHundredths(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    return (hundreds % 100).toString().padLeft(2, '0');
  }

  String formatTime(int milliseconds) {
    return '${formatMainTime(milliseconds)}.${formatHundredths(milliseconds)}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
} 