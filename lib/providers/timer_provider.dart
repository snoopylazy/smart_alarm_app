import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class TimerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isCompleted = false;
  bool _isPaused = false;

  /// Getters
  int get hours => _hours;
  int get minutes => _minutes;
  int get seconds => _seconds;
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  bool get isCompleted => _isCompleted;
  bool get isPaused => _isPaused;

  // Lists for the pickers
  final List<String> hoursList = List.generate(
    24,
    (index) => index.toString().padLeft(2, '0'),
  );
  final List<String> minutesList = List.generate(
    60,
    (index) => index.toString().padLeft(2, '0'),
  );
  final List<String> secondsList = List.generate(
    60,
    (index) => index.toString().padLeft(2, '0'),
  );

  void setHours(int value) {
    _hours = value;
    notifyListeners();
  }

  void setMinutes(int value) {
    _minutes = value;
    notifyListeners();
  }

  void setSeconds(int value) {
    _seconds = value;
    notifyListeners();
  }

  void startTimer() {
    if (_hours == 0 && _minutes == 0 && _seconds == 0) return;
    _isRunning = true;
    _isPaused = false;
    _isCompleted = false;
    if (_remainingSeconds == 0) {
      _remainingSeconds = (_hours * 3600) + (_minutes * 60) + _seconds;
    }
    notifyListeners();
    _runTimer();
  }

  void pauseTimer() {
    if (_isRunning) {
      // Pause
      _isRunning = false;
      _isPaused = true;
    } else if (_isPaused) {
      // Resume
      _isRunning = true;
      _isPaused = false;
      _runTimer();
    }
    notifyListeners();
  }

  void stopTimer() {
    _isRunning = false;
    _isPaused = false;
    _isCompleted = false;
    _remainingSeconds = 0;
    _hours = 0;
    _minutes = 0;
    _seconds = 0;
    notifyListeners();
  }

  void resetTimer() {
    _isRunning = false;
    _isCompleted = false;
    _isPaused = false;
    // Reset to initial time
    _remainingSeconds = (_hours * 3600) + (_minutes * 60) + _seconds;
    // Start the timer again
    _isRunning = true;
    _runTimer();
    notifyListeners();
  }

  void _runTimer() {
    if (!_isRunning) return;
    Future.delayed(const Duration(seconds: 1), () {
      if (_remainingSeconds > 0 && _isRunning) {
        _remainingSeconds--;
        notifyListeners();
        _runTimer();
      } else if (_remainingSeconds == 0 && _isRunning) {
        _isRunning = false;
        _isCompleted = true;
        _isPaused = false;
        notifyListeners();
        _playCompletionSound();
      }
    });
  }

  /// complete audio play
  Future<void> _playCompletionSound() async {
    try {
      String audioPath = "lib/assets/sounds/bell.mp3";
      await _audioPlayer.setAsset(audioPath);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
