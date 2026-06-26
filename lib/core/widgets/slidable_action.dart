import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget buildCircularAction({
  required BuildContext context,
  required VoidCallback onTap,
  required IconData icon,
  required String label,
  required Color color,
}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Builder(
        builder: (ctx) => GestureDetector(
          onTap: () {
            Slidable.of(ctx)?.close();
            onTap();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
