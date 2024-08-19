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
          "Provide immediate road assistance  to stranded vehicle owners and get paid for your services.",
      image: "assets/car_parts.png",
    ),
    OnboardingItem(
      title: "Schedule Appointments With Clients",
      description:
          "Accept appointment schedules from clients and make some steady income.",
      image: "assets/book.png",
    ),
    OnboardingItem(
      title: "Get Started",
      description:
          "Set up an account with us and let's get you connected to clients effortlessly.",
      image: "assets/get_started.png",
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
                height: 250,
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
                      textAlign: TextAlign.center,
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
