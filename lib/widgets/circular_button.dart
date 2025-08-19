import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color iconColor;
  final IconData icon;
  final double iconSize;
  final double buttonWidth ;
  final double buttonHeight ;

  const CircularButton({
    Key? key,
    required this.onPressed,
    this.buttonColor = Colors.blue,
    this.iconColor = Colors.white,
    this.icon = Icons.play_arrow_rounded,
    this.iconSize = 180,
    this.buttonHeight = 200 ,
    this.buttonWidth = 200 ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: buttonColor.withAlpha(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(-3, -3),
            ),
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: SizedBox(
              height:buttonHeight,
              width: buttonHeight,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    elevation: 8,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    shape: const CircleBorder(),
                  ),
                  onPressed: onPressed,
                  child: Center(
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
