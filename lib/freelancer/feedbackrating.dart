import 'package:flutter/material.dart';

enum ReviewSort { latest, highest, lowest }

class FreelancerReviewsPage extends StatefulWidget {
  const FreelancerReviewsPage({super.key});

  @override
  State<FreelancerReviewsPage> createState() => _FreelancerReviewsPageState();
}

class _FreelancerReviewsPageState extends State<FreelancerReviewsPage> {
  ReviewSort _selectedSort = ReviewSort.latest;

  // 🔹 Empty this list to see empty state UI
  List<Map<String, dynamic>> reviews = [
    {
      "client": "Rahul S",
      "rating": 5,
      "feedback": "Excellent work! Delivered before deadline.",
      "date": DateTime(2026, 2, 2),
    },
    {
      "client": "Ananya M",
      "rating": 4,
      "feedback": "Good communication and quality work.",
      "date": DateTime(2026, 1, 28),
    },
    {
      "client": "Sneha P",
      "rating": 3,
      "feedback": "Work was decent but delivery was delayed.",
      "date": DateTime(2026, 1, 15),
    },
  ];

  List<Map<String, dynamic>> get sortedReviews {
    List<Map<String, dynamic>> sorted = List.from(reviews);

    switch (_selectedSort) {
      case ReviewSort.highest:
        sorted.sort((a, b) => b["rating"].compareTo(a["rating"]));
        break;
      case ReviewSort.lowest:
        sorted.sort((a, b) => a["rating"].compareTo(b["rating"]));
        break;
      case ReviewSort.latest:
        sorted.sort((a, b) => b["date"].compareTo(a["date"]));
        break;
    }
    return sorted;
  }

  double get averageRating {
    if (reviews.isEmpty) return 0;
    double total = reviews.fold(0, (sum, r) => sum + r["rating"]);
    return total / reviews.length;
  }

  Widget buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.rate_review_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No reviews yet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            "Client feedback will appear here after completed jobs.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Client Reviews"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: reviews.isEmpty
            ? buildEmptyState()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ⭐ Rating Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildStars(averageRating.round()),
                            const SizedBox(height: 4),
                            Text("${reviews.length} reviews"),
                          ],
                        ),
                        const Spacer(),

                        // 🔽 Sort Dropdown
                        DropdownButton<ReviewSort>(
                          value: _selectedSort,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                              value: ReviewSort.latest,
                              child: Text("Latest"),
                            ),
                            DropdownMenuItem(
                              value: ReviewSort.highest,
                              child: Text("Highest"),
                            ),
                            DropdownMenuItem(
                              value: ReviewSort.lowest,
                              child: Text("Lowest"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedSort = value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🧾 Review List
                  Expanded(
                    child: ListView.builder(
                      itemCount: sortedReviews.length,
                      itemBuilder: (context, index) {
                        final review = sortedReviews[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    review["client"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "${review["date"].day}/${review["date"].month}/${review["date"].year}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              buildStars(review["rating"]),

                              const SizedBox(height: 8),

                              Text(review["feedback"]),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
