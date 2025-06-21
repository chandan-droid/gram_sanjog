import 'package:flutter/material.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/common/widgets/search_delegate.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search Information...',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //openSearchSheet(context);
        showSearch(
          context: context,
          delegate: NewsSearchDelegate(),
        );
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.iconPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              hintText,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
