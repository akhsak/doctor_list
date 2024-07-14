import 'package:doctor/controller/bottombar_controller.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 240, 242),
      body: Consumer<BottomProvider>(
          builder: (context, value, child) =>
              value.userScreens[value.CurrentIndex]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 238, 240, 242)),
          height: size.height * .09,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Consumer<BottomProvider>(
              builder: (context, value, child) => BottomNavigationBar(
                unselectedFontSize: 11,
                selectedFontSize: 12,
                type: BottomNavigationBarType.fixed,
                onTap: value.onTap,
                backgroundColor: const Color(0xFFFFFFFF),
                currentIndex: value.CurrentIndex,
                selectedItemColor: Color.fromARGB(255, 10, 156, 66),
                unselectedItemColor: const Color(0xFF98A3B3),
                showUnselectedLabels: true,
                items: [
                  BottomNavigationBarItem(
                    icon: value.CurrentIndex == 0
                        ? const Icon(EneftyIcons.home_2_bold)
                        : const Icon(EneftyIcons.home_2_outline),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: value.CurrentIndex == 1
                        ? const Icon(EneftyIcons.calendar_2_bold)
                        : const Icon(EneftyIcons.calendar_2_outline),
                    label: 'Appointment',
                  ),
                  BottomNavigationBarItem(
                    icon: value.CurrentIndex == 2
                        ? const Icon(EneftyIcons.note_2_bold)
                        : const Icon(EneftyIcons.note_2_outline),
                    label: 'Prescription',
                  ),
                  BottomNavigationBarItem(
                    icon: value.CurrentIndex == 3
                        ? const Icon(EneftyIcons.profile_bold)
                        : const Icon(EneftyIcons.profile_outline),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
