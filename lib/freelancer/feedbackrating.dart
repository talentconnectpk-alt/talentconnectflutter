import 'package:flutter/material.dart';

void main() {
  runApp(const Freelancerfeedback());
}

class Freelancerfeedback extends StatelessWidget {
  const Freelancerfeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Freelancer Reviews',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        primaryColor: const Color(0xFF6366F1), // Indigo 500
        cardColor: const Color(0xFF1E293B), // Slate 800
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF818CF8),
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
        ),
        useMaterial3: true,
      ),
      home: const FreelancerReviewsPage(),
    );
  }
}

enum ReviewSort { latest, highest, lowest }

class Review {
  final String id;
  final String client;
  final int rating;
  final String feedback;
  final DateTime date;
  final Color avatarColor;

  Review({
    required this.id,
    required this.client,
    required this.rating,
    required this.feedback,
    required this.date,
    required this.avatarColor,
  });
}

class FreelancerReviewsPage extends StatefulWidget {
  const FreelancerReviewsPage({super.key});

  @override
  State<FreelancerReviewsPage> createState() => _FreelancerReviewsPageState();
}

class _FreelancerReviewsPageState extends State<FreelancerReviewsPage> {
  ReviewSort _selectedSort = ReviewSort.latest;

  // Mock Data
  final List<Review> _allReviews = [
    Review(
      id: '1',
      client: "Rahul S",
      rating: 5,
      feedback: "Excellent work! Delivered before deadline. The code quality was top-notch and communication was seamless.",
      date: DateTime(2026, 2, 2),
      avatarColor: const Color(0xFFE0E7FF), // Light Indigo
    ),
    Review(
      id: '2',
      client: "Ananya M",
      rating: 4,
      feedback: "Good communication and quality work. Would interpret requirements a bit better next time, but overall very satisfied.",
      date: DateTime(2026, 1, 28),
      avatarColor: const Color(0xFFDCFCE7), // Light Green
    ),
    Review(
      id: '3',
      client: "Sneha P",
      rating: 3,
      feedback: "Work was decent but delivery was delayed by two days without prior notice.",
      date: DateTime(2026, 1, 15),
      avatarColor: const Color(0xFFFEE2E2), // Light Red
    ),
    Review(
      id: '4',
      client: "David K",
      rating: 5,
      feedback: "Absolute professional. Solved a complex bug in minutes that others couldn't fix in days.",
      date: DateTime(2025, 12, 20),
      avatarColor: const Color(0xFFFEF9C3), // Light Yellow
    ),
  ];

  List<Review> get sortedReviews {
    List<Review> sorted = List.from(_allReviews);
    switch (_selectedSort) {
      case ReviewSort.highest:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ReviewSort.lowest:
        sorted.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case ReviewSort.latest:
      default:
        sorted.sort((a, b) => b.date.compareTo(a.date));
        break;
    }
    return sorted;
  }

  double get averageRating {
    if (_allReviews.isEmpty) return 0;
    return _allReviews.fold(0, (sum, r) => sum + r.rating) / _allReviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFF0F172A).withOpacity(0.95),
            elevation: 0,
            centerTitle: true,
            title: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF818CF8), Color(0xFFA78BFA)],
              ).createShader(bounds),
              child: const Text(
                "Client Reviews",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverMainAxisGroup(
              slivers: [
                // Summary Card
                if (_allReviews.isNotEmpty)
                  SliverToBoxAdapter(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: SummaryCard(
                              reviews: _allReviews,
                              averageRating: averageRating,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                if (_allReviews.isNotEmpty)
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Filter Header
                if (_allReviews.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recent Feedback",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFCBD5E1), // Slate 300
                          ),
                        ),
                        _buildSortDropdown(),
                      ],
                    ),
                  ),

                if (_allReviews.isNotEmpty)
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // List
                if (_allReviews.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final review = sortedReviews[index];
                        return ReviewCard(
                          review: review,
                          index: index,
                        );
                      },
                      childCount: sortedReviews.length,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReviewSort>(
          value: _selectedSort,
          dropdownColor: const Color(0xFF1E293B),
          icon: const Icon(Icons.swap_vert, size: 18, color: Color(0xFF818CF8)),
          style: const TextStyle(
            color: Color(0xFFE2E8F0),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          items: const [
            DropdownMenuItem(value: ReviewSort.latest, child: Text("Latest")),
            DropdownMenuItem(value: ReviewSort.highest, child: Text("Highest Rated")),
            DropdownMenuItem(value: ReviewSort.lowest, child: Text("Lowest Rated")),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _selectedSort = val);
          },
        ),
      ),
    );
  }
}

// ---------------------------
// COMPONENTS
// ---------------------------

class SummaryCard extends StatelessWidget {
  final List<Review> reviews;
  final double averageRating;

  const SummaryCard({
    super.key,
    required this.reviews,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Big Number
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    StarRating(rating: averageRating.round(), size: 20),
                    const SizedBox(height: 8),
                    Text(
                      "${reviews.length} Reviews",
                      style: const TextStyle(color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Right: Bars
              Expanded(
                flex: 3,
                child: Column(
                  children: [5, 4, 3, 2, 1].map((star) {
                    final count = reviews.where((r) => r.rating.round() == star).length;
                    final pct = reviews.isEmpty ? 0.0 : count / reviews.length;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text(
                            "$star",
                            style: const TextStyle(
                              color: Color(0xFF94A3B8), 
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.star, size: 10, color: Color(0xFF475569)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 6,
                                backgroundColor: const Color(0xFF334155),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 32,
                            child: Text(
                              "${(pct * 100).round()}%",
                              textAlign: TextAlign.end,
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;
  final int index;

  const ReviewCard({
    super.key,
    required this.review,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutQuad,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: review.avatarColor,
                  radius: 20,
                  child: Text(
                    getInitials(review.client),
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.client,
                        style: const TextStyle(
                          color: Color(0xFFF1F5F9), // Slate 100
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${review.date.day}/${review.date.month}/${review.date.year}",
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                StarRating(rating: review.rating, size: 16),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.feedback,
              style: const TextStyle(
                color: Color(0xFFCBD5E1), // Slate 300
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> parts = name.trim().split(" ");
    if (parts.length > 1) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

class StarRating extends StatelessWidget {
  final int rating;
  final double size;

  const StarRating({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star, // Using filled star but changing color
          color: index < rating ? Colors.amber : const Color(0xFF334155),
          size: size,
        );
      }),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: const Icon(
              Icons.rate_review_outlined,
              size: 48,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "No reviews yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF1F5F9),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Client feedback will appear here\nafter completed jobs.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}