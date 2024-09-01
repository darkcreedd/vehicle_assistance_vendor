// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_assistance_vendor/features/booking/providers/booking_provider.dart';
import 'package:vehicle_assistance_vendor/shared/providers/bottom_tab_provider.dart';
import 'package:vehicle_assistance_vendor/shared/utils/location.dart';

import '../../../shared/entities/booking.dart';
import '../../../shared/providers/account_provider.dart';
import '../../auth/controllers/auth_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    determinePosition();
    final userAsync = ref.watch(accountProvider);
    final bookingsAsync = ref.watch(appointmentsProvider);

    final theme = Theme.of(context);
    Map<DateTime, List<Booking>> groupBookingsByDate(List<Booking> bookings) {
      Map<DateTime, List<Booking>> groupedBookings = {};

      for (var booking in bookings) {
        final bookingDate = DateTime.parse(booking.date);
        final date =
            DateTime(bookingDate.year, bookingDate.month, bookingDate.day);

        if (groupedBookings.containsKey(date)) {
          groupedBookings[date]!.add(booking);
        } else {
          groupedBookings[date] = [booking];
        }
      }

      return groupedBookings;
    }

    int countConfirmedBookings(List<Booking> bookings) {
      return bookings.where((booking) {
        final bookingDate = DateTime.parse(booking.date);
        final now = DateTime.now();
        return booking.status == BookingStatus.confirmed &&
            bookingDate.isAfter(now);
      }).length;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0,
          title: switch (userAsync) {
            AsyncData(value: final user) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      ref.read(bottomTabProvider.notifier).setTab(3);
                    },
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(user.image),
                    ),
                  ),
                  Text(user.workshopName)
                ],
              ),
            AsyncError() => const CircleAvatar(
                backgroundColor: Colors.black,
              ),
            _ => const Center(
                child: CupertinoActivityIndicator(),
              )
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My dashboard",
                style: theme.textTheme.displaySmall!
                    .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              switch (bookingsAsync) {
                AsyncData(value: final bookings) => Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: HomeContainer(
                          icon: Icons.insert_chart,
                          value: bookings.length,
                          label: "Total Bookings",
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: HomeContainer(
                          icon: IconlyLight.activity,
                          value: countConfirmedBookings(bookings),
                          label: "Upcoming Bookings",
                          color: Colors.amber.shade700,
                        ),
                      )
                    ],
                  ),
                AsyncError() => const CircleAvatar(
                    backgroundColor: Colors.black,
                  ),
                _ => const Center(
                    child: CupertinoActivityIndicator(),
                  )
              },
              const SizedBox(
                height: 35,
              ),
              Text(
                "Completed Jobs",
                style: theme.textTheme.displaySmall!
                    .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: bookingsAsync.when(
                  data: (final bookings) {
                    final groupedBookings = groupBookingsByDate(bookings);
                    final filteredBookings =
                        groupedBookings.map((date, bookings) => MapEntry(
                              date,
                              bookings
                                  .where((booking) =>
                                      booking.status == BookingStatus.confirmed)
                                  .toList(),
                            ));

                    if (filteredBookings.values
                        .any((bookings) => bookings.isNotEmpty)) {
                      return ListView(
                        children: filteredBookings.entries
                            .where((entry) => entry.value.isNotEmpty)
                            .map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(DateFormat('MMMM d').format(entry.key)),
                              const SizedBox(
                                height: 10,
                              ),
                              ListView(
                                padding: const EdgeInsets.only(bottom: 20),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: entry.value.map((booking) {
                                  return GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(bottomTabProvider.notifier)
                                          .setTab(1);
                                    },
                                    child: Container(
                                      height: 60,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        color: Colors.grey.shade200,
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            child: Text(
                                              booking.userName.substring(0, 1),
                                              style: theme.textTheme.bodyLarge!
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  booking.userName,
                                                  style: theme
                                                      .textTheme.bodyMedium!
                                                      .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    booking.description,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme.bodyMedium!
                                                        .copyWith(
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/mechanic.png')),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await AuthController.logout();
                              },
                              child: Text(
                                "You have no completed jobs",
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(fontStyle: FontStyle.italic),
                              ),
                            )
                          ],
                        ),
                      ); // replace with your image asset
                    }
                  },
                  error: (e, _) => const CircleAvatar(
                    backgroundColor: Colors.black,
                  ),
                  loading: () => const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContainer extends StatelessWidget {
  const HomeContainer({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color = Colors.green,
  });
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300.withOpacity(0.6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: color,
          ),
          const SizedBox(height: 10),
          Text(
            label.toUpperCase(),
            style: theme.textTheme.bodySmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: theme.textTheme.titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
