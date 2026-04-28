import 'package:flutter/material.dart';
import '../../common/theme/app_theme.dart';
import 'onboarding_data.dart';

class OnboardingSlideWidget extends StatefulWidget {
  final OnboardingSlide slide;
  final bool isActive;
  final int index;

  const OnboardingSlideWidget({
    super.key,
    required this.slide,
    required this.isActive,
    this.index = 0,
  });

  @override
  State<OnboardingSlideWidget> createState() => _OnboardingSlideWidgetState();
}

class _OnboardingSlideWidgetState extends State<OnboardingSlideWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  late Animation<double> _emojiScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 1.0, curve: Curves.easeOut)),
    );

    _slideUp = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic)),
    );

    _emojiScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );

    if (widget.isActive) _controller.forward();
  }

  @override
  void didUpdateWidget(OnboardingSlideWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Build diverse and unique image styles for each slide
  Widget _buildUniqueImageWidget(Size size) {
    switch (widget.index) {
      case 0:
        // Slide 1: Modern gradient circle with animated rings
        return Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: _emojiScale,
              child: Container(
                width: size.width * 0.65,
                height: size.width * 0.65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.milkTea.withOpacity(0.3),
                      AppColors.darkBrown.withOpacity(0.1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.milkTea.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              ),
            ),
            ScaleTransition(
              scale: _emojiScale,
              child: Container(
                width: size.width * 0.55,
                height: size.width * 0.55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(0.7),
                ),
              ),
            ),
            ScaleTransition(
              scale: _emojiScale,
              child: Text(
                widget.slide.emoji,
                style: TextStyle(fontSize: size.width * 0.22),
              ),
            ),
          ],
        );

      case 1:
        // Slide 2: Hexagon/Modern geometric style
        return ScaleTransition(
          scale: _emojiScale,
          child: Container(
            width: size.width * 0.68,
            height: size.width * 0.68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.tapioca.withOpacity(0.4),
                  AppColors.milkTea.withOpacity(0.2),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.tapioca.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 8,
                  offset: const Offset(5, 15),
                ),
                BoxShadow(
                  color: AppColors.milkTea.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: -5,
                  offset: const Offset(-5, -5),
                ),
              ],
              border: Border.all(
                color: AppColors.milkTea.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.slide.emoji,
                  style: TextStyle(fontSize: size.width * 0.24),
                ),
              ],
            ),
          ),
        );

      case 2:
        // Slide 3: Dynamic rounded rectangle with accent elements
        return Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: _emojiScale,
              child: Container(
                width: size.width * 0.70,
                height: size.width * 0.70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.darkBrown.withOpacity(0.08),
                      AppColors.milkTea.withOpacity(0.15),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkBrown.withOpacity(0.15),
                      blurRadius: 35,
                      spreadRadius: 5,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
              ),
            ),
            // Accent elements
            Positioned(
              top: size.width * 0.05,
              right: size.width * 0.05,
              child: ScaleTransition(
                scale: _emojiScale,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.darkBrown.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: size.width * 0.08,
              left: size.width * 0.08,
              child: ScaleTransition(
                scale: _emojiScale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.milkTea.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            ScaleTransition(
              scale: _emojiScale,
              child: Text(
                widget.slide.emoji,
                style: TextStyle(fontSize: size.width * 0.20),
              ),
            ),
          ],
        );

      case 3:
        // Slide 4: Elegant card with layered design
        return ScaleTransition(
          scale: _emojiScale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer shadow layer
              Container(
                width: size.width * 0.72,
                height: size.width * 0.72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.milkTea.withOpacity(0.25),
                      AppColors.mediumBrown.withOpacity(0.15),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mediumBrown.withOpacity(0.2),
                      blurRadius: 45,
                      spreadRadius: 12,
                      offset: const Offset(8, 16),
                    ),
                  ],
                ),
              ),
              // Inner content layer
              Container(
                width: size.width * 0.65,
                height: size.width * 0.65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: AppColors.white.withOpacity(0.8),
                  border: Border.all(
                    color: AppColors.milkTea.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.slide.emoji,
                    style: TextStyle(fontSize: size.width * 0.23),
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        // Default: Original circular style
        return ScaleTransition(
          scale: _emojiScale,
          child: Container(
            width: size.width * 0.65,
            height: size.width * 0.65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withOpacity(0.6),
              boxShadow: [
                BoxShadow(
                  color: AppColors.milkTea.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.slide.emoji,
                  style: TextStyle(fontSize: size.width * 0.22),
                ),
              ],
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.cream,
            AppColors.tapioca.withOpacity(0.4),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),

              // Unique illustration area for each slide
              Center(
                child: _buildUniqueImageWidget(size),
              ),

              const Spacer(flex: 1),

              // Text content
              SlideTransition(
                position: _slideUp,
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.milkTea.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.slide.subtitle,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.mediumBrown,
                            fontSize: 11,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        widget.slide.title,
                        style: AppTextStyles.display.copyWith(
                          fontSize: 36,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        widget.slide.description,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.darkGrey.withOpacity(0.75),
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

