import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class Alarm {
  final String id;
  final TimeOfDay time;
  final bool isActive;
  final List<bool> repeatDays; /// [Sun, Mon, Tue, Wed, Thu, Fri, Sat]
  final String label;

  Alarm({
    required this.id,
    required this.time,
    this.isActive = true,
    List<bool>? repeatDays,
    this.label = 'Alarm',
  }) : repeatDays = repeatDays ?? List.filled(7, false);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hour': time.hour,
      'minute': time.minute,
      'isActive': isActive,
      'repeatDays': repeatDays,
      'label': label,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      isActive: json['isActive'],
      repeatDays: List<bool>.from(json['repeatDays']),
      label: json['label'],
    );
  }

  Alarm copyWith({
    String? id,
    TimeOfDay? time,
    bool? isActive,
    List<bool>? repeatDays,
    String? label,
  }) {
    return Alarm(
      id: id ?? this.id,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
      repeatDays: repeatDays ?? this.repeatDays,
      label: label ?? this.label,
    );
  }
}

class AlarmProvider extends ChangeNotifier {
  final List<Alarm> _alarms = [];
  Timer? _checkAlarmsTimer;
  AudioPlayer? _audioPlayer;
  SharedPreferences? _prefs;
  
  List<Alarm> get alarms => _alarms;

  AlarmProvider() {
    _init();
  }

  Future<void> _init() async {
    _audioPlayer = AudioPlayer();
    _prefs = await SharedPreferences.getInstance();
    _loadAlarms();
    _checkAlarmsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkAlarms();
    });
  }

  Future<void> _loadAlarms() async {
    final alarmsJson = _prefs?.getStringList('alarms') ?? [];
    _alarms.clear();
    for (final json in alarmsJson) {
      try {
        final alarm = Alarm.fromJson(jsonDecode(json));
        _alarms.add(alarm);
      } catch (e) {
        print('Error loading alarm: $e');
      }
    }
    _sortAlarms();
    notifyListeners();
  }

  Future<void> _saveAlarms() async {
    final alarmsJson = _alarms.map((alarm) => jsonEncode(alarm.toJson())).toList();
    await _prefs?.setStringList('alarms', alarmsJson);
  }

  void _checkAlarms() {
    final now = DateTime.now();
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);
    
    for (final alarm in _alarms) {
      if (alarm.isActive && 
          alarm.time.hour == currentTime.hour && 
          alarm.time.minute == currentTime.minute) {
        playAlarmSound();
      }
    }
  }

  void addAlarm(Alarm alarm) {
    print('Adding alarm: ${formatTimeWithAmPm(alarm.time)}');
    _alarms.add(alarm);
    _sortAlarms();
    _saveAlarms();
    notifyListeners();
  }

  void removeAlarm(String id) {
    print('Removing alarm with id: $id');
    _alarms.removeWhere((alarm) => alarm.id == id);
    _saveAlarms();
    notifyListeners();
  }

  void toggleAlarm(String id) {
    print('Toggling alarm with id: $id');
    final index = _alarms.indexWhere((alarm) => alarm.id == id);
    if (index != -1) {
      _alarms[index] = _alarms[index].copyWith(
        isActive: !_alarms[index].isActive,
      );
      _saveAlarms();
      notifyListeners();
    }
  }

  void updateAlarm(String id, Alarm alarm) {
    final index = _alarms.indexWhere((a) => a.id == id);
    if (index != -1) {
      _alarms[index] = alarm;
      _sortAlarms();
      _saveAlarms();
      notifyListeners();
    }
  }

  void _sortAlarms() {
    _alarms.sort((a, b) {
      int aMinutes = a.time.hour * 60 + a.time.minute;
      int bMinutes = b.time.hour * 60 + b.time.minute;
      return aMinutes.compareTo(bMinutes);
    });
  }

  String formatTime(TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String formatTimeWithAmPm(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String getRepeatDaysText(List<bool> repeatDays) {
    List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    List<String> selectedDays = [];
    
    for (int i = 0; i < repeatDays.length; i++) {
      if (repeatDays[i]) {
        selectedDays.add(days[i]);
      }
    }
    
    if (selectedDays.isEmpty) return 'Once';
    if (selectedDays.length == 7) return 'Every day';
    if (selectedDays.length == 5 && 
        repeatDays[1] && repeatDays[2] && repeatDays[3] && 
        repeatDays[4] && repeatDays[5]) {
      return 'Weekdays';
    }
    if (selectedDays.length == 2 && 
        repeatDays[0] && repeatDays[6]) {
      return 'Weekends';
    }
    
    return selectedDays.join(', ');
  }

  Future<void> playAlarmSound() async {
    try {
      // Configure audio session
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          usage: AndroidAudioUsage.alarm,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
      ));

      // Set audio player settings
      await _audioPlayer!.setVolume(1.0);
      await _audioPlayer!.setLoopMode(LoopMode.off);
      
      // Use bundled asset with proper configuration
      await _audioPlayer!.setAudioSource(
        AudioSource.asset(
          'lib/assets/sounds/alarm.mp3',

        ),
        initialPosition: Duration.zero,
        preload: true,
      );
      
      await _audioPlayer!.play();
    } catch (e) {
      print('Error playing alarm sound: $e');
      // Try fallback method with simpler configuration
      try {
        final player = AudioPlayer();
        await player.setAsset(
          'lib/assets/sounds/alarm.mp3',

        );
        await player.play();
        await player.dispose();
      } catch (e) {
        print('Fallback also failed: $e');
      }
    }
  }

  @override
  void dispose() {
    _checkAlarmsTimer?.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }
} 