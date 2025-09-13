import 'package:ayana_movies/core/l10n.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/typhography.dart';

class DarkMode extends StatefulWidget {
  const DarkMode({super.key});

  @override
  State<DarkMode> createState() => _DarkModeState();
}

class _DarkModeState extends State<DarkMode> {
  bool darkMode = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFF15202D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _ModePill(
                selected: darkMode,
                icon: Icons.nightlight_round,
                label: context.t('dark_mode'),
                onTap: () => setState(() => darkMode = true),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _ModePill(
                selected: !darkMode,
                icon: Icons.wb_sunny_rounded,
                label: context.t('light_mode'),
                onTap: () => setState(() => darkMode = false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ModePill({required this.selected, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFF1E2B40) : Colors.transparent;
    final border = selected ? const Color(0xFF4F8BFF) : Colors.white.withOpacity(0.10);
    final fg = selected ? Colors.white : const Color(0xFFB7C0CE);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 8),
            Text(label, style: defaultWhiteTextStyle),
          ],
        ),
      ),
    );
  }
}
