import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/room_entity.dart';

class RoomDetailScreen extends StatefulWidget {
  final RoomEntity room;

  const RoomDetailScreen({super.key, required this.room});

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  DateTime? checkInDate;
  DateTime? checkOutDate;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(widget.room.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.room.images.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.room.images.length,
                  itemBuilder: (context, index) {
                    final String imageUrl =
                        'http://10.0.2.2:3000/${widget.room.images[index].replaceAll("public/", "").replaceAll("\\", "/")}';

                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.network(
                        imageUrl,
                        width: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error,
                              size: 100, color: Colors.red);
                        },
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(widget.room.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Type: ${widget.room.type}'),
            const SizedBox(height: 8),
            Text('Price: NRs. ${widget.room.price.toStringAsFixed(0)}'),
            const SizedBox(height: 16),
            Text(
              'Status: ${widget.room.available ? 'Available' : 'Not Available'}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.room.available ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.room.available)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Check-In Date:',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text(checkInDate == null
                        ? 'Choose Check-In Date'
                        : DateFormat.yMMMd().format(checkInDate!)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Select Check-Out Date:',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text(checkOutDate == null
                        ? 'Choose Check-Out Date'
                        : DateFormat.yMMMd().format(checkOutDate!)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => (context),
                    child: const Text('Book room'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
