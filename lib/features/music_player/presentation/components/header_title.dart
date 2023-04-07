
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle(
      {Key? key,
      required this.icon,
      required this.leadingText,
      required this.trailingText})
      : super(key: key);
  final IconData icon;
  final String leadingText;
  final String trailingText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Icon(icon),
          const SizedBox(
            width: 5,
          ),
          Text(
            leadingText,
            style: GoogleFonts.poppins()
                .copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(trailingText, style: GoogleFonts.poppins()),
        ],
      ),
    );
  }
}
