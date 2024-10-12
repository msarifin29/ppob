import 'package:flutter/material.dart';

class ButtonEditImage extends StatelessWidget {
  const ButtonEditImage({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(),
          ),
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
