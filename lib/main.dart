import 'package:fishing_pokidex/Screens/aquarium.dart';
import 'package:fishing_pokidex/OverallApp/bottom_hud.dart';
import 'package:flutter/material.dart';
import 'Screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'OverallApp/theme.dart';
import 'Providers/fish_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Providers/auth_provider.dart';
import 'Screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'OverallApp/global_errors_announcment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(FishAdapter());
  Hive.registerAdapter(IdentificationStatusAdapter());
  await Firebase.initializeApp();

  final fishProvider = FishProvider();
  await fishProvider.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider.value(value: fishProvider),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int pageIndex = 0;

  List<Widget> get pages => [
        HomeScreen(
          onTabChange: (index) {
            setState(() {
              pageIndex = index;
            });
          },
        ),
        const Aquarium(),
        
      ];

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final auth = Provider.of<AuthProvider>(context);

    return MaterialApp(
      theme: themeController.themeData,
      navigatorKey: navigatorKey,
      home: auth.isLoggedIn
          ? Scaffold(
              body: IndexedStack(
                index: pageIndex,
                children: pages,
              ),
              bottomNavigationBar: BottomHud(
                pageIndex: pageIndex,
                onTap: (index) {
                  setState(() {
                    if (index < 1) {
                      pageIndex = index;
                    } else {
                      pageIndex = index - 1;
                    }
                  });
                },
              ),
            )
          : const LoginScreen(),
    );
  }
}