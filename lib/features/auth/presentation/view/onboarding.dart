import 'package:bookit/features/auth/presentation/view/login_page.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> _buildPages(BuildContext context) {
    return [
      _buildOnboardingPage(
        context: context,
        imagePath: 'assets/images/phone.png',
        title: 'Feel Premium on Our App',
        description: 'Experience premium features like never before.',
      ),
      _buildOnboardingPage(
        context: context,
        imagePath: 'assets/images/room.png',
        title: 'Book Rooms Seamlessly',
        description: 'Find and book your perfect room in just a few taps.',
      ),
      _buildOnboardingPage(
        context: context,
        imagePath: 'assets/images/book.png',
        title: 'View Our Hotel in Your Hands',
        description: 'Explore our hotel and amenities through your device.',
      ),
    ];
  }

  Widget _buildOnboardingPage({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String description,
  }) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: size.height * 0.35, // Adjust height based on screen size
          width: size.width * 0.8, // Adjust width proportionally
          fit: BoxFit.contain,
        ),
        SizedBox(height: size.height * 0.03), // Dynamic spacing
        Text(
          title,
          style: TextStyle(
            fontSize:
                size.width * 0.06, // Adjust font size based on screen width
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          description,
          style: TextStyle(
            fontSize: size.width * 0.04,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: _buildPages(context),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentPage > 0
                    ? TextButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: const Text('Back'),
                      )
                    : const SizedBox.shrink(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 12 : 8,
                      height: _currentPage == index ? 12 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentPage == index ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ),
                _currentPage < 2
                    ? TextButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: const Text('Next'),
                      )
                    : TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: const Text('Finish'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
