import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_assistance_vendor/shared/entities/rating.dart';

import '../utils/constants.dart';

part 'review_provider.g.dart';

@riverpod
class ReviewProvider extends _$ReviewProvider {
  @override
  FutureOr<List<Rating>> build() async {
    final reviewsCollection = db
        .collection('ratings')
        .where('providerId', isEqualTo: auth.currentUser?.uid);
    final reviewsSnapshot = await reviewsCollection.get();
    return reviewsSnapshot.docs
        .map((doc) => Rating.fromMap(doc.data()))
        .toList();
  }
}
