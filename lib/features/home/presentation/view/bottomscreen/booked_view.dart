// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../../../../app/constants/api_endpoints.dart';
// import '../../../../../app/di/di.dart';
// import '../../../../../app/shared_prefs/token_shared_prefs.dart';

// class BookedView extends StatefulWidget {
//   const BookedView({super.key});

//   @override
//   State<BookedView> createState() => _BookedViewState();
// }

// class _BookedViewState extends State<BookedView> {
//   List<dynamic> _bookings = []; // Store bookings

//   @override
//   void initState() {
//     super.initState();
//     _fetchBookings();
//   }

//   Future<void> _fetchBookings() async {
//     final dio = Dio();
//     final tokenSharedPrefs = getIt<TokenSharedPrefs>();
//     const String apiUrl =
//         '${ApiEndpoints.baseUrl}${ApiEndpoints.getUserBookings}';

//     try {
//       final tokenResult = await tokenSharedPrefs.getToken();
//       String token = tokenResult.fold((failure) => '', (token) => token);

//       if (token.isEmpty) {
//         if (!mounted) return; // Ensure widget is still in the tree
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content:
//                 Text('Authorization token not found. Please log in again.'),
//           ),
//         );
//         return;
//       }

//       final response = await dio.get(
//         apiUrl,
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );

//       if (response.statusCode == 200) {
//         if (!mounted) return; // Ensure widget is still in the tree
//         setState(() {
//           _bookings = response.data; // Store the bookings
//         });
//       } else {
//         throw Exception('Failed to fetch bookings');
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _bookings.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _bookings.length,
//               itemBuilder: (context, index) {
//                 final booking = _bookings[index];
//                 final room = booking['room'];
//                 final checkInDate = DateTime.parse(booking['checkIn']);
//                 final checkOutDate = DateTime.parse(booking['checkOut']);
//                 final isConfirmed = booking['confirmed'];

//                 return Card(
//                   margin: const EdgeInsets.all(8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     leading: room['images'] != null && room['images'].isNotEmpty
//                         ? Image.network(
//                             'http://10.0.2.2:3000/${room['images'][0].replaceAll("public/", "").replaceAll("\\", "/")}',
//                             width: 70,
//                             height: 70,
//                             fit: BoxFit.cover,
//                           )
//                         : const Icon(Icons.bed, size: 70),
//                     title: Text(room['name'],
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                             'Check-In: ${DateFormat.yMMMd().format(checkInDate)}'),
//                         Text(
//                             'Check-Out: ${DateFormat.yMMMd().format(checkOutDate)}'),
//                         Text(
//                           'Status: ${isConfirmed ? "Confirmed" : "Pending"}',
//                           style: TextStyle(
//                             color: isConfirmed ? Colors.green : Colors.orange,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         // Text(
//                         //   booking.paymentStatus == 'completed'
//                         //       ? 'Payment Successful'
//                         //       : 'Pending Payment',
//                         //   style: TextStyle(
//                         //       color: booking.paymentStatus == 'completed'
//                         //           ? Colors.green
//                         //           : Colors.red),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../app/constants/api_endpoints.dart';
import '../../../../../app/di/di.dart';
import '../../../../../app/shared_prefs/token_shared_prefs.dart';

class BookedView extends StatefulWidget {
  const BookedView({super.key});

  @override
  State<BookedView> createState() => _BookedViewState();
}

class _BookedViewState extends State<BookedView> {
  List<dynamic> _bookings = []; // Store bookings

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final dio = Dio();
    final tokenSharedPrefs = getIt<TokenSharedPrefs>();
    const String apiUrl =
        '${ApiEndpoints.baseUrl}${ApiEndpoints.getUserBookings}';

    try {
      final tokenResult = await tokenSharedPrefs.getToken();
      String token = tokenResult.fold((failure) => '', (token) => token);

      if (token.isEmpty) {
        if (!mounted) return; // Ensure widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Authorization token not found. Please log in again.'),
          ),
        );
        return;
      }

      final response = await dio.get(
        apiUrl,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        if (!mounted) return; // Ensure widget is still in the tree

        setState(() {
          _bookings = response.data ?? []; // Ensure response.data is not null
        });

        debugPrint('Fetched Bookings: $_bookings'); // Debugging print
      } else {
        throw Exception('Failed to fetch bookings');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                final booking = _bookings[index];

                // ✅ Check if booking['room'] exists and is not null
                final room = booking['room'] as Map<String, dynamic>?;

                // ✅ Check if 'images' key exists and is not null
                final List<dynamic>? images = room?['images'];

                // ✅ Parse check-in and check-out dates safely
                final String checkInDateString = booking['checkIn'] ?? '';
                final String checkOutDateString = booking['checkOut'] ?? '';

                DateTime? checkInDate;
                DateTime? checkOutDate;

                try {
                  checkInDate = DateTime.parse(checkInDateString);
                  checkOutDate = DateTime.parse(checkOutDateString);
                } catch (e) {
                  debugPrint('Date parsing error: $e');
                }

                final bool isConfirmed = booking['confirmed'] ?? false;

                return Card(
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: (images != null && images.isNotEmpty)
                        ? Image.network(
                            'http://10.0.2.2:3000/${images[0].toString().replaceAll("public/", "").replaceAll("\\", "/")}',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.bed, size: 70),
                    title: Text(
                      room?['name'] ?? 'No Room Name',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          checkInDate != null
                              ? 'Check-In: ${DateFormat.yMMMd().format(checkInDate)}'
                              : 'Check-In: N/A',
                        ),
                        Text(
                          checkOutDate != null
                              ? 'Check-Out: ${DateFormat.yMMMd().format(checkOutDate)}'
                              : 'Check-Out: N/A',
                        ),
                        Text(
                          'Status: ${isConfirmed ? "Confirmed" : "Pending"}',
                          style: TextStyle(
                            color: isConfirmed ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
