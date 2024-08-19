// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vehicle_assistance_vendor/features/booking/providers/booking_provider.dart';
import 'package:vehicle_assistance_vendor/features/booking/providers/emergency_request_provider.dart';
import 'package:vehicle_assistance_vendor/features/emergency/emergency_request_details_page.dart';
import 'package:vehicle_assistance_vendor/shared/entities/emergency_request.dart';
import 'package:vehicle_assistance_vendor/shared/utils/location.dart';

import '../../../shared/entities/booking.dart';
import '../../../shared/providers/account_provider.dart';
import '../../auth/controllers/auth_controller.dart';

// class HomePage extends ConsumerWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // ignore: unused_local_variable
//     final user = ref.watch(accountProvider);
//     final bookingsProvider = ref.watch(appointmentsProvider);
//     final emergencyProvider = ref.watch(onGoingEmergencyProvider);

//     final theme = Theme.of(context);
//     bool checker(List<Booking> bookings) {
//       bool hasConfirmedBooking = bookings.any((booking) {
//         final bookingDate = DateTime.parse(booking.date);
//         final now = DateTime.now();
//         return booking.status == BookingStatus.confirmed &&
//             bookingDate.isAfter(now);
//       });
//       return hasConfirmedBooking;
//     }

//     int countConfirmedBookings(List<Booking> bookings) {
//       return bookings.where((booking) {
//         final bookingDate = DateTime.parse(booking.date);
//         final now = DateTime.now();
//         return booking.status == BookingStatus.confirmed &&
//             bookingDate.isAfter(now);
//       }).length;
//     }

