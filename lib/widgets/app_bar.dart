import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onProfileTap; // Callback for profile drawer

  const CustomAppBar({
    Key? key,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme

    return AppBar(
      backgroundColor: theme.brightness == Brightness.light
          ? Colors.white
          : theme.scaffoldBackgroundColor, // Dynamic background based on theme
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        color: theme.iconTheme.color, // Icon color based on theme
        onPressed: onProfileTap, // Open profile drawer
      ),
      title: Row(
        children: [
          const Spacer(), // Pushes the button to the right
          
        ],
      ),
      centerTitle: true, // Centers the title/content in the app bar
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60); // AppBar height
}


