class OnboardingSlide {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final String emoji;
  final List<String> gradientColors;

  const OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.emoji,
    required this.gradientColors,
  });
}

final List<OnboardingSlide> onboardingSlides = [
  OnboardingSlide(
    title: 'Chào mừng đến\nvới Trà Sữa',
    subtitle: 'BOBA HOUSE',
    description: 'Nơi mỗi ly trà sữa là một câu chuyện,\nmỗi ngụm là một kỷ niệm đáng nhớ.',
    imagePath: 'assets/images/onboarding_1.png',
    emoji: '🧋',
    gradientColors: ['#F5ECD7', '#E8D5B0'],
  ),
  OnboardingSlide(
    title: 'Hàng trăm\nhương vị độc đáo',
    subtitle: 'ĐA DẠNG LỰA CHỌN',
    description: 'Từ trà sữa classic, matcha tươi đến taro\nthơm ngon – tất cả chờ bạn khám phá.',
    imagePath: 'assets/images/onboarding_2.png',
    emoji: '🍵',
    gradientColors: ['#EDF2E8', '#D4E4CC'],
  ),
  OnboardingSlide(
    title: 'Đặt hàng\nsiêu nhanh',
    subtitle: 'TIỆN LỢI MỌI LÚC',
    description: 'Chỉ vài chạm, ly trà yêu thích của bạn\nsẽ đến tận tay trong thời gian ngắn nhất.',
    imagePath: 'assets/images/onboarding_3.png',
    emoji: '⚡',
    gradientColors: ['#EDE8F5', '#D4C8E8'],
  ),
  OnboardingSlide(
    title: 'Ưu đãi mỗi\nngày cho bạn',
    subtitle: 'TÍCH ĐIỂM & PHẦN THƯỞNG',
    description: 'Mua càng nhiều, nhận quà càng lớn.\nHội viên thân thiết – đặc quyền không giới hạn.',
    imagePath: 'assets/images/onboarding_4.png',
    emoji: '🎁',
    gradientColors: ['#F5EDE8', '#E8D0C4'],
  ),
];
