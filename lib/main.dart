import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_file_upload/view/screen/file_upload_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDx3-97BssI-v503AdppnZcN4zXSM_w9y8",
          appId: "1:942355270158:android:e031319b073b9d74c24a5f",
          messagingSenderId: "942355270158",
          projectId: "file-upload-16ab9"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 805),
      builder: (context, child) {
        return MaterialApp(
          title: 'File Upload',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: FileUploadScreen(),
        );
      },
    );
  }
}
