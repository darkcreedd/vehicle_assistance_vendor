import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

import '/features/account/pages/reviews_page.dart';
import '/features/account/pages/edit_profile_page.dart';
import '/features/account/pages/workshop_details.dart';
import '/features/account/pages/about_us_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: ListView(
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
            title: const Text("John Appleseed"),
            trailing: const Icon(IconlyLight.edit),
            leading: const CircleAvatar(
              radius: 25,
              foregroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1580273916550-e323be2ae537?q=80&w=2160&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              ),
            ),
            subtitle: const Text("+233 55 555 5555"),
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
            leading: const Icon(IconlyLight.star),
            title: const Text("Customer Reviews"),
            titleTextStyle: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            trailing: const Icon(IconlyLight.arrowRight3),
            onTap: () {
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) {
                  return const ReviewsPage();
                },
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
            leading: const Icon(CupertinoIcons.heart),
            title: const Text("Tell a Friend"),
            titleTextStyle: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            trailing: const Icon(IconlyLight.arrowRight3),
            onTap: () {
              Share.share("Check out our project work!");
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
                        onPressed: () {
                          // Add your logout code here
                          Navigator.of(context).pop();
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
    );
  }
}
