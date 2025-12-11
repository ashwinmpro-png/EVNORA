import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../config/themes.dart';
import '../../../core/models/program.dart';

class ProgramCard extends StatelessWidget {
  final Program program;
  final VoidCallback? onTap;
  final bool isCompact;

  const ProgramCard({
    super.key,
    required this.program,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isCompact ? double.infinity : 200,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey900.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: program.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: program.imageUrl!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            height: 100,
                            color: AppColors.grey100,
                            child: const Center(
                              child: Icon(
                                Icons.school,
                                color: AppColors.grey400,
                                size: 32,
                              ),
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            height: 100,
                            color: AppColors.grey100,
                            child: const Center(
                              child: Icon(
                                Icons.school,
                                color: AppColors.grey400,
                                size: 32,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 100,
                          color: _getCategoryColor(program.category).withOpacity(0.2),
                          child: Center(
                            child: Icon(
                              _getCategoryIcon(program.category),
                              color: _getCategoryColor(program.category),
                              size: 40,
                            ),
                          ),
                        ),
                ),
                // Category badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(program.category),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      program.categoryLabel,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                // Price badge
                if (program.hasDiscount)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${program.discountPercentage.toInt()}% OFF',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    program.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey900,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Duration and mode
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 14,
                        color: AppColors.grey500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        program.formattedDuration,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.grey400,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        program.deliveryMode.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Price
                  Row(
                    children: [
                      Text(
                        program.formattedPrice,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      if (program.hasDiscount) ...[
                        const SizedBox(width: 6),
                        Text(
                          '${program.currency} ${program.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'blue_collar':
        return AppColors.blueCollar;
      case 'white_collar':
        return AppColors.whiteCollar;
      case 'hse':
        return AppColors.hse;
      case 'digital_soft_skills':
        return AppColors.digital;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'blue_collar':
        return Icons.construction;
      case 'white_collar':
        return Icons.business_center;
      case 'hse':
        return Icons.health_and_safety;
      case 'digital_soft_skills':
        return Icons.computer;
      default:
        return Icons.school;
    }
  }
}

// List view version of program card
class ProgramListCard extends StatelessWidget {
  final Program program;
  final VoidCallback? onTap;

  const ProgramListCard({
    super.key,
    required this.program,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey900.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: program.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: program.imageUrl!,
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 110,
                        width: 110,
                        color: AppColors.grey100,
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 110,
                        width: 110,
                        color: AppColors.grey100,
                        child: const Icon(
                          Icons.school,
                          color: AppColors.grey400,
                        ),
                      ),
                    )
                  : Container(
                      height: 110,
                      width: 110,
                      color: AppColors.grey100,
                      child: const Icon(
                        Icons.school,
                        color: AppColors.grey400,
                      ),
                    ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        program.categoryLabel,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      program.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey900,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Duration
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: AppColors.grey500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${program.formattedDuration} • ${program.deliveryMode}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Price
                    Text(
                      program.formattedPrice,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Arrow
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
