// import 'package:flutter/material.dart';
// import 'authentication_screen.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _controller = PageController();
//   bool isLastPage = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(18),
//         child: PageView(
//           controller: _controller,
//           onPageChanged: (index) {
//             setState(() => isLastPage = index == 2);
//           },
//           children: [
//             // Page 1: title above image
//             buildPage(
//               image: 'assets/images/onboard1.png',
//               title: 'Discover the\nPearl of\nAfrica',
//               description:
//                   'Explore Uganda`s wildlife,\n culture,\n destinations and travel services,\n all in one app.',
//               isTitleAbove: true,
//             ),

//             // Page 2: default layout (image first)
//             buildPage(
//               image: 'assets/images/onboard2.png',
//               title: 'All in one \nTourism Guide',
//               description:
//                   'Vehicles for hire\nAccomodations\nRestaurants and cuisine\nTourist Destinations\nCertified Tour Guides',
//               isBulleted: true,
//             ),
//             // Page 3: title + description above image
//             buildPage(
//               image: 'assets/images/onboard3.png',
//               title: 'Plan Your Adventure with Eaze',
//               description:
//                   'Find Trusted Guides,\n Comfortable Accomodations,\n Reliable Vehicles, and Explore\n destinations by region\n effortlessly.',
//               isTitleAndDescAbove: true,
//             ),
//           ],
//         ),
//       ),
//       bottomSheet: isLastPage
//           ? TextButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => AuthenticationScreen()),
//                 );
//               },
//               child: Container(
//                 width: double.infinity,
//                 height: 60,
//                 alignment: Alignment.center,
//                 child: Text(
//                   'Get Started',
//                   style: TextStyle(color: Color(0xFF0F3B2E), fontSize: 20),
//                 ),
//               ),
//             )
//           : GestureDetector(
//               onTap: () {
//                 _controller.nextPage(
//                   duration: Duration(milliseconds: 500),
//                   curve: Curves.easeInOut,
//                 );
//               },
//               child: Container(
//                 height: 60,
//                 alignment: Alignment.center,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Swipe to continue   ',
//                       style: TextStyle(
//                         fontFamily: 'IBMPlexSerif',
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                         color: Color(0xFF0F3B2E),
//                       ),
//                     ),
//                     Text(
//                       '----------->',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF0F3B2E),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget buildBullets(String description) {
//     List<String> items = description.split('\n');

//     return Center(
//   child: ConstrainedBox(
//     constraints: BoxConstraints(
//       maxWidth: MediaQuery.of(context).size.width * 0.49, // 👈 KEY CONTROL
//     ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: items.map((item) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 2.5),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "• ",
//                   style: TextStyle(fontSize: 20, color: Color(0xFF1C5E4A)),
//                 ),
//                 Expanded(
//                   child: Text(
//                     item.trim(),
//                     style: TextStyle(
//                       fontFamily: 'CormorantGaramond',
//                       fontSize: 20,
//                       color: Color(0xFF1C5E4A),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     )
//     );
//   }

//   Widget buildPage({
//     required String image,
//     required String title,
//     required String description,
//     bool isTitleAbove = false,
//     bool isTitleAndDescAbove = false,
//     bool isBulleted = false,
//   }) {
//     List<Widget> content = [];

//     // CASE 1: Title + description ABOVE image
//     if (isTitleAndDescAbove) {
//       content.add(
//         Text(
//           title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontFamily: 'IBMPlexSerif',
//             fontSize: 37,
//             fontWeight: FontWeight.w900,
//             color: Color(0xFF0F3B2E),
//           ),
//         ),
//       );
//       content.add(SizedBox(height: 12));

//       // description (NOT bullets)
//       content.add(
//         Text(
//           description,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontFamily: 'CormorantGaramond',
//             fontSize: 24,
//             fontWeight: FontWeight.w300,
//             color: Color(0xFF1C5E4A),
//           ),
//         ),
//       );

//       content.add(SizedBox(height: 20));
//       content.add(Image.asset(image, height: 200));
//     }
//     // CASE 2: Title ABOVE image (Page 1)
//     else if (isTitleAbove) {
//       content.add(
//         Text(
//           title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontFamily: 'IBMPlexSerif',
//             fontSize: 37,
//             fontWeight: FontWeight.w900,
//             color: Color(0xFF0F3B2E),
//           ),
//         ),
//       );
//       content.add(SizedBox(height: 20));
//       content.add(Image.asset(image, height: 200));
//       // content.add(SizedBox(height: 12));

