import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image and Info
            Stack(
              children: [
                Image.asset(
                  'assets/images/hotel.png', // Replace with actual image path
                  width: size.width,
                  height: size.height * 0.3,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02,
                      vertical: size.height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Text('Interior', style: TextStyle(color: Colors.black)),
                        SizedBox(width: 8),
                        Text('Exterior', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Title and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hotel Diamond Palace',
                            style: TextStyle(
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.orange,
                                  size: size.width * 0.04),
                              SizedBox(width: size.width * 0.01),
                              Text('4.2',
                                  style:
                                      TextStyle(fontSize: size.width * 0.035)),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        'NRS.3,493',
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.02),

                  // About the Hotel Section
                  Text(
                    'About the Hotel',
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra.',
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Read more',
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      color: Colors.blue,
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  // What this Place Offers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'What this Place Offers',
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'More',
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.wifi,
                          size: size.width * 0.08, color: Colors.blue),
                      Icon(Icons.local_parking,
                          size: size.width * 0.08, color: Colors.blue),
                      Icon(Icons.pool,
                          size: size.width * 0.08, color: Colors.blue),
                      Icon(Icons.local_taxi,
                          size: size.width * 0.08, color: Colors.blue),
                    ],
                  ),

                  SizedBox(height: size.height * 0.02),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero',
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Read more',
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      color: Colors.blue,
                    ),
                  ),

                  // Map Section
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
