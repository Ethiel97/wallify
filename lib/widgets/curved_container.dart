import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mobile/utils/colors.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

class CurvedContainer extends StatelessWidget {
  const CurvedContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShapeOfView(
          height: Get.height / 2,
          shape:
              ArcShape(direction: ArcDirection.Inside, height: Get.height / 8),
          elevation: .0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.darkColor,
            ),
          ),
        ),
      ],
    );
  }
}
