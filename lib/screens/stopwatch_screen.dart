import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttimer/providers/stopwatch_provider.dart';
import 'package:smarttimer/utils/custom_text_style.dart';
import 'package:smarttimer/widgets/circular_button.dart';
import '../constants/colors.dart';

class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context).size ;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<StopwatchProvider>(
        builder: (context, stopwatchProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Stopwatch Display
                Container(
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
                  child: SizedBox(
                    width: mqData.width*0.8,
                    height: 300,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          /// Main time (MM:SS)
                          Container(
                            width: mqData.width * 0.5,
                            alignment: Alignment.centerRight,
                            child: Text(
                              stopwatchProvider.formatMainTime(
                                  stopwatchProvider.milliseconds),
                              style: myTextStyle72(fontSize: 60),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          // Hundredths (.CC)
                          SizedBox(
                            width: mqData.width * 0.3,
                            child: Text(
                              '.${stopwatchProvider.formatHundredths(
                                  stopwatchProvider.milliseconds)}',
                              style: myTextStyle72(fontColor: AppColors.primary , fontSize: 60),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Lap Times
             stopwatchProvider.laps.isNotEmpty ? Container(
                  height: mqData.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: stopwatchProvider.laps.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lap ${stopwatchProvider.laps.length - index}',
                              style: myTextStyle15(fontColor: Colors.white70),
                            ),
                            Text(
                              stopwatchProvider.laps[index],
                              style: myTextStyle15(fontColor: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ) : SizedBox(height: 200,),

                /// ----  Control Buttons ---- ///
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Reset Button
                    if (stopwatchProvider.milliseconds > 0)
                      CircularButton(
                        buttonHeight: 80,
                        buttonWidth: 80,
                        onPressed: stopwatchProvider.reset,
                        icon: Icons.refresh,
                        iconColor: Colors.white,
                        iconSize: 50,
                        buttonColor: Colors.orange,
                      ),
                  if(stopwatchProvider.isRunning)
                    /// Lap Button
                    CircularButton(
                      buttonHeight: 80,
                      buttonWidth: 80,
                      onPressed: stopwatchProvider.lap,
                      icon: Icons.flag,
                      iconColor: Colors.white,
                      iconSize: 50,
                      buttonColor: Colors.blue,
                    ),

                    // Start/Pause Button

                    CircularButton(
                      buttonHeight: 80,
                      buttonWidth: 80,
                      onPressed: stopwatchProvider.isRunning
                          ? stopwatchProvider.pause
                          : stopwatchProvider.start,
                      icon: stopwatchProvider.isRunning
                          ? Icons.pause
                          : Icons.play_arrow,
                      iconColor: Colors.white,
                      iconSize: 50,
                      buttonColor:
                      stopwatchProvider.isRunning ? Colors.red : Colors.greenAccent,
                    ),
                  ],
                ),
                SizedBox(height: 30,)
              ],
            ),
          );
        },
      ),
    );
  }
} 