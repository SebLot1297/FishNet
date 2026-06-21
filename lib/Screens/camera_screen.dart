import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../Providers/fish_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:firebase_auth/firebase_auth.dart';
class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => CameraStatus();
}

class CameraStatus extends State<CameraApp> {
  CameraController? controller;
  Future<void>? initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    setupCamera();
  }

  Future<void> setupCamera() async {
     // Check permission before touching the camera
  final status = await Permission.camera.request();
  
  if (status.isDenied || status.isPermanentlyDenied) {
    // User said no — don't try to open the camera
    return;
  }
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    initializeControllerFuture = controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> takePicture(BuildContext context) async {
  try {
    await initializeControllerFuture;
    final image = await controller!.takePicture();

    final weightController = TextEditingController();
    final lengthController = TextEditingController();
    final weightLengthResult = await showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('How big was it?'),
    content: Column( children: [
      TextField(controller: weightController,
      decoration: InputDecoration(labelText: "Weight in pounds?"),
      keyboardType: TextInputType.number
        
      ),
      TextField(controller: lengthController,
      decoration: InputDecoration( labelText: "Length in inches?"),
      keyboardType: TextInputType.number)

    ],) ,
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, null),
        child: Text('Skip'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, {
          'weight': double.tryParse(weightController.text),
          'length': double.tryParse(lengthController.text),
        }),
        child: Text('Save'),
      ),
    ],
  ),
);
  if (!mounted) return;
    // Get the permanent storage location for this app
    final appDir = await getApplicationDocumentsDirectory();
    
    // Create a unique filename using the timestamp
    final fileName = 'fish_${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    // Build the full permanent path
    final permanentPath = '${appDir.path}/$fileName';
    
    // Copy from temporary cache to permanent storage
    await File(image.path).copy(permanentPath);

    // Save the PERMANENT path to Hive, not the temporary one
    final fishProvider = Provider.of<FishProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    await fishProvider.addFish(
      Fish(
        name: "Unknown Fish", //for now until we get fish recognition
        fishImagePath: permanentPath,
        userID: user?.uid ?? '',
        weight: weightLengthResult?['weight'],
        length: weightLengthResult?['length'],
)
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fish added to Aquarium!")),
    );
  } catch (e) {
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (controller == null || initializeControllerFuture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          "Camera",
          style: TextStyle(
            fontSize: 40,
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
      ),

      body: FutureBuilder(
        future: initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(controller!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => takePicture(context),
        child: const Icon(Icons.camera),
      ),
    );
  }
}