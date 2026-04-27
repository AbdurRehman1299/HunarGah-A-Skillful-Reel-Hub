import 'package:get/get.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:hunargah/screens/model/ustad_model.dart';

class ExploreController extends GetxController {
  final RxList<UstadModel> allUstads = <UstadModel>[].obs;
  final RxBool isLoading = true.obs;

  final RxString searchQuery = ''.obs;
  final RxString selectedSkill = 'All'.obs;

  final List<String> trendingSkills = [
    'All',
    'AC Repair',
    'Graphic Designing',
    'Stitching',
    'Cooking',
  ];

  @override
  void onInit() {
    super.onInit();

    allUstads.bindStream(
      FirebaseService().getUstadsStream().map(
        (query) =>
            query.docs.map((doc) => UstadModel.fromSnapshot(doc)).toList(),
      ),
    );

    ever(allUstads, (_) => isLoading.value = false);
  }

  void updateSearch(String query) => searchQuery.value = query.toLowerCase();
  void selectSkill(String skill) => selectedSkill.value = skill;

  List<UstadModel> get filteredUstads {
    return allUstads.where((ustad) {
      final name = ustad.username.toLowerCase();
      final skill = ustad.skillTitle.toLowerCase();
      final query = searchQuery.value;

      bool matchesPill =
          selectedSkill.value == 'All' ||
          skill.contains(selectedSkill.value.toLowerCase());
      bool matchesSearch =
          query.isEmpty || name.contains(query) || skill.contains(query);

      return matchesPill && matchesSearch;
    }).toList();
  }
}
