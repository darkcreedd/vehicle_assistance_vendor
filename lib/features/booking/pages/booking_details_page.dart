import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vehicle_assistance_vendor/shared/success_dialog.dart';

import '../../../shared/entities/booking.dart';
import '../../../shared/utils/location.dart';
import '../providers/booking_provider.dart';
import 'view_location_page.dart';

class BookingDetailsPage extends ConsumerStatefulWidget {
  const BookingDetailsPage({
    super.key,
    required this.singleBooking,
  });
  final Booking singleBooking;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingDetailsPageState();
}

class _BookingDetailsPageState extends ConsumerState<BookingDetailsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // list 5 cancellation reaons for booking a mechanical workshop
  final cancellationReasons = [
    "Unforeseen Scheduling Conflict",
    "Specialized Expertise Required",
    "Shop Capacity Constraints",
    "Insufficient Resources",
    "Personal Reasons"
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookingProvider = ref.read(appointmentsProvider.notifier);

    Future<void> cancelBooking(String bookingId) async {
      final result = await showModalBottomSheet<String>(
        context: context,
        builder: (context) {
          return SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      "Why are you cancelling this booking?",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...List.generate(
                    cancellationReasons.length,
                    (index) => SizedBox(
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: OutlinedButton(
                          child: Text(cancellationReasons[index]),
                          onPressed: () {
                            Navigator.pop(context, cancellationReasons[index]);
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (result != null) {
        await bookingProvider.cancelBooking(bookingId, result);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text(widget.singleBooking.userName.substring(0, 1)),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.singleBooking.userName,
                    style: theme.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.singleBooking.phoneNumber),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Icon(Icons.car_crash_outlined),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Vehicle Issue",
                textAlign: TextAlign.start,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            textAlign: TextAlign.start,
            ' ${widget.singleBooking.description}',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(
            height: 20,
          ),
          (widget.singleBooking.imageUrl != null)
              ? Container(
                  height: 200,
                  width: double.maxFinite,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black),
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.singleBooking.imageUrl!),
                )
              : const SizedBox.shrink(),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Icon(IconlyLight.calendar),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Scheduled Date",
                textAlign: TextAlign.start,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            textAlign: TextAlign.start,
            widget.singleBooking.bookingDate,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Icon(Icons.access_time),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Scheduled Time",
                textAlign: TextAlign.start,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            textAlign: TextAlign.start,
            widget.singleBooking.time,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Icon(Icons.time_to_leave_outlined),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Vehicle Details",
                textAlign: TextAlign.start,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            textAlign: TextAlign.start,
            '${widget.singleBooking.vehicle.year} ${widget.singleBooking.vehicle.brand} ${widget.singleBooking.vehicle.model} (${widget.singleBooking.vehicle.gear})',
            style: theme.textTheme.titleSmall,
          ),
          if (widget.singleBooking.status == BookingStatus.pending ||
              widget.singleBooking.status == BookingStatus.confirmed)
            if (widget.singleBooking.status == BookingStatus.pending)
              if (DateTime.parse(widget.singleBooking.date)
                  .isAfter(DateTime.now()))
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.check),
                      onPressed: () async {
                        try {
                          await bookingProvider
                              .acceptBooking(widget.singleBooking.id);
                          print(
                              'booking status ${widget.singleBooking.status}');
                          if (!context.mounted) return;

                          showSuccessDialog(context)
                              .then((value) => Navigator.pop(context));

                          // Navigator.pop(context);
                        } catch (e) {
                          print(
                              'from booking details page, accept booking ${e.toString()}');
                        }
                      },
                      label: const Text("Accept Booking"),
                    ),
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.maxFinite,
            child: OutlinedButton.icon(
              icon: const Icon(IconlyLight.call),
              onPressed: () async {
                launchUrlString('tel:${widget.singleBooking.phoneNumber}');
              },
              label: Text("Call ${widget.singleBooking.userName}"),
            ),
          ),
          if (DateTime.parse(widget.singleBooking.date).isAfter(DateTime.now()))
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: double.maxFinite,
                child: OutlinedButton.icon(
                  icon: const Icon(IconlyLight.location),
                  onPressed: () async {
                    try {
                      final userLocation = await determinePosition();
                      if (!context.mounted) return;

                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LiveTrackingMap(
                            sourceLatitude: userLocation.latitude,
                            sourceLongitude: userLocation.longitude,
                            destinationLatitude: widget.singleBooking.userLat,
                            destinationLongitude: widget.singleBooking.userLong,
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                              content: Text("Allow location permission")),
                        );
                    }
                  },
                  label:
                      Text("View ${widget.singleBooking.userName}'s Location"),
                ),
              ),
            ),
          if (widget.singleBooking.status == BookingStatus.pending ||
              widget.singleBooking.status == BookingStatus.confirmed)
            if (DateTime.parse(widget.singleBooking.date)
                .isAfter(DateTime.now()))
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () async {
                      try {
                        Navigator.pop(context);
                        await cancelBooking(widget.singleBooking.id);
                      } catch (e) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                      }
                    },
                    label: const Text("Cancel Appointment"),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
