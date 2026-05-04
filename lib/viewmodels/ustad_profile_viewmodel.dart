import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:hunargah/model/ustad_model.dart';

class UstadProfileController extends GetxController {
  final String ustadId;

  var isLoadingProfile = true.obs;
  var ustad = Rxn<UstadModel>();

  var isLoadingVideos = true.obs;
  var videosList = <Map<String, dynamic>>[].obs;

  UstadProfileController({required this.ustadId});

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    bindVideos();
  }

  Future<void> loadProfile() async {
    isLoadingProfile.value = true;
    try {
      final doc = await FirebaseService().getUserProfile(ustadId);
      if (doc.exists) {
        ustad.value = UstadModel.fromSnapshot(doc);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  void bindVideos() {
    FirebaseService()
        .getVideosByUserId(ustadId)
        .listen(
          (snapshot) {
            videosList.value = snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
            isLoadingVideos.value = false;
          },
          onError: (e) {
            isLoadingVideos.value = false;
            debugPrint("Error loading videos: $e");
          },
        );
  }

  ImageProvider getProfileImage() {
    final data = ustad.value;
    if (data == null ||
        data.profileImageUrl == null ||
        data.profileImageUrl!.isEmpty) {
      return CachedNetworkImageProvider('https://i.pravatar.cc/150?img=11');
    }

    String imageString = data.profileImageUrl!;
    if (imageString.startsWith('http')) {
      return CachedNetworkImageProvider(imageString);
    } else {
      try {
        final String cleanBase64 = imageString.contains(',')
            ? imageString.split(',').last
            : imageString;
        return MemoryImage(base64Decode(cleanBase64));
      } catch (e) {
        return CachedNetworkImageProvider('https://i.pravatar.cc/150?img=11');
      }
    }
  }
}
