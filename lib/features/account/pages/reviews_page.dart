import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:vehicle_assistance_vendor/shared/providers/review_provider.dart';

import '../../../shared/widgets/bottom_sheet_appbar.dart';

class ReviewsPage extends ConsumerWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(reviewProviderProvider);
    final theme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        appBar: bottomSheetAppBar(context, "Customer Reviews"),
        body: switch (reviews) {
          AsyncLoading() => const Center(
              child: CupertinoActivityIndicator(),
            ),
          AsyncError(:final error) => Center(child: Text(error.toString())),
          AsyncData(value: final reviews) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: (reviews.isNotEmpty)
                  ? ListView.separated(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              child: Text(
                                reviews[index].userName.substring(0, 1),
                                style: theme.titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reviews[index].userName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        itemSize: 18,
                                        initialRating: reviews[index].rating,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 0.5),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(reviews[index].formattedDate,
                                          style: theme.bodySmall),
                                    ],
                                  ),
                                  Text(
                                    reviews[index].comment,
                                    style: theme.bodyMedium,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      separatorBuilder: (context, index) => const Divider(),
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset("assets/empty.json"),
                          const Text("No Reviews Yet"),
                        ],
                      ),
                    ),
            ),
          _ => const CupertinoActivityIndicator(),
        },
      ),
    );
  }
}
