import 'package:flutter/material.dart';
import '../../model/category_model.dart';
import '../theme/theme.dart';

class CategoryTile extends StatefulWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTile({super.key, required this.category,
    required this.isSelected , required this.onTap});

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return Padding(
      padding: const EdgeInsets.only(left:8,top:8,bottom:4),
      child: GestureDetector(
        onTap:widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? AppColors.highlight.withOpacity(0.3):AppColors.background  ,
            border: Border.all(
              color: AppColors.highlight
            )
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon(widget.category.icon,
              //     color: isSelected ? AppColors.secondary : AppColors.primary.withOpacity(0.6),
              //     size: 16),
              // const SizedBox(width: 4),
              Text(
                widget.category.name,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? AppColors.secondary : AppColors.primary.withOpacity(0.8),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchLocalAndPersonalizedNews(userLocation, userInterests) {}

  void fetchCategoryNews(categoryId) {}
}
