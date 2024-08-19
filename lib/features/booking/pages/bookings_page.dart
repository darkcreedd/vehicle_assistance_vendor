import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../shared/entities/booking.dart';
import '../providers/booking_provider.dart';
import 'booking_details_page.dart';

class BookingsPage extends ConsumerStatefulWidget {
  const BookingsPage({super.key});

  @override
  ConsumerState createState() => _BookingsPageState();
}

class _BookingsPageState extends ConsumerState<BookingsPage> {
  List<BookingTab> bookingTabs = [
    const BookingTab(title: "Pending", status: BookingStatus.pending),
    const BookingTab(title: "Upcoming", status: BookingStatus.confirmed),
    const BookingTab(title: "Past", status: BookingStatus.past),
    const BookingTab(title: "Cancelled", status: BookingStatus.cancelled),
  ];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  @override
  Widget build(BuildContext context) {
    final bookingsProvider = ref.watch(appointmentsProvider);
    final theme = Theme.of(context);

    return DefaultTabController(
      length: bookingTabs.length,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("My Appointments"),
          bottom: TabBar(
            // isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            tabAlignment: TabAlignment.fill,
            tabs: List.generate(bookingTabs.length,
                (index) => Tab(text: bookingTabs[index].title)),
          ),
        ),
        body: switch (bookingsProvider) {
          AsyncData(value: final bookings) => TabBarView(
              children: List.generate(
                bookingTabs.length,
                (index) {
                  final status = bookingTabs[index].status;
                  List<Booking> bookingType = [];
                  if (status == BookingStatus.past) {
                    bookingType = bookings
                        .where((booking) => DateTime.parse(booking.date)
                            .isBefore(DateTime.now()))
                        .toList();
                  } else {
                    bookingType = bookings.where((booking) {
                      return booking.status == status &&
                          DateTime.parse(booking.date).isAfter(DateTime.now());
                    }).toList();
                  }

                  bookingType.sort((a, b) =>
                      DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
                  if (bookingType.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Lottie.asset("assets/empty.json"),
                          const SizedBox(height: 20),
                          Text(
                            "No ${bookingTabs[index].title} appointments",
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    edgeOffset: 20,
                    onRefresh: () async => ref.invalidate(appointmentsProvider),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: bookingType.length,
                      itemBuilder: (context, index) {
                        final singleBooking = bookingType[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(singleBooking.userName.substring(0, 1)),
                          ),
                          title: Text(singleBooking.userName),
                          titleTextStyle: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          subtitle: Text(
                              "${singleBooking.bookingDate} at ${singleBooking.time}"),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return BookingDetailsPage(
                                  singleBooking: singleBooking,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          AsyncError(:final error) => Center(
              child: Text(error.toString()),
            ),
          _ => const Center(
              child: CupertinoActivityIndicator(),
            )
        },
      ),
    );
  }
}

class BookingTab {
  final String title;
  final BookingStatus status;

  const BookingTab({
    required this.title,
    required this.status,
  });
}
