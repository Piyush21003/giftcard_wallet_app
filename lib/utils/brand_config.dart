import 'package:flutter/material.dart';

class BrandConfig {
  static const Map<String, String> logos = {
    "Amazon": "assets/images/amazon.svg",
    "Flipkart": "assets/images/flipkart.svg",
    "Google Play": "assets/images/google_play.svg",
    "Netflix": "assets/images/netflix.svg",
    "Steam": "assets/images/steam.svg",
    "Apple": "assets/images/apple.svg",
    "Starbucks": "assets/images/starbucks.svg",
    "Swiggy": "assets/images/swiggy.svg",
    "Myntra": "assets/images/myntra.svg",
    "PVR": "assets/images/pvr.svg",
  };

  static const Map<String, List<Color>> gradients = {
    // Amazon
    "Amazon": [
      Color(0xFF171922),
      Color(0xFF2B221D),
      Color(0xFFE47A1B),
    ],

    // Flipkart
    "Flipkart": [
      Color(0xFF0B3E99),
      Color(0xFF1565D8),
      Color(0xFF2F8FFF),
    ],

    // Google Play
    "Google Play": [
      Color(0xFF181D2A),
      Color(0xFF20293D),
      Color(0xFF253349),
    ],

    // Netflix
    "Netflix": [
      Color(0xFF181015),
      Color(0xFF451019),
      Color(0xFFD40015),
    ],

    // Steam
    "Steam": [
      Color(0xFF17233D),
      Color(0xFF243A68),
      Color(0xFF2F4F91),
    ],

    // Apple
    "Apple": [
      Color(0xFF111111),
      Color(0xFF222222),
      Color(0xFF4A4A4A),
    ],

    // Starbucks
    "Starbucks": [
      Color(0xFF005839),
      Color(0xFF00794F),
      Color(0xFF0A8D60),
    ],

    // Swiggy
    "Swiggy": [
      Color(0xFF3A241B),
      Color(0xFF8F3F18),
      Color(0xFFFF7A1A),
    ],

    // Myntra
    "Myntra": [
      Color(0xFF34132E),
      Color(0xFF702356),
      Color(0xFFD54892),
    ],

    // PVR
    "PVR": [
      Color(0xFF3E196A),
      Color(0xFF6930B8),
      Color(0xFF8B5CF6),
    ],
  };
}