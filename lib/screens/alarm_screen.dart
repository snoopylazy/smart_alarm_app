import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alarm_provider.dart';
import '../constants/colors.dart';
import '../utils/custom_text_style.dart';
import '../widgets/circular_button.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AlarmProvider>(
      builder: (context, alarmProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,

          body: Stack(
            children: [
              alarmProvider.alarms.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.alarm, size: 64, color: Colors.grey[600]),
                        const SizedBox(height: 16),
                        Text(
                          'No alarms set',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    itemCount: alarmProvider.alarms.length,
                    itemBuilder: (context, index) {
                      final alarm = alarmProvider.alarms[index];
                      return Dismissible(
                        key: Key(alarm.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          alarmProvider.removeAlarm(alarm.id);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          color: const Color(0xFF2D2D2D),
                          child: ListTile(
                            title: Text(
                              alarmProvider.formatTimeWithAmPm(alarm.time),
                              style: myTextStyle24(),
                            ),
                            subtitle: Text(
                              alarmProvider.getRepeatDaysText(alarm.repeatDays),
                              style: myTextStyle15(fontColor: Colors.grey),
                            ),
                            trailing: Switch(
                              value: alarm.isActive,
                              onChanged: (value) {
                                alarmProvider.toggleAlarm(alarm.id);
                              },
                              activeColor: Colors.blue,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

              Positioned(
                bottom: 130,
                left: 140,
                child: SizedBox(
                  child: CircularButton(
                    buttonHeight: 80,
                    iconSize: 50,
                    icon: Icons.add_rounded,
                    onPressed: () => _showAddAlarmDialog(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddAlarmDialog(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    TimeOfDay selectedTime = TimeOfDay.now();
    List<bool> repeatDays = List.generate(7, (index) => false);

    // First show time picker
    showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    ).then((time) {
      if (time != null) {
        selectedTime = time;

        /// After time is selected, show days selection
        _showDaysSelectionDialog(
          context,
          alarmProvider,
          selectedTime,
          repeatDays,
        );
      }
    });
  }

  /// day select dialog box
  void _showDaysSelectionDialog(
    BuildContext context,
    AlarmProvider alarmProvider,
    TimeOfDay selectedTime,
    List<bool> repeatDays,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  backgroundColor: AppColors.background.withAlpha(150),
                  title: Text('Select Days', style: myTextStyle24()),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(7, (index) {
                          final days = [
                            'Sun',
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                          ];
                          final isSelected = repeatDays[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                repeatDays[index] = !isSelected;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.primary.withAlpha(50)
                                        : const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                days[index],
                                style: myTextStyle15(
                                  fontColor:
                                      isSelected ? Colors.white : Colors.grey,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                for (int i = 0; i < repeatDays.length; i++) {
                                  repeatDays[i] = true;
                                }
                              });
                            },
                            child: Text('Select All', style: myTextStyle15()),
                          ),

                          /// clear button
                          TextButton(
                            onPressed: () {
                              setState(() {
                                for (int i = 0; i < repeatDays.length; i++) {
                                  repeatDays[i] = false;
                                }
                              });
                            },
                            child: Text(
                              'Clear All',
                              style: myTextStyle15(fontColor: Colors.white38),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black26, thickness: 3),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: myTextStyle18(fontColor: Colors.white38),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final alarm = Alarm(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          time: selectedTime,
                          repeatDays: repeatDays,
                          isActive: true,
                        );
                        alarmProvider.addAlarm(alarm);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Save', style: myTextStyle18()),
                    ),
                  ],
                ),
          ),
    );
  }
}
