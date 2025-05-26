// lib/presentation/screens/user_onboarding/widgets/photo_slot.dart
import 'dart:io';
import 'package:flutter/material.dart';

class PhotoSlot extends StatelessWidget {
  final bool hasPhoto;
  final File? photo;
  final VoidCallback onTap;
  final bool isMain;

  const PhotoSlot({
    super.key,
    required this.hasPhoto,
    this.photo,
    required this.onTap,
    this.isMain = false,
  });

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF383A6B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isMain ? Colors.yellow : Colors.transparent,
            width: isMain ? 2 : 1,
          ),
        ),
        child: Stack(
          children: <Widget>[
            if (hasPhoto && photo != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  photo!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.yellow.withAlpha(179),
                      size: 32,
                    ),
                    if (isMain) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        'Foto principal',
                        style: TextStyle(
                          color: Colors.yellow.withAlpha(179),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            if (isMain && !hasPhoto)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.yellow.withAlpha(51),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.star, color: Colors.yellow, size: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