//       // description (NOT bullets on page 1)
//       content.add(
//         Text(
//           description,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontFamily: 'CormorantGaramond',
//             fontSize: 24,
//             fontWeight: FontWeight.w300,
//             color: Color(0xFF1C5E4A),
//           ),
//         ),
//       );
//     }
//     // CASE 3: Default layout (Page 2)
//     else {
//       content.add(Image.asset(image, height: 200));
//       content.add(SizedBox(height: 20));

//       content.add(
//         Text(
//           title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontFamily: 'IBMPlexSerif',
//             fontSize: 37,
//             fontWeight: FontWeight.w900,
//             color: Color(0xFF0F3B2E),
//           ),
//         ),
//       );
//       content.add(SizedBox(height: 15));

//       if (isBulleted) {
//         content.add(buildBullets(description)); // centered bullets
//       } else {
//         content.add(
//           Text(
//             description,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontFamily: 'CormorantGaramond',
//               fontSize: 24,
//               fontWeight: FontWeight.w300,
//               color: Color(0xFF1C5E4A),
//             ),
//           ),
//         );
//       }
//     }

//     return Padding(
//       padding: const EdgeInsets.only(top: 45), // move content upward
//       child: Column(
//         mainAxisAlignment:
//             MainAxisAlignment.start, // start = pushes content upward
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: content,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'authentication_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardData(
      image: 'assets/images/onboard1.png',
      tag: 'Twende',
      title: 'All in one\nTourism Guide',
      description:
          'Vehicles for hire\nAccommodations\nRestaurants and cuisine\nTourist Destinations\nCertified Tour Guides',
      isBulleted: true,
    ),
    _OnboardData(
      image: 'assets/images/onboard2.png',
      tag: null,
      title: 'Discover the\nPearl of Africa',
      description:
          'Explore Uganda\'s wildlife, culture,\ndestinations and travel services,\nall in one app.',
      isBulleted: false,
    ),
    _OnboardData(
      image: 'assets/images/onboard3.png',
      tag: null,
      title: 'Plan Your\nAdventure with\nEaze',
      description:
          'Find Trusted Guides, Comfortable\nAccommodations, Reliable Vehicles,\nand Explore destinations by region\neffortlessly.',
      isBulleted: false,
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthenticationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // ── Full-screen PageView of background images ──
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _OnboardPage(data: _pages[i]),
          ),

          // ── Page dots ──
          Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? Colors.white
                        : Colors.white.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

          // ── Next / Get Started button ──
          Positioned(
            bottom: 40,
            left: 28,
            right: 28,
            child: GestureDetector(
              onTap: _next,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLast ? 'Get Started' : 'Next',
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F3B2E),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFF0F3B2E),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data model ──
class _OnboardData {
  final String image;
  final String? tag;
  final String title;
  final String description;
  final bool isBulleted;

  const _OnboardData({
    required this.image,
    required this.tag,
    required this.title,
    required this.description,
    required this.isBulleted,
  });
}

// ── Single onboarding page ──
class _OnboardPage extends StatelessWidget {
  final _OnboardData data;
  const _OnboardPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background photo
        Image.asset(data.image, fit: BoxFit.cover),

        // Gradient overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Color(0xE6071F14),
              ],
              stops: [0.30, 1.0],
            ),
          ),
        ),

        // Content card at bottom
        Positioned(
          left: 20,
          right: 20,
          bottom: 160,
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Optional tag pill
                if (data.tag != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C5E4A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data.tag!,
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // Title
                Text(
                  data.title,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSerif',
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),

                // Description (bulleted or plain)
                if (data.isBulleted)
                  _BulletList(text: data.description)
                else
                  Text(
                    data.description,
                    style: const TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 18,
                      color: Color(0xDDFFFFFF),
                      fontWeight: FontWeight.w300,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BulletList extends StatelessWidget {
  final String text;
  const _BulletList({required this.text});

  @override
  Widget build(BuildContext context) {
    final items = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.trim(),
                      style: const TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 18,
                        color: Color(0xDDFFFFFF),
                        fontWeight: FontWeight.w300,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}