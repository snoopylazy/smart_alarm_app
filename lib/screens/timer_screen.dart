import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smarttimer/utils/custom_text_style.dart';
import 'package:smarttimer/widgets/circular_button.dart';
import '../constants/colors.dart';
import '../providers/timer_provider.dart';
import '../widgets/gradientCircularProgressPainter.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  Widget _buildTimePicker(TimerProvider provider) {
    const double itemExtent = 80.0;
    const double fontSize = 70.0;
    return SizedBox(
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// ---- Hours --- ///
          Expanded(
            child: CupertinoPicker(
              itemExtent: itemExtent,
              backgroundColor: Colors.transparent,
              looping: true,
              magnification: 1.1,
              diameterRatio: 2 / 2,
              onSelectedItemChanged: (index) => provider.setHours(index),
              children: provider.hoursList
                  .map((hour) => Center(
                        child: Text(
                          hour,
                          style: myTextStyle48(fontColor: Colors.white),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const Text(
            ":",
            style: TextStyle(fontSize: fontSize, color: Colors.white),
          ),
          /// --- Minutes --- ///
          Expanded(
            child: CupertinoPicker(
              itemExtent: itemExtent,
              backgroundColor: Colors.transparent,
              looping: true,
              magnification: 1.1,
              diameterRatio: 2 / 2,
              onSelectedItemChanged: (index) => provider.setMinutes(index),
              children: provider.minutesList
                  .map((minute) => Center(
                        child: Text(
                          minute,
                          style: myTextStyle48(fontColor: Colors.white),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const Text(
            ":",
            style: TextStyle(fontSize: fontSize, color: Colors.white),
          ),
          /// --- Seconds --- ///
          Expanded(
            child: CupertinoPicker(
              itemExtent: itemExtent,
              backgroundColor: Colors.transparent,
              looping: true,
              magnification: 1.1,
              diameterRatio: 2 / 2,
              onSelectedItemChanged: (index) => provider.setSeconds(index),
              children: provider.secondsList
                  .map((second) => Center(
                        child: Text(
                          second,
                          style: myTextStyle48(fontColor: Colors.white),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<TimerProvider>(
        builder: (context, timerProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// time pick
                if (!timerProvider.isRunning && 
                    !timerProvider.isCompleted && 
                    !timerProvider.isPaused)
                  _buildTimePicker(timerProvider),

                /// --- running time --- ///
                if (timerProvider.isRunning || 
                    timerProvider.isCompleted || 
                    timerProvider.isPaused)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background.withAlpha(160),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(2, 2),
                          ),
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(-2, -2),
                          ),
                        ],
                      ),
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: Duration(seconds: timerProvider.remainingSeconds),
                        builder: (context, value, child) {
                          final totalSeconds = (timerProvider.hours * 3600) +
                              (timerProvider.minutes * 60) +
                              timerProvider.seconds;
                          final progress = timerProvider.isCompleted
                              ? 1.0
                              : 1 - (timerProvider.remainingSeconds / totalSeconds);
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 350,
                                height: 350,
                                child: CustomPaint(
                                  painter: GradientCircularProgressPainter(
                                    progress: progress,
                                    strokeWidth: 16,
                                    gradientColors: timerProvider.isCompleted
                                        ? [
                                            Colors.green.shade300,
                                            Colors.greenAccent,
                                            Colors.greenAccent.shade100,
                                          ]
                                        : [
                                            Colors.red.shade400,
                                            Colors.yellow.shade200,
                                            Colors.green.shade200,
                                          ],
                                  ),
                                ),
                              ),
                              Text(
                                timerProvider.formatTime(
                                    timerProvider.remainingSeconds),
                                style: myTextStyle72(),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 50),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// --- Start button --- ///
                      if (!timerProvider.isRunning &&
                          !timerProvider.isCompleted &&
                          !timerProvider.isPaused)
                        CircularButton(
                          onPressed: timerProvider.startTimer,
                          icon: Icons.play_arrow_rounded,
                          iconColor: Colors.white,
                          iconSize: 150,
                          buttonColor: Colors.greenAccent,
                        ),
                      if (timerProvider.isRunning || timerProvider.isPaused || timerProvider.isCompleted)
                        CircularButton(
                          buttonHeight: 80,
                          buttonWidth: 80,
                          onPressed: timerProvider.stopTimer,
                          icon: Icons.close_rounded,
                          iconColor: Colors.white,
                          iconSize: 50,
                        ),
                      if (timerProvider.isRunning || timerProvider.isPaused)
                        CircularButton(
                          buttonHeight: 80,
                          buttonWidth: 80,
                          onPressed: timerProvider.pauseTimer,
                          icon: timerProvider.isPaused
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded,
                          iconColor: Colors.white,
                          iconSize: 50,
                          buttonColor: timerProvider.isPaused
                              ? Colors.greenAccent
                              : Colors.red.shade400,
                        ),
                      if (timerProvider.isRunning || timerProvider.isPaused)
                        CircularButton(
                          buttonHeight: 80,
                          buttonWidth: 80,
                          onPressed: timerProvider.resetTimer,
                          icon: Icons.restart_alt,
                          iconColor: Colors.white,
                          iconSize: 50,
                          buttonColor: Colors.orange,
                        ),

                      if (timerProvider.isCompleted)
                        CircularButton(
                          buttonHeight: 80,
                          buttonWidth: 80,
                          buttonColor: Colors.greenAccent,
                          onPressed: timerProvider.stopTimer,
                          icon: Icons.check,
                          iconColor: Colors.white,
                          iconSize: 50,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
