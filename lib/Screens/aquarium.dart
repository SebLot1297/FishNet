import 'package:flutter/material.dart';
import '../Providers/fish_provider.dart';
import 'package:provider/provider.dart';

import 'dart:io';

class Aquarium extends StatefulWidget {
  const Aquarium({super.key});

  @override
  State<Aquarium> createState() => AquariumStatus();
}

class AquariumStatus extends State<Aquarium> {
  @override
  Widget build(BuildContext context) {

    final fishProvider = Provider.of<FishProvider>(context);
    final aquarium = fishProvider.fishList;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, 

      appBar: AppBar(
        title: Text(
          "Aquarium",
          style: TextStyle(
            fontSize: 50,
            color: theme.appBarTheme.foregroundColor, 
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor, 
      ),

      body: aquarium.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You have no fish yet",
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.secondaryHeaderColor, 
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Snap your first fish to get started!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: theme.secondaryHeaderColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: aquarium.length,
              itemBuilder: (context, index) {
                final fish = aquarium[index];

                return FishCard(
                  name: fish.name,
                  fishImagePath: fish.fishImagePath,
                  weight: fish.weight,
                  length: fish.length,
                );
              },
            ),
    );
  }
}

class FishCard extends StatelessWidget {
  final String fishImagePath;
  final String name;

  final double ? weight;

  final double ? length;

  const FishCard({
    super.key,
    required this.fishImagePath,
    required this.name, 
    this.weight, this.length
  });

  

  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.all(10),

      
      color: theme.cardColor,
      child: Column(
      children: [ Row(
        children: [
          Image.file(
              File(fishImagePath),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
                ),
          const SizedBox(width: 10),
          Text(
            name,
            style: TextStyle(
              fontSize: 20,
              color: theme.secondaryHeaderColor, 
            ),
          ),
        ],
      ),
      if(weight != null || length != null)
      Row(
        children: [
          if(weight != null)
            
              Text("${weight==weight!.truncate() ? weight!.truncate():weight!} lbs"),
          
          SizedBox(width: 10),
          
          if(length != null)
            Text("${length == length!.truncate() ? length!.truncate() : length!} in.")
        ],
      )
      ]
    )
    );
  }
}