import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 显示一个 iOS 风格的底部日期选择器
///
/// [context] BuildContext
/// [onConfirm] 点击确定按钮的回调，返回选中的日期
/// [initialTime] 初始选中的日期
/// [minTime] 最小可选日期
/// [maxTime] 最大可选日期
void showIosDatePicker({
  required BuildContext context,
  required Function(DateTime) onConfirm,
  DateTime? initialTime,
  DateTime? minTime,
  DateTime? maxTime,
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
}) {
  DateTime selectedDate = initialTime ?? DateTime.now();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return SizedBox(
        height: 250, // 可以根据需要调整高度
        child: Column(
          children: [
            Container(
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('取消'),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  CupertinoButton(
                    child: const Text('确定'),
                    onPressed: () {
                      onConfirm(selectedDate);
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: mode,
                initialDateTime: initialTime ?? DateTime.now(),
                minimumDate: minTime,
                maximumDate: maxTime,
                onDateTimeChanged: (DateTime newDate) {
                  selectedDate = newDate;
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
