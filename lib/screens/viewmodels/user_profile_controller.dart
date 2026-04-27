import 'package:get/get.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:hunargah/screens/model/user_model.dart';

class UserProfileController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isCreatorMode = false.obs;
  final RxInt selectedTabIndex = 0.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    try {
      final data = await FirebaseService().getUserData();
      final uid = FirebaseService().currentUserId;

      if (data != null && uid != null) {
        user.value = UserModel.fromMap(data, uid);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not load profile: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCreatorMode(bool value) => isCreatorMode.value = value;
  void changeTab(int index) => selectedTabIndex.value = index;
}
