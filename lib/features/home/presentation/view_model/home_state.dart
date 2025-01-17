import 'package:bookit/features/home/presentation/view/bottomscreen/booked_view.dart';
import 'package:bookit/features/home/presentation/view/bottomscreen/profile_view.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../view/bottomscreen/home_view.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({
    required this.selectedIndex,
    required this.views,
  });

  // Initial state
  static HomeState initial() {
    return const HomeState(
      selectedIndex: 0,
      views: [
        HomeView(),
        BookedView(),
        ProfileView(),
      ],
    );
  }

  // Copy state with changes
  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, views];
}
