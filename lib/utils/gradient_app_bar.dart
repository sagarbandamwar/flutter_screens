import 'package:flutter/material.dart';
import 'package:flutter_mvvm/res/colors/app_colors.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Gradient gradient;

  const GradientAppBar({
    super.key,
    required this.title,
    required this.gradient,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: AppBar(
          title: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/app_logo_vertical.png',
                  height: 30.0, // Adjust the height as needed
                ),
              ),
              const SizedBox(width: 10.0),
               Center(
                 child: Text(
                  title,
                  style: const TextStyle(
                      fontFamily: 'Roboto-Regular',
                      fontSize: 24.0,
                      color: AppColors.black),
                               ),
               ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove shadow if needed
        ),
      ),
    );
  }
}
