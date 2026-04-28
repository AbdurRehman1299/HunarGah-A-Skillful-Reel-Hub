import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/model/category_model.dart';

class CategoryController extends GetxController {
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _fetchCategories();
  }

  void _fetchCategories() {
    categories.assignAll([
      CategoryModel(
        title: 'Electrician',
        subtitle: '24 COURSES',
        icon: Icons.bolt,
        bgColor: const Color(0xFFE0F2F1),
      ),
      CategoryModel(
        title: 'Welder',
        subtitle: '12 COURSES',
        icon: Icons.local_fire_department,
        bgColor: const Color(0xFFF1F8E9),
      ),
      CategoryModel(
        title: 'Tailor',
        subtitle: '19 COURSES',
        icon: Icons.content_cut,
        bgColor: const Color(0xFFE0F7FA),
      ),
      CategoryModel(
        title: 'Plumber',
        subtitle: '15 COURSES',
        icon: Icons.water_drop,
        bgColor: const Color(0xFFF1F8E9),
      ),
      CategoryModel(
        title: 'AC Mechanic',
        subtitle: '9 COURSES',
        icon: Icons.air,
        bgColor: const Color(0xFFFFF8E1),
      ),
      CategoryModel(
        title: 'Carpentry',
        subtitle: '14 COURSES',
        icon: Icons.handyman,
        bgColor: const Color(0xFFE0F7FA),
      ),
    ]);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
