import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class RoutineCard extends StatelessWidget {
  const RoutineCard({
    super.key,
    required this.name,
    required this.numActivities,
    required this.completionRate,
    required this.color,
  });

  final String name;
  final int numActivities;
  final double completionRate;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(IconlyBold.bag_2),
        trailing: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              (completionRate * 100).toStringAsFixed(0),
              style: TextStyle(
                fontSize: 12,
                fontFamily: GoogleFonts.lexendDeca().fontFamily,
              ),
            ),
            CircularProgressIndicator(
              value: completionRate,
              valueColor: AlwaysStoppedAnimation(color),
              backgroundColor: Colors.white60,
            ),
          ],
        ),
        iconColor: color,
        title: Text(name),
        titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: GoogleFonts.lexendDeca().fontFamily),
        subtitle: Text("$numActivities activities"),
        subtitleTextStyle: TextStyle(
            color: Colors.black54,
            fontSize: 12,
            fontFamily: GoogleFonts.lexendDeca().fontFamily),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
