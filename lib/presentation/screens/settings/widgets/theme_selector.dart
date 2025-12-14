import 'package:flutter/material.dart';

class ThemeSelector extends StatelessWidget {
  final bool currentTheme;
  final ValueChanged<bool> onThemeChanged;

  const ThemeSelector({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildThemeOption(
            context:  context,
            title: 'Light Mode',
            subtitle: 'Bright and clean',
            icon: Icons. light_mode,
            isSelected: ! currentTheme,
            onTap: () {
              if (currentTheme) {
                onThemeChanged(false);
              }
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          _buildThemeOption(
            context: context,
            title: 'Dark Mode',
            subtitle: 'Easy on the eyes',
            icon: Icons. dark_mode,
            isSelected: currentTheme,
            onTap: () {
              if (!currentTheme) {
                onThemeChanged(true);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets. all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme. of(context).primaryColor
                : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius. circular(12),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[700],
                size: 28,
              ),
            ),
            const SizedBox(width:  16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight. w600,
                      color:  isSelected
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors. grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons. check_circle,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}