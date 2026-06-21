import 'package:flutter/material.dart';
import '../Screens/camera_screen.dart';

class BottomHud extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const BottomHud({super.key, required this.pageIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          currentIndex: pageIndex,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraApp()),
              );
            } else {
              onTap(index);
            }
          },
          selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: "Home",
            ),
            
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: theme.appBarTheme.backgroundColor,
                  size: 28,
                ),
              ),
              label: "Snap",
            ),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/Fishing.svg.png",
                width: 24,
                height: 24,
                color: pageIndex == 1
                    ? theme.bottomNavigationBarTheme.selectedItemColor
                    : theme.bottomNavigationBarTheme.unselectedItemColor,
              ),
              label: "Aquarium",
            ),
          ],
        ),
      ),
    );
  }
}