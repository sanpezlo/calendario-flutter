import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/secondary_button.dart';
import 'package:calendario_flutter/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:expandable_page_view/expandable_page_view.dart';

class OnBoardingPage extends StatefulWidget {
  static const String id = "/on_boarding";

  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              "assets/logo_color_unicesmag.png",
              scale: 1.5,
            ),
          ),
          ExpandablePageView.builder(
            itemCount: pageViewList.length,
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingCard(
                currentIndex: index,
              );
            },
          ),
        ],
      ),
      bottomSheet: Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 32, right: 32, bottom: 16),
        child: SecondaryButton(
          onPressed: () {
            if (_currentIndex == pageViewList.length - 1) {
              Navigator.pushReplacementNamed(context, LoginPage.id);
            } else {
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );
            }
          },
          text: _currentIndex == pageViewList.length - 1
              ? 'Empezar'
              : 'Continuar',
        ),
      ),
    );
  }
}

class OnboardingCard extends StatelessWidget {
  final int currentIndex;

  const OnboardingCard({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppColor.alternative,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
              child: Text(
                pageViewList[currentIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 112),
              child: DotsIndicator(
                dotsCount: pageViewList.length,
                position: currentIndex,
                decorator: DotsDecorator(
                  color: Colors.grey.withOpacity(0.5),
                  size: const Size.square(8.0),
                  activeSize: const Size(20.0, 8.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  activeColor: AppColor.primary,
                ),
              ),
            ),
          ],
        ));
  }
}

List<String> pageViewList = [
  'Your Favorite Books. Anytime, Anywhere. Listen and Read with ListenLit.',
  'Experience Your Favorite Audio Books Like Never Before with ListenLit.',
  "Immerse Yourself in Your Favorite Books with ListenLit's     Premium Audio books.",
];
