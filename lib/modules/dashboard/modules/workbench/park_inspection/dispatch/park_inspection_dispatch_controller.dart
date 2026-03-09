import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/park_inspection_plan_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';
import '../park_inspection_controller.dart';

class ParkInspectionDispatchController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final ParkInspectionController parentController;

  final TextEditingController dateController = TextEditingController();
  String keyword = '';
  ParkInspectionPlanItemModel? selectedPlan;
  bool loading = false;
  List<ParkInspectionPlanItemModel> dispatchPlans =
      const <ParkInspectionPlanItemModel>[];

  @override
  Future<void> onInit() async {
    super.onInit();
    parentController = Get.find<ParkInspectionController>();
    await loadDispatchPlans();
    update();
  }

  List<ParkInspectionPlanItemModel> get filteredPlans {
    return dispatchPlans.where((item) {
      final text = '${item.planName ?? ''} ${(item.planCode ?? '')}'
          .toLowerCase();
      return keyword.trim().isEmpty ||
          text.contains(keyword.trim().toLowerCase());
    }).toList();
  }

  bool get submitting => parentController.dispatchSubmitting;

  Future<void> loadDispatchPlans() async {
    if (loading) return;
    loading = true;
    update();
    final result = await _repository.getParkInspectionPlans(
      status: 'ENABLED',
      current: 1,
      size: 500,
    );
    result.when(
      success: (data) {
        dispatchPlans = data
            .where((item) => (item.configStatus ?? '').trim() == 'COMPLETE')
            .toList();
      },
      failure: (error) => AppToast.showError(error.message),
    );
    loading = false;
    update();
  }

  void onKeywordChanged(String value) {
    keyword = value;
    update();
  }

  void onPlanSelected(ParkInspectionPlanItemModel value) {
    selectedPlan = value;
    update();
  }

  void onTaskDateChanged(DateTime value) {
    dateController.text =
        '${value.year}-${_pad2(value.month)}-${_pad2(value.day)}';
    update();
  }

  Future<void> submit() async {
    if (selectedPlan?.id == null) {
      AppToast.showWarning('请选择巡检计划');
      return;
    }
    if (dateController.text.trim().isEmpty) {
      AppToast.showWarning('请选择任务日期');
      return;
    }

    final success = await parentController.dispatchTask(
      planId: selectedPlan!.id!,
      taskDate: dateController.text.trim(),
    );
    if (success) {
      Get.back<bool>(result: true);
    }
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }
}
