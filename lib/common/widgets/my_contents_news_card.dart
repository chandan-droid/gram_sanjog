
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/controller/bookmark_controller.dart';
import 'package:gram_sanjog/view/detailed_news_view.dart';

class MyContentsNewsCard extends StatelessWidget {
  final String newsId;
  final String imageUrl;
  final String title;
  final String subHeading;
  final int upvotes;
  final int shares;
  final String status; 
  final DateTime? timestamp; 
  final bool isBookmarked;
  final VoidCallback? onEdit; 
  final VoidCallback? onDelete;

  MyContentsNewsCard({
    super.key,
    required this.newsId,
    required this.imageUrl,
    required this.title,
    required this.subHeading,
    required this.upvotes,
    required this.shares,
    required this.status,
    this.timestamp,
    this.isBookmarked = false,
    this.onEdit,
    this.onDelete,
  });

  final BookmarkController bookmarkController = Get.find<BookmarkController>();

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.to(() => NewsDetailScreen(newsId: newsId));
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft:Radius.circular(12) ,bottomLeft:Radius.circular(12) ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 100,
                                  height: 100,
                                  color: AppColors.background,
                                  child: const Icon(Icons.broken_image, size: 30),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Title
                                  Text(
                                    title,
                                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  /// Subheading
                                  const SizedBox(height: 4),
                                  Text(
                                    subHeading,
                                    style: theme.textTheme.bodyMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  /// Status and Timestamp
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: statusColor(status).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          status.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: statusColor(status),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      if (timestamp != null)
                                        Text(
                                          '${timestamp!.day}/${timestamp!.month}/${timestamp!.year}',
                                          style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey),
                                        ),
                                    ],
                                  ),

                                  /// Action row
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.thumb_up_alt_outlined, size: 16, color: theme.iconTheme.color),
                                      const SizedBox(width: 4),
                                      Text('$upvotes', style: theme.textTheme.labelSmall),

                                      const SizedBox(width: 16),
                                      Icon(Icons.share, size: 16, color: theme.iconTheme.color),
                                      const SizedBox(width: 4),
                                      Text('$shares', style: theme.textTheme.labelSmall),

                                      const Spacer(),

                                      /// Bookmark Toggle
                                      Obx(() => IconButton(
                                        onPressed: () {
                                          bookmarkController.toggleBookmark(newsId);
                                        },
                                        icon: Icon(
                                          bookmarkController.isBookmarked(newsId)
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                          size: 20,
                                          color: theme.iconTheme.color,
                                        ),
                                      )),

                                      ///  Edit

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
                      child: Container(
                        color: AppColors.info.withOpacity(0.9),
                        child: IconButton(
                          icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                          onPressed: onEdit,
                        ),
                      ),
                    ),
                  ),
                //Delete
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12)),                child: Container(
                        color: AppColors.error.withOpacity(0.9),
                        child: IconButton(
                          icon: const Icon(Icons.delete, size: 18, color: Colors.white),
                          onPressed: onDelete,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
