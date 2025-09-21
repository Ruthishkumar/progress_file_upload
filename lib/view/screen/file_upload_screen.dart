import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_file_upload/view/utils/app_colors.dart';
import 'package:progress_file_upload/view/utils/app_styles.dart';
import 'package:progress_file_upload/view/utils/toast_service.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  String profileImage = "";
  double uploadProgress = 0.0;
  bool isUploadingImage = false;
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: appBarWidget(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 120.h),
            SizedBox(
              height: 100,
              width: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isUploadingImage)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(
                            value: uploadProgress,
                            strokeWidth: 4,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.buttonColor),
                          ),
                        ),
                        Text(
                          '${(uploadProgress * 100).toInt()}%',
                          style: AppStyles.instance.indicatorTextStyles,
                        ),
                      ],
                    ),
                  profileImage != '' && !isUploadingImage
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(File(
                                  profileImage ?? '',
                                )),
                                fit: BoxFit.cover,
                              )),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: !isUploadingImage
                                      ? AppColors.appBackgroundColor
                                      : Colors.transparent,
                                  width: 1.5)),
                          child: Icon(
                            Icons.person_outlined,
                            color: !isUploadingImage
                                ? AppColors.appBackgroundColor
                                : Colors.transparent,
                            size: 60.sp,
                          )),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                bottomSheetUploadProfileWidget();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(30.r, 12.r, 30.r, 12.r),
                decoration: BoxDecoration(
                    color: AppColors.buttonColor,
                    borderRadius: BorderRadius.all(Radius.circular(8.r))),
                child: Text('Upload Profile',
                    style: AppStyles.instance.whiteTextStyles),
              ),
            )
          ],
        ),
      ),
    ));
  }

  /// App Bar Widget
  PreferredSizeWidget appBarWidget() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        'Image Upload Progress',
        style: AppStyles.instance.appHeaderStyles,
      ),
    );
  }

  /// upload profile bottom sheet widget
  bottomSheetUploadProfileWidget() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (sheetContext) => DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.3,
              maxChildSize: 0.9,
              minChildSize: 0.3,
              builder: (ctx, scrollController) => SingleChildScrollView(
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -80,
                      child: Container(
                        padding: EdgeInsets.all(12.sp),
                        decoration: const BoxDecoration(
                            color: Color(0xff1E1E26), shape: BoxShape.circle),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20.sp, 100.sp, 20.sp, 0.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  try {
                                    var status =
                                        await Permission.camera.request();
                                    if (status.isGranted) {
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(
                                          source: ImageSource.camera,
                                          imageQuality: 10,
                                          maxWidth: 200);
                                      if (pickedFile != null) {
                                        uploadImageFirebaseFunction(pickedFile);
                                      }
                                    } else {
                                      log("Camera permission denied");
                                    }
                                  } catch (e) {
                                    log('$e');
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12.sp),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: AppColors.buttonColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.camera_alt_rounded,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8.sp),
                                      Text(
                                        'Camera',
                                        style: AppStyles
                                            .instance.bottomSheetTextStyles,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    var status =
                                        await Permission.photos.request();
                                    if (status.isGranted) {
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50,
                                      );
                                      if (pickedFile != null) {
                                        uploadImageFirebaseFunction(pickedFile);
                                      }
                                    } else {
                                      log("Gallery permission denied");
                                    }
                                  } catch (e) {
                                    log('Error picking image: $e');
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12.sp),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: AppColors.buttonColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.image,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8.sp),
                                      Text(
                                        'Gallery',
                                        style: AppStyles
                                            .instance.bottomSheetTextStyles,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  /// upload image firebase function
  uploadImageFirebaseFunction(XFile pickedFile) async {
    setState(() {
      isUploadingImage = true;
      uploadProgress = 0.0;
    });

    if (!mounted) return;
    Navigator.of(context).pop();

    final file = File(pickedFile.path);
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    /// Start timing
    final startTime = DateTime.now();

    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        uploadProgress += 0.05;
        if (uploadProgress >= 1.0) {
          uploadProgress = 1.0;
          timer.cancel();
        }
      });
    });

    /// Only for firebase testing purpose Future delay and uploadProgress condition because its very fast
    /// if uploading time is more than 3 seconds then remove this line and uploadProgress condition
    await Future.delayed(const Duration(seconds: 3));
    if (uploadProgress == 1.0) {
      try {
        await FirebaseFirestore.instance.collection('uploads').add({
          'imageBytes': base64Image,
          'createdAt': DateTime.now().toIso8601String(),
        });

        final endTime = DateTime.now();
        final duration = endTime.difference(startTime);

        if (!mounted) return;
        ToastServices().showSuccess("Image uploaded successfully!", context);

        log("Image uploaded successfully to firebase!");
        log("Upload duration: ${duration.inMilliseconds} ms");

        setState(() {
          profileImage = pickedFile.path;
          isUploadingImage = false;
        });
      } catch (e) {
        if (!mounted) return;
        ToastServices().showError("Error Uploading Image", context);
        log("Error uploading image: $e");
        setState(() {
          isUploadingImage = false;
        });
      }
    }
  }
}
