import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

import '../../../shared/providers/account_provider.dart';
import '/features/auth/pages/phone_auth_page.dart';
import '../../auth/controllers/auth_controller.dart';
import '/features/account/pages/reviews_page.dart';
import '/features/account/pages/workshop_details.dart';
import '/features/account/pages/about_us_page.dart';
import 'edit_profile_page.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(accountProvider);
    print("This is user ${user.value}");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("My Account"),
      ),
      body: SafeArea(
        child: switch (user) {
          AsyncLoading() => const Center(
              child: CupertinoActivityIndicator(),
            ),
          AsyncError(:final error) => Center(child: Text(error.toString())),
          AsyncData(value: final user) => ListView(
              padding: const EdgeInsets.only(top: 16),
              children: [
                ListTile(
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const EditProfilePage();
                      },
                    );
                  },
                  titleTextStyle: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  title: Text(user.workshopName),
                  trailing: const Icon(IconlyLight.edit),
                  leading: CircleAvatar(
                    radius: 25,
                    foregroundImage: CachedNetworkImageProvider(user.image),
                  ),
                  subtitle: Text(user.phone),
                ),
                const SizedBox(height: 15),
                ListTile(
                  leading: const Icon(Icons.home_work_outlined),
                  title: const Text("My WorkShop"),
                  titleTextStyle: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  trailing: const Icon(IconlyLight.arrowRight3),
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const MyWorkShopPage();
                      },
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(CupertinoIcons.star),
                  title: const Text("Reviews"),
                  titleTextStyle: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  trailing: const Icon(IconlyLight.arrowRight3),
                  onTap: () {
                    showBarModalBottomSheet(
                        context: context, builder: (_) => const ReviewsPage());
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(CupertinoIcons.heart),
                  title: const Text("Tell a Friend"),
                  titleTextStyle: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  trailing: const Icon(IconlyLight.arrowRight3),
                  onTap: () {
                    Share.share(
                      "Share this amazing app with your friends!",
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(CupertinoIcons.info),
                  title: const Text("About Us"),
                  titleTextStyle: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  trailing: const Icon(IconlyLight.arrowRight3),
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const AboutUsPage();
                      },
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(IconlyLight.logout),
                  title: const Text("Logout"),
                  titleTextStyle: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  trailing: const Icon(IconlyLight.arrowRight3),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          surfaceTintColor: Colors.transparent,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(IconlyLight.logout, color: Colors.red),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Logout',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 50),
                          content: const Text(
                            'Do you really want to logout?',
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Logout',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.red),
                              ),
                              onPressed: () async {
                                // Add your logout code here
                                await AuthController.logout().then((value) =>
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PhoneAuthPage()),
                                        (route) => false));
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          _ => const CupertinoActivityIndicator(),
        },
      ),
    );
  }
}
