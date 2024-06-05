import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../shared/widgets/bottom_sheet_appbar.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bottomSheetAppBar(context, "Customer Reviews"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 25,
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Appleseed",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            itemSize: 18,
                            initialRating: Random().nextInt(3) + 3.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 0.5),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("${Random().nextInt(3) + 5} months ago"),
                        ],
                      ),
                      const Text(
                          "Excellent services and a good customer relationship")
                    ],
                  ),
                ),
              ],
            ),
          ),
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }
}
