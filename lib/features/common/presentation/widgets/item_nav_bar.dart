import 'package:flutter/material.dart';

class ItemNewNavBar extends StatelessWidget {
  const ItemNewNavBar({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey.shade300.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
