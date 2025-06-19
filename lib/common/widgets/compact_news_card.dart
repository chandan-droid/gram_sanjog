import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/controller/bookmark_controller.dart';

import '../../view/detailed_news_view.dart';

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

    return GestureDetector(
      onTap: (){
        Get.to(()=>NewsDetailScreen(newsId: widget.newsId,));
        },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter:ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
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
                        widget.imageUrl,
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
                              Icon(Icons.favorite_border, size: 16, color: theme.iconTheme.color),
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
            ),
          ),
        ),
      ),
    );
  }
}