//     return SafeArea(
//       child: Scaffold(
//         body: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             SizedBox(
//               height: 250,
//               child: Card.filled(
//                 color: Colors.grey.shade200,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.only(top: 16.0, left: 16, right: 16),
//                   child: switch (bookingsProvider) {
//                     AsyncData(value: final bookings) => (checker(bookings))
//                         ? RefreshIndicator.adaptive(
//                             edgeOffset: 20,
//                             onRefresh: () async =>
//                                 ref.invalidate(appointmentsProvider),
//                             child: ListView.separated(
//                               itemCount: countConfirmedBookings(bookings),
//                               itemBuilder: (context, index) => Container(
//                                 margin:
//                                     const EdgeInsets.only(bottom: 10, top: 10),
//                                 height: 40,
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       bookings[index].userName,
//                                       style: theme.textTheme.bodyMedium!
//                                           .copyWith(
//                                               fontWeight: FontWeight.bold),
//                                     ),
//                                     Expanded(
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Row(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                             children: [
//                                               Icon(
//                                                 IconlyLight.calendar,
//                                                 color: Colors.black
//                                                     .withOpacity(.5),
//                                               ),
//                                               const SizedBox(
//                                                 width: 5,
//                                               ),
//                                               Text(
//                                                 bookings[index].bookingDate,
//                                                 style:
//                                                     theme.textTheme.bodySmall,
//                                               ),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               Icon(
//                                                 Icons.access_time,
//                                                 color: Colors.black
//                                                     .withOpacity(.5),
//                                               ),
//                                               Text(
//                                                 bookings[index].time,
//                                                 style:
//                                                     theme.textTheme.bodySmall,
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               separatorBuilder: (context, index) =>
//                                   const Divider(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           )
//                         : Center(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 SizedBox(
//                                   height: 120,
//                                   width: 120,
//                                   child: Image.asset(
//                                       fit: BoxFit.cover,
//                                       "assets/no_schedules.png"),
//                                 ),
//                                 const Text(
//                                   "No upcoming schedules",
//                                 )
//                               ],
//                             ),
//                           ),
//                     AsyncError(:final error) => Center(
//                         child: Text(error.toString()),
//                       ),
//                     _ => const Center(
//                         child: CupertinoActivityIndicator(),
//                       )
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 200,
//               child: Card.filled(
//                 color: Colors.grey.shade200,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: PieChart(
//                           PieChartData(
//                             pieTouchData: PieTouchData(
//                               touchCallback:
//                                   (FlTouchEvent event, pieTouchResponse) {},
//                             ),
//                             borderData: FlBorderData(
//                               show: false,
//                             ),
//                             sectionsSpace: 0,
//                             centerSpaceRadius: 0,
//                             sections: showingSections(),
//                           ),
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ChartKeys(
//                             color: Colors.red.withOpacity(.8),
//                             label: "Pending",
//                           ),
//                           ChartKeys(
//                             color: Colors.green.withOpacity(.9),
//                             label: "Upcoming",
//                           ),
//                           const ChartKeys(
//                             color: Colors.grey,
//                             label: "Past",
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 200,
//               child: Card.filled(
//                 color: Colors.grey.shade200,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: switch (emergencyProvider) {
//                     AsyncData(value: final emergency) => (emergency != null &&
//                             emergency.status == EmergencyStatus.pending)
//                         ? RefreshIndicator.adaptive(
//                             edgeOffset: 20,
//                             onRefresh: () async =>
//                                 ref.invalidate(onGoingEmergencyProvider),
//                             child: GestureDetector(
//                               behavior: HitTestBehavior.opaque,
//                               onTap: () {
//                                 showCupertinoModalBottomSheet(
//                                     context: context,
//                                     builder: (context) =>
//                                         EmergencyRequestDetailsPage(
//                                           emergencyDetails: emergency,
//                                         ));
//                               },
//                               child: const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text("Emergency Alert from"),
//                                   Text("User Name"),
//                                   Text("Vehicle Details"),
//                                   Text("Description")
//                                 ],
//                               ),
//                             ))
//                         : const Center(
//                             child: Text("No emergency request received"),
//                           ),
//                     AsyncError(:final error) => Center(
//                         child: Text(error.toString()),
//                       ),
//                     _ => const Center(
//                         child: CupertinoActivityIndicator(),
//                       )
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChartKeys extends StatelessWidget {
//   const ChartKeys({
//     super.key,
//     required this.label,
//     required this.color,
//   });
//   final String label;
//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 8,
//             backgroundColor: color,
//           ),
//           const SizedBox(
//             width: 8,
//           ),
//           Text(label)
//         ],
//       ),
//     );
//   }
// }

// class ChartData {
//   ChartData(this.x, this.y, [this.color]);
//   final String x;
//   final double y;
//   final Color? color;
// }

// List<PieChartSectionData> showingSections() {
//   double radius = 60;
//   return List.generate(
//     3,
//     (i) {
//       switch (i) {
//         case 0:
//           return PieChartSectionData(
//               color: Colors.green.withOpacity(.8),
//               value: 30,
//               title: '',
//               radius: radius,
//               borderSide: const BorderSide(color: Colors.white));
//         case 1:
//           return PieChartSectionData(
//             color: Colors.grey,
//             value: 30,
//             title: 'Past',
//             showTitle: false,
//             radius: radius,
//             borderSide: const BorderSide(color: Colors.white),
//           );
//         case 2:
//           return PieChartSectionData(
//             color: Colors.red.withOpacity(.8),
//             value: 30,
//             title: 'Pending',
//             showTitle: false,
//             radius: radius,
//             borderSide: const BorderSide(color: Colors.white),
//           );

//         default:
//           throw Error();
//       }
//     },
//   );
// }

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    determinePosition();
    final userAsync = ref.watch(accountProvider);
    final bookingsAsync = ref.watch(appointmentsProvider);
    final emergencyProvider = ref.watch(onGoingEmergencyProvider);

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
          centerTitle: false,
          title: switch (userAsync) {
            AsyncData(value: final user) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(user.image),
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
              GestureDetector(
                onTap: () async {
                  await AuthController.logout();
                },
                child: Text(
                  "Completed Jobs",
                  style: theme.textTheme.displaySmall!
                      .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                ),
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
                                  return Container(
                                    height: 70,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 27,
                                          backgroundColor: Colors.black,
                                          child: Text(
                                            booking.userName.substring(0, 1),
                                            style: theme.textTheme.bodyLarge!
                                                .copyWith(
                                              color: Colors.white,
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
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
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
