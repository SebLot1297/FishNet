import 'package:fishing_pokidex/Screens/settings_page.dart';
import 'package:flutter/material.dart';
import '../OverallApp/profile.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onTabChange;
  const HomeScreen({super.key, this.onTabChange});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor, 
      endDrawer: SettingsPage(),

      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,

        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            icon: Icon(
              Icons.person_3_rounded,
              color: theme.appBarTheme.foregroundColor, 
            ),
          ),
        ),

        title: Text(
          "Fishing Pokidex",
          style: TextStyle(
            fontSize: 20,
            color: theme.appBarTheme.foregroundColor, 
          ),
        ),

        centerTitle: true,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20), 
            child: IconButton(
              icon: Icon(
                Icons.waves_outlined,
                color: theme.appBarTheme.foregroundColor, 
              ),
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _openEndDrawer();
                });
              },
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 150, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Aquarium",
              style: TextStyle(
                fontSize: 20,
                color: theme.secondaryHeaderColor, 
                fontWeight: FontWeight.bold,
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  widget.onTabChange?.call(1);
                },
                child: Text(
                  "View All",
                  style: TextStyle(
                    color: theme.colorScheme.primary, 
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}