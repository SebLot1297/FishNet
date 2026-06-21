import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../OverallApp/theme.dart';
import '/Providers/auth_provider.dart';
class SettingsPage extends StatefulWidget{
  const SettingsPage({super.key});

  @override
   State<SettingsPage> createState() => SettingsPageState();

}
class SettingsPageState extends State<SettingsPage>{
void _closeEndDrawer() {
    Navigator.of(context).pop();
  }
  @override

  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = Theme.of(context);
    final authP = Provider.of<AuthProvider>(context);

    return Drawer(
          child: Scaffold(
          backgroundColor: theme.appBarTheme.backgroundColor,
            appBar: AppBar(title: Text("Settings"), backgroundColor: theme.appBarTheme.backgroundColor, 
            leading: IconButton(onPressed: _closeEndDrawer, icon: Icon(Icons.arrow_back_ios_new)),
            
            ),
            body: Column(
                  children: [
                      SwitchListTile(
                        title: Text("Dark Mode"),
                        value: themeController.isDarkMode,
                        onChanged: (value) {
                        themeController.toggleTheme(value);

      },
    ),

    TextButton(onPressed: authP.signOut, child: Text("LogOut"))
  ],
),
        ),
      );
      
  }

}