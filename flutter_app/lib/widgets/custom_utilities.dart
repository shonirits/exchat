
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? side;
  final Color? bgColor;
  final Color? textColor;
  final VoidCallback onPressed;
  const CustomButton({
    Key? key,
    required this.text,
    @required this.icon,
    @required this.side,
    @required this.bgColor,
    @required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(side == 'left') ...[
            FaIcon(icon,
              color: textColor,),
            const SizedBox(
              width: 5,
            ),
          ],
          Text(
            text,
            style:  TextStyle(
              color: textColor,
              fontSize: 17
            ),
          ), // <-- Text
          if(side == 'right') ...[
            const SizedBox(
              width: 5,
            ),
            FaIcon(icon,
              color: textColor,
            size: 17),
          ],
        ],
      ),
    );
  }
}