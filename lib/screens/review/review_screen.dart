import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import '../../common/theme/app_theme.dart';
import '../../data/models/review_model.dart';

class ReviewScreen extends StatefulWidget {
  final String productId;
  final String productName;

  const ReviewScreen({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final DatabaseReference _reviewsRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://vs6451071059-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref().child('reviews');

  double _averageRating = 0;
  int _totalReviews = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text('Đánh giá sản phẩm',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.darkBrown, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _reviewsRef.orderByChild('productId').equalTo(widget.productId).onValue,
        builder: (context, snapshot) {
          List<ReviewModel> reviews = [];

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            data.forEach((key, value) {
              reviews.add(ReviewModel.fromJson(value as Map<dynamic, dynamic>));
            });
            reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            if (reviews.isNotEmpty) {
              _averageRating = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
              _totalReviews = reviews.length;
            }
          }

          return Column(
            children: [
              // Header: Product name + Average rating
              _buildRatingHeader(reviews),

              // Reviews list
              Expanded(
                child: reviews.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) => _buildReviewCard(reviews[index]),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReviewDialog(context),
        backgroundColor: AppColors.milkTea,
        icon: const Icon(Icons.rate_review_rounded, color: AppColors.white),
        label: const Text('Viết đánh giá', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildRatingHeader(List<ReviewModel> reviews) {
    final Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var r in reviews) {
      distribution[r.rating.round()] = (distribution[r.rating.round()] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.darkBrown.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          Text(widget.productName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBrown),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Row(
            children: [
              // Average rating
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(_averageRating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: AppColors.milkTea)),
                    _buildStarRow(_averageRating, size: 20),
                    const SizedBox(height: 4),
                    Text('$_totalReviews đánh giá', style: TextStyle(fontSize: 13, color: AppColors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Distribution bars
              Expanded(
                flex: 3,
                child: Column(
                  children: List.generate(5, (index) {
                    final star = 5 - index;
                    final count = distribution[star] ?? 0;
                    final percent = _totalReviews > 0 ? count / _totalReviews : 0.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text('$star', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          const Icon(Icons.star_rounded, size: 14, color: AppColors.milkTea),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: percent,
                                backgroundColor: AppColors.tapioca.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.milkTea),
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(width: 24, child: Text('$count', style: TextStyle(fontSize: 12, color: AppColors.grey))),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: AppColors.tapioca.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.rate_review_outlined, size: 48, color: AppColors.milkTea),
          ),
          const SizedBox(height: 24),
          const Text('Chưa có đánh giá', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Hãy là người đầu tiên đánh giá sản phẩm này!', style: TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.darkBrown.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.tapioca,
                radius: 20,
                child: Text(review.userName[0].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    _buildStarRow(review.rating, size: 14),
                  ],
                ),
              ),
              Text(_getTimeAgo(review.createdAt), style: TextStyle(fontSize: 11, color: AppColors.grey)),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(review.comment, style: TextStyle(fontSize: 14, color: AppColors.darkGrey, height: 1.5)),
          ],
        ],
      ),
    );
  }

  Widget _buildStarRow(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star_rounded, color: AppColors.milkTea, size: size);
        } else if (index < rating) {
          return Icon(Icons.star_half_rounded, color: AppColors.milkTea, size: size);
        }
        return Icon(Icons.star_outline_rounded, color: AppColors.tapioca, size: size);
      }),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    double selectedRating = 5;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.tapioca, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              const Text('Đánh giá sản phẩm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Star rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setModalState(() => selectedRating = index + 1.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index < selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: AppColors.milkTea,
                        size: 40,
                      ),
                    ),
                  );
                }),
              ),
              Text(_getRatingText(selectedRating), style: TextStyle(color: AppColors.grey, fontSize: 13)),
              const SizedBox(height: 20),

              // Comment
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Chia sẻ trải nghiệm của bạn...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.tapioca)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.milkTea, width: 2)),
                  filled: true,
                  fillColor: AppColors.offWhite,
                ),
              ),
              const SizedBox(height: 20),

              // Submit
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    final review = ReviewModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      userId: user?.uid ?? 'guest',
                      userName: user?.displayName ?? user?.email?.split('@')[0] ?? 'Ẩn danh',
                      productId: widget.productId,
                      productName: widget.productName,
                      orderId: '',
                      rating: selectedRating,
                      comment: commentController.text.trim(),
                    );
                    await _reviewsRef.child(review.id).set(review.toJson());
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cảm ơn bạn đã đánh giá!'), backgroundColor: Colors.green),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.milkTea,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Gửi đánh giá', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText(double rating) {
    if (rating >= 5) return 'Tuyệt vời! ⭐';
    if (rating >= 4) return 'Rất tốt 👍';
    if (rating >= 3) return 'Bình thường 😐';
    if (rating >= 2) return 'Chưa hài lòng 😕';
    return 'Rất tệ 😞';
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}p trước';
    if (diff.inHours < 24) return '${diff.inHours}h trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}
