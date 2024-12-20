import 'package:bookit/common/bottomscreen/booked_view.dart';
import 'package:bookit/common/bottomscreen/home_view.dart';
import 'package:bookit/common/bottomscreen/profile_view.dart';
import 'package:bookit/core/app_theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HotelDetailPage(),
    );
  }
}

class HotelDetailPage extends StatefulWidget {
  const HotelDetailPage({super.key});

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const BookedView(),
    const ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              const Icon(Icons.arrow_back, color: Colors.black),
              SizedBox(width: size.width * 0.03),
              Flexible(
                child: Center(
                  child: SizedBox(
                    height: size.height * 0.06,
                    width: size.width * 0.6,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: const Icon(Icons.search,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        contentPadding: EdgeInsets.all(size.height * 0.01),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            Icon(Icons.favorite_border,
                color: Colors.black, size: size.width * 0.06),
            SizedBox(width: size.width * 0.04),
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: _buildNavItem(Icons.home, 0, size),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(Icons.bookmark, 1, size),
              label: 'Booked',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(Icons.person, 2, size),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, Size size) {
    return Container(
      padding: EdgeInsets.all(size.height * 0.01),
      decoration: BoxDecoration(
        color: _selectedIndex == index ? Colors.blue : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: _selectedIndex == index ? Colors.white : Colors.grey,
        size: size.width * 0.06,
      ),
    );
  }
}
