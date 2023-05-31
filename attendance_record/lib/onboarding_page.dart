import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'attendance_list_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

Widget buildPage({
  required String urlImage,
  required String subtitle,
  required double  subtitleFontSize,
}) =>
    Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: SizedBox(
          width: 500,
          height: 500,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.green.shade100,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        urlImage,
                        width: 300, // Adjust the width of the image
                        height: 300, // Adjust the height of the image
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Colors.green,
                          fontSize: subtitleFontSize,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    ));

class OnboardingPageState extends State<OnboardingPage> {
  PageController pageController = PageController();
  int currentPage = 0;
  
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 500,
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              buildPage(
                urlImage: 'assets/page1.jpg',
                subtitle: "Welcome ~ !",
                subtitleFontSize: 26,
              ),
              buildPage(
                urlImage: 'assets/page2.jpg',
                subtitle: "Our system will show the recorded attendance for you in an intuitive way!",
                subtitleFontSize: 20,
              ),
              buildPage(
                urlImage: 'assets/page3.jpg',
                subtitle: "Not only that, you can add new attendance using our system ~",
                subtitleFontSize: 20,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentPage != 2)
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: 3,
                      effect: WormEffect(
                        spacing: 16,
                        dotColor: Colors.black26,
                        activeDotColor: Colors.teal.shade700,
                      ),
                      onDotClicked: (index) => pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      ),
                    ),
                  ),
                ),
              if (currentPage == 2)
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text('Start'),
                      onPressed: () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const AttendanceListScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}