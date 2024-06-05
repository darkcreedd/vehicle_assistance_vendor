import 'package:flutter/material.dart';
import '/features/auth/pages/phone_auth_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  int pageIndex = 0;

  List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      title: "Emergency Vehicle Assistance",
      description:
          "Get immediate help on the road and stay safe with our emergency response features",
      image: "assets/driver.png",
    ),
    OnboardingItem(
      title: "Find & Book Services",
      description:
          "Locate nearby repair shops, painting services, and more for all your vehicle needs",
      image: "assets/car_crash.png",
    ),
    OnboardingItem(
      title: "Easy Booking",
      description:
          "Schedule vehicle services effortlessly for a stress-free experience.",
      image: "assets/driver.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : Colors.grey.shade100,
      body: PageView.builder(
        controller: pageController,
        itemCount: onboardingItems.length,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final onboardingItem = onboardingItems[index];
          return Column(
            children: [
              const Spacer(),
              Image.asset(onboardingItem.image, width: 360),
              const Spacer(),
              Container(
                padding: EdgeInsets.only(
                    top: 30,
                    left: 12,
                    right: 12,
                    bottom: mediaQuery.viewPadding.bottom + 14),
                width: double.maxFinite,
                height: 220,
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1D1F25) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  border: Border.all(
                      color: isDarkMode
                          ? Colors.grey.shade900
                          : Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      onboardingItem.title,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      onboardingItem.description,
                      style: theme.textTheme.bodyMedium?.copyWith(),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.maxFinite,
                      child: FilledButton(
                        onPressed: () {
                          if (pageIndex == 2) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PhoneAuthPage(),
                              ),
                            );
                          }
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn);
                        },
                        child: const Text("Continue"),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;

  OnboardingItem(
      {required this.title, required this.description, required this.image});
}
