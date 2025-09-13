import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class LanguageTile extends StatelessWidget {
  final String flag;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const LanguageTile({required this.flag, required this.title, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? primaryColor : Colors.white12, width: selected ? 1.6 : 1),
          boxShadow: selected
              ? [BoxShadow(color: primaryColor.withOpacity(0.25), blurRadius: 18, offset: const Offset(0, 6))]
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            _RadioDot(active: selected),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool active;
  const _RadioDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: active ? primaryColor : Colors.white30, width: 2),
      ),
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: active ? 8 : 0,
        height: active ? 8 : 0,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: primaryColor),
      ),
    );
  }
}
