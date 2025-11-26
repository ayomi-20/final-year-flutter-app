import 'package:flutter/material.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            // Page 1: title above image
            buildPage(
              image: 'assets/images/onboard1.png',
              title: 'Discover the Pearl Of Africa',
              description:
                  'Explore Uganda`s wildlife, culture, destinations and travel services, all in one app.',
              isTitleAbove: true,
            ),

            // Page 2: default layout (image first)
            buildPage(
              image: 'assets/images/onboard2.png',
              title: 'All in one Tourism Guide',
              description:
                  'Vehicles for hire;Accomodations;Restaurants and cuisine;Tourist Destinations;Certified Tour Guides',
              isBulleted: true,
            ),
            // Page 3: title + description above image
            buildPage(
              image: 'assets/images/onboard3.png',
              title: 'Plan Your Adventure with Eaze',
              description:
                  'Find Trusted Guides, Comfortable Accomodations, Reliable Vehicles, and Explore destinations by regions effortlessly.',
              isTitleAndDescAbove: true,
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  'Get Started',
                  style: TextStyle(color:Color(0xFF0F3B2E), fontSize: 20),
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                _controller.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Swipe to continue   ',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF0F3B2E),
                      ),
                    ),
                    Text(
                      '----------->',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F3B2E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }


  Widget buildBullets(String description) {
  List<String> items = description.split(';');

  return Align(
    alignment: Alignment.center, // center horizontally
    child: FractionallySizedBox(
      widthFactor: 0.2, // take 75% of the width (pushes bullets inward)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "• ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF1C5E4A),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.trim(),
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 20,
                      color: Color(0xFF1C5E4A),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ),
  );
}


 Widget buildPage({
  required String image,
  required String title,
  required String description,
  bool isTitleAbove = false,
  bool isTitleAndDescAbove = false,
  bool isBulleted = false,
}) {
  List<Widget> content = [];

  // CASE 1: Title + description ABOVE image
  if (isTitleAndDescAbove) {
    content.add(
      Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'IBMPlexSerif',
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: Color(0xFF0F3B2E),
        ),
      ),
    );
    content.add(SizedBox(height: 12));

    // description (NOT bullets)
    content.add(
      Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'CormorantGaramond',
          fontSize: 24,
          fontWeight: FontWeight.w300,
          color: Color(0xFF1C5E4A),
        ),
      ),
    );

    content.add(SizedBox(height: 15));
    content.add(Image.asset(image, height: 200));
  }

  // CASE 2: Title ABOVE image (Page 1)
  else if (isTitleAbove) {
    content.add(
      Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'IBMPlexSerif',
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: Color(0xFF0F3B2E),
        ),
      ),
    );
    content.add(SizedBox(height: 20));
    content.add(Image.asset(image, height: 200));
    content.add(SizedBox(height: 15));

    // description (NOT bullets on page 1)
    content.add(
      Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'CormorantGaramond',
          fontSize: 24,
          fontWeight: FontWeight.w300,
          color: Color(0xFF1C5E4A),
        ),
      ),
    );
  }

  // CASE 3: Default layout (Page 2)
  else {
    content.add(Image.asset(image, height: 200));
    content.add(SizedBox(height: 20));

    content.add(
      Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'IBMPlexSerif',
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: Color(0xFF0F3B2E),
        ),
      ),
    );
    content.add(SizedBox(height: 15));

    if (isBulleted) {
      content.add(buildBullets(description)); // centered bullets
    } else {
      content.add(
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 24,
            fontWeight: FontWeight.w300,
            color: Color(0xFF1C5E4A),
          ),
        ),
      );
    }
  }

  return Padding(
  padding: const EdgeInsets.only(top: 60), // move content upward
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start, // start = pushes content upward
    crossAxisAlignment: CrossAxisAlignment.center,
    children: content,
  ),
);
}
}