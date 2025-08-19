# Smart Timer App

A modern and feature-rich timer application built with Flutter that includes Timer, Stopwatch, and Alarm functionalities.
## Poster
<img src = "https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/1.png" /> 
<img src = "https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/2.png" /> 
<img src = "https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/3.png" /> 
 
## Features

### Timer
- Customizable countdown timer
- Pause/Resume functionality
- Visual progress indicator
- Sound notification when timer completes
- Clean and intuitive interface

### Stopwatch
- Precise time tracking with hundredths of a second
- Start/Stop/Reset functionality
- Continuous updates
- Clear display of hours, minutes, seconds, and centiseconds

### Alarm
- Set multiple alarms with AM/PM time format
- Repeat alarms on selected days
- Custom day selection interface with visual feedback
- Enable/Disable alarms with toggle switch
- Swipe-to-delete functionality
- Persistent alarm storage

## Screenshots
<div>
  <img src="https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/Screenshot_20250404_231018.png" height = "600" />
   <img src="https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/Screenshot_20250404_231204.png" height = "600" />
   <img src="https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/Screenshot_20250404_231221.png" height = "600" />
   <img src="https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/Screenshot_20250404_231252.png" height = "600" />
   <img src="https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/Screenshot_20250404_231311.png" height = "600" />
   <img src="https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/Screenshot_20250404_231330.png" height = "600" />
   <img src="https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/Screenshot_20250404_231508.png" height = "600" />
   <img src="https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/Screenshot_20250404_231554.png" height = "600" />
   <img src="https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/Screenshot_20250404_232114.png" height = "600" />
   <img src="https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/Screenshot_20250404_232951.png" height = "600" />
    <img src="https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/Screenshot_20250404_233401.png" height = "600" />
   <img src="https://github.com/rahulkumardev24/smartTimer---Advanced-Timer-Alarm-App/blob/master/Screenshot_20250404_233412.png" height = "600" />
</div>

## Technical Features
- State management using Provider
- Persistent data storage using SharedPreferences
- Custom audio handling with just_audio
- Modern UI with persistent bottom navigation
- Dark theme implementation
- Custom animations and transitions

## Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  audioplayers: ^5.2.1
  provider: ^6.1.1
  just_audio: ^0.9.36
  audio_session: ^0.1.18
  shared_preferences: ^2.2.2
  persistent_bottom_nav_bar: ^4.0.8
```

## Getting Started

### Prerequisites
- Flutter SDK
- Android Studio / VS Code
- Android SDK / Xcode (for iOS development)

### Installation
1. Clone the repository
```bash
git clone https://github.com/yourusername/smarttimer.git
```

2. Navigate to the project directory
```bash
cd smarttimer
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## Project Structure
```
lib/
├── constants/
│   └── colors.dart
├── providers/
│   ├── alarm_provider.dart
│   ├── timer_provider.dart
│   └── stopwatch_provider.dart
├── screens/
│   ├── alarm_screen.dart
│   ├── timer_screen.dart
│   ├── stopwatch_screen.dart
│   └── dashboard_screen.dart
├── widgets/
│   └── circular_button.dart
├── utils/
│   └── custom_text_style.dart
└── main.dart
```

## Features in Detail

### Timer Screen
- Circular progress indicator
- Time input functionality
- Start/Pause/Resume/Reset controls
- Visual feedback during countdown

### Stopwatch Screen
- High precision time tracking
- Clear time display
- Intuitive controls
- Smooth animations

### Alarm Screen
- Time picker with AM/PM format
- Day selection with visual feedback
- Persistent alarm storage
- Easy alarm management
- Sound notifications

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments
- Flutter team for the amazing framework
- Contributors and package maintainers
- [Add any other acknowledgments]


## Future Improvements
- [ ] Add custom alarm sounds
- [ ] Implement alarm snooze functionality
- [ ] Add timer presets
- [ ] Support for multiple timers
- [ ] Add lap functionality to stopwatch
- [ ] Implement dark/light theme toggle
- [ ] Add widget support
- [ ] Backup and restore functionality
