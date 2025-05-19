import 'package:flutter/material.dart';
import 'package:toilet_training/models/bathroom_item.dart';

class BathroomGuessCard extends StatelessWidget {
  const BathroomGuessCard({
    super.key,
    required this.onTap,
    required this.answered,
    required this.item,
    required this.correctItem,
  });
  final VoidCallback onTap;
  final bool answered;
  final BathroomItem item;
  final BathroomItem correctItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                answered && item.id == correctItem.id
                    ? Colors.green
                    : answered && item.id != correctItem.id
                    ? Colors.red
                    : Colors.grey[300]!,
            width: answered ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset(
            item.image,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
              );
            },
          ),
        ),
      ),
    );
  }
}
