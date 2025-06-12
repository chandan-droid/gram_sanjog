import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gram_sanjog/controller/bookmark_controller.dart';

class NewsCardCompact extends StatefulWidget {
  final String newsId;
  final String imageUrl;
  final String title;
  final String subHeading;
  final int upvotes;
  final int shares;
   bool isBookmarked;

   NewsCardCompact({
    super.key,
     required this.newsId,
    required this.imageUrl,
    required this.title,
    required this.subHeading,
    required this.upvotes,
    required this.shares,
    this.isBookmarked = false,
  });

  @override
  State<NewsCardCompact> createState() => _NewsCardCompactState();
}

class _NewsCardCompactState extends State<NewsCardCompact> {
  final BookmarkController bookmarkController = Get.find<BookmarkController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 30),
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subHeading,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.thumb_up_alt_rounded, size: 16, color: theme.iconTheme.color),
                      const SizedBox(width: 4),
                      Text('${widget.upvotes}', style: theme.textTheme.labelSmall),

                      const SizedBox(width: 16),
                      Icon(Icons.share_rounded, size: 16, color: theme.iconTheme.color),
                      const SizedBox(width: 4),
                      Text('${widget.shares}', style: theme.textTheme.labelSmall),

                      const Spacer(),
                      Obx(() => IconButton(
                        onPressed: () {
                          bookmarkController.toggleBookmark(widget.newsId);
                        },
                        icon:Icon(
                          bookmarkController.isBookmarked(widget.newsId)
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          size: 20,
                          color: theme.iconTheme.color,
                        ),
                       )
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
