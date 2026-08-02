import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:giftcard_wallet/utils/brand_config.dart';

class GiftCardWidget extends StatelessWidget {
  final Map<String, dynamic> card;

  const GiftCardWidget({super.key, required this.card});

  Alignment _watermarkAlignment(String brand) {
    switch (brand.toLowerCase()) {
      case "amazon":
        return const Alignment(1.15, -0.35);

      case "netflix":
        return const Alignment(1.05, -0.15);

      case "steam":
        return const Alignment(1.10, -0.10);

      case "google play":
        return const Alignment(1.10, -0.20);

      case "swiggy":
        return const Alignment(1.15, -0.15);

      case "myntra":
        return const Alignment(1.05, -0.15);

      default:
        return const Alignment(1.10, -0.15);
    }
  }

  double _watermarkSize(String brand) {
    switch (brand.toLowerCase()) {
      case "amazon":
        return 145;

      case "netflix":
        return 165;

      case "steam":
        return 150;

      case "google play":
        return 150;

      default:
        return 145;
    }
  }

  double _watermarkOpacity(String brand) {
    switch (brand.toLowerCase()) {
      case "amazon":
        return .32;

      case "netflix":
        return .32;

      default:
        return .32;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String brand = card["brand"] ?? "";

    final List<Color> gradient =
        BrandConfig.gradients[brand] ??
        const [Color(0xFF232526), Color(0xFF414345), Color(0xFF5A5A5A)];

    final String logoPath = BrandConfig.logos[brand] ?? "";

    return AspectRatio(
      aspectRatio: 1.58,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
            stops: const [.05, .55, 1],
          ),

          border: Border.all(color: Colors.white.withOpacity(.08), width: 1),

          boxShadow: [
            BoxShadow(
              color: gradient.last.withOpacity(.22),
              blurRadius: 28,
              spreadRadius: 2,
              offset: const Offset(0, 14),
            ),

            BoxShadow(
              color: Colors.black.withOpacity(.40),
              blurRadius: 36,
              offset: const Offset(0, 18),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),

          child: Stack(
            children: [
              // Top Highlight
              Positioned(
                top: -80,
                left: -30,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(.08),
                  ),
                ),
              ),

              // Bottom Glow
              Positioned(
                bottom: -120,
                right: -80,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: gradient.last.withOpacity(.18),
                  ),
                ),
              ),

              // Glass Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(.08),
                        Colors.transparent,
                        Colors.black.withOpacity(.06),
                      ],
                    ),
                  ),
                ),
              ),

              if (logoPath.isNotEmpty)
                Align(
                  alignment: _watermarkAlignment(brand),
                  child: Opacity(
                    opacity: _watermarkOpacity(brand),
                    child: SizedBox(
                      width: _watermarkSize(brand),
                      height: _watermarkSize(brand),
                      child: SvgPicture.asset(logoPath, fit: BoxFit.contain),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(18),

                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topLeft,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: SvgPicture.asset(logoPath),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        brand,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .3,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        "Gift Card",
                        style: TextStyle(
                          color: Colors.white.withOpacity(.65),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .4,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "₹${card["amount"]}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .2,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "VALID",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.55),
                                  fontSize: 9,
                                ),
                              ),

                              Text(
                                card["expiry"] ?? "--/--",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
