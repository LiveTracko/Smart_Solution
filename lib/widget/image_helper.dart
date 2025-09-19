import 'dart:io';
import 'package:flutter/material.dart';

class ImageHelper {
  static ImageProvider getImageProvider({
    String? profileImage, // URL or relative path
    String? fallbackUrl, // optional fallback from controller
    String assetPath = "assets/images/user.png", // default asset
    String? baseUrl, // for relative paths
    File? localFile, // optional local file
  }) {
    // Local file (picked from gallery/camera)
    if (localFile != null && localFile.path.isNotEmpty) {
      return FileImage(localFile);
    }

    // Passed string
    if (profileImage != null && profileImage.isNotEmpty) {
      if (profileImage.startsWith("http")) {
        return NetworkImage(profileImage);
      } else if (baseUrl != null) {
        return NetworkImage(baseUrl + profileImage);
      }
    }

    // Fallback URL
    if (fallbackUrl != null && fallbackUrl.isNotEmpty) {
      return NetworkImage(fallbackUrl);
    }

    // Final fallback: asset
    return AssetImage(assetPath);
  }
}
