import 'package:flutter/material.dart';

class BookedView extends StatefulWidget {
  const BookedView({super.key});

  @override
  State<BookedView> createState() => _BookedViewState();
}

class _BookedViewState extends State<BookedView> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Booked"));
  }
}
