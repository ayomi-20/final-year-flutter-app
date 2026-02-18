import 'package:flutter/material.dart';
import 'authentication_screen.dart';

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
        padding: EdgeInsets.all(18),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            // Page 1: title above image
            buildPage(
              image: 'assets/images/onboard1.png',
              title: 'Discover the\nPearl of\nAfrica',
              description:
                  'Explore Uganda`s wildlife,\n culture,\n destinations and travel services,\n all in one app.',
              isTitleAbove: true,
            ),

            // Page 2: default layout (image first)
            buildPage(
              image: 'assets/images/onboard2.png',
              title: 'All in one \nTourism Guide',
              description:
                  'Vehicles for hire\nAccomodations\nRestaurants and cuisine\nTourist Destinations\nCertified Tour Guides',
              isBulleted: true,
            ),
            // Page 3: title + description above image
            buildPage(
              image: 'assets/images/onboard3.png',
              title: 'Plan Your Adventure with Eaze',
              description:
                  'Find Trusted Guides,\n Comfortable Accomodations,\n Reliable Vehicles, and Explore\n destinations by region\n effortlessly.',
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
                  MaterialPageRoute(builder: (_) => AuthenticationScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  'Get Started',
                  style: TextStyle(color: Color(0xFF0F3B2E), fontSize: 20),
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
    List<String> items = description.split('\n');

    return Center(
  child: ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.49, // 👈 KEY CONTROL
    ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "• ",
                  style: TextStyle(fontSize: 20, color: Color(0xFF1C5E4A)),
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
    )
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
            fontSize: 37,
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

      content.add(SizedBox(height: 20));
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
            fontSize: 37,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F3B2E),
          ),
        ),
      );
      content.add(SizedBox(height: 20));
      content.add(Image.asset(image, height: 200));
      // content.add(SizedBox(height: 12));

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
            fontSize: 37,
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
      padding: const EdgeInsets.only(top: 45), // move content upward
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.start, // start = pushes content upward
        crossAxisAlignment: CrossAxisAlignment.center,
        children: content,
      ),
    );
  }
}
