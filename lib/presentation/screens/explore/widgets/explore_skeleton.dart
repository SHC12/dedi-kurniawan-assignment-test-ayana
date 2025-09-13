import 'package:flutter/material.dart';

class ExploreSkeleton extends StatelessWidget {
  const ExploreSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 16),
        _SkeletonBox(h: 48, pad: EdgeInsets.symmetric(horizontal: 16)),
        SizedBox(height: 12),
        _SkeletonBox(h: 20, w: 160, pad: EdgeInsets.symmetric(horizontal: 16)),
        SizedBox(height: 12),
        _SkeletonRowCards(),
        SizedBox(height: 16),
        _SkeletonGrid(),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double h;
  final double? w;
  final EdgeInsets pad;
  const _SkeletonBox({required this.h, this.w, required this.pad});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pad,
      child: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _SkeletonRowCards extends StatelessWidget {
  const _SkeletonRowCards();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) => Container(
          width: 150,
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(16)),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: 6,
      ),
    );
  }
}

class _SkeletonGrid extends StatelessWidget {
  const _SkeletonGrid();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.70,
        ),
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
