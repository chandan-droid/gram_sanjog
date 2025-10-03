import 'package:flutter/material.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'shimmer_loading.dart';

class NewsCardSkeleton extends StatelessWidget {
  const NewsCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: ShimmerLoading(
              width: 120,
              height: 120,
              borderRadius: 0,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoading(
                    width: 100,
                    height: 16,
                    borderRadius: 4,
                  ),
                  const SizedBox(height: 8),
                  ShimmerLoading(
                    width: double.infinity,
                    height: 16,
                    borderRadius: 4,
                  ),
                  const SizedBox(height: 4),
                  ShimmerLoading(
                    width: 180,
                    height: 16,
                    borderRadius: 4,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      ShimmerLoading(
                        width: 60,
                        height: 20,
                        borderRadius: 20,
                      ),
                      const SizedBox(width: 12),
                      ShimmerLoading(
                        width: 60,
                        height: 20,
                        borderRadius: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategorySkeleton extends StatelessWidget {
  const CategorySkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ShimmerLoading(
              width: 100,
              height: 36,
              borderRadius: 20,
            ),
          );
        },
      ),
    );
  }
}

class TopNewsSkeleton extends StatelessWidget {
  const TopNewsSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ShimmerLoading(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 12,
      ),
    );
  }
}

class LocationHeaderSkeleton extends StatelessWidget {
  const LocationHeaderSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          ShimmerLoading(
            width: 36,
            height: 36,
            borderRadius: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(
                  width: 200,
                  height: 16,
                  borderRadius: 4,
                ),
                const SizedBox(height: 8),
                ShimmerLoading(
                  width: 150,
                  height: 14,
                  borderRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
