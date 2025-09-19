import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/dashboard_controller.dart';
import 'package:smart_solutions/controllers/follow_form.dart';
import 'package:smart_solutions/models/team_leader_model.dart';
import 'package:smart_solutions/theme/app_theme.dart';

// ignore: must_be_immutable
class TellecallerFilterChipDialog extends StatefulWidget {
  String title1;
  String title2;
  final List<TeamleaderData> teamleader;
  final List<TeamleaderData> tellecaller;

  final Function(List<String> teamleader, List<String> tellecaller) onApply;

  TellecallerFilterChipDialog({
    super.key,
    required this.title1,
    required this.title2,
    required this.teamleader,
    required this.tellecaller,
    required this.onApply,
  });

  @override
  State<TellecallerFilterChipDialog> createState() =>
      _TellecallerFilterChipDialogState();
}

class _TellecallerFilterChipDialogState
    extends State<TellecallerFilterChipDialog> {
  final FollowBackFormController followBackFormController = Get.find();
  final DashboardController dashboardController = Get.find();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      followBackFormController.selectedTeamLeaders.value = '';
      followBackFormController.selectedtellecaller.clear();
      followBackFormController.tellecallerList.clear();
    });

    // selectedcategory = List.from(widget.selectedCategory);
    // selectedspecialTag = List.from(widget.selectedSpecialTag);
    // selectedSubEvents = List.from(widget.selectedSubEvents);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Options'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title1,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.textColor2)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 3.0,
              runSpacing: 4.0,
              children: widget.teamleader.map((task) {
                return Obx(() {
                  final isSelected =
                      followBackFormController.selectedTeamLeaders.value ==
                          task.id;
                  return ChoiceChip(
                    padding: EdgeInsets.zero,
                    label: Text(task.name),
                    checkmarkColor: AppColors.backgroundColor,
                    selected: isSelected,
                    onSelected: (_) async {
                      if (followBackFormController.selectedTeamLeaders.value ==
                          task.id) {
                        followBackFormController.selectedTeamLeaders.value = '';
                        followBackFormController.tellecallerList.clear();

                        followBackFormController.getteamLeaderData('');
                      } else {
                        followBackFormController.selectedTeamLeaders.value =
                            task.id;

                        followBackFormController.selectedtellecaller
                            .clear(); // ✅ Clear previous tellecallers

                        followBackFormController.getteamLeaderData(
                            followBackFormController.selectedTeamLeaders.value);
                      }

                      // Call API with updated selected list

                      isSelected
                          ? followBackFormController
                              .selectedTeamLeaderId.value = ''
                          : followBackFormController
                              .selectedTeamLeaderId.value = task.id;
                    },
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black),
                  );
                });
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(widget.title2,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.textColor2)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: widget.tellecaller.map((tellecallerData) {
                return Obx(() {
                  final isSelected = followBackFormController
                      .selectedtellecaller
                      .contains(tellecallerData.id);

                  return ChoiceChip(
                      label: Text(tellecallerData.name),
                      selected: isSelected,
                      checkmarkColor: AppColors.backgroundColor,
                      onSelected: (_) {
                        if (isSelected) {
                          followBackFormController.selectedtellecaller
                              .remove(tellecallerData.id);
                          followBackFormController.selectedtellecallerName
                              .remove(tellecallerData.name);
                        } else {
                          followBackFormController.selectedtellecaller
                              .add(tellecallerData.id);
                          followBackFormController.selectedtellecallerName
                              .add(tellecallerData.name);
                        }
                      },
                      selectedColor: AppColors.primaryColor,
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black));
                });
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            followBackFormController.selectedTeamLeaders.value = '';
            widget.tellecaller.clear();
            followBackFormController.selectedtellecaller.clear();
            followBackFormController.selectedtellecallerName.clear();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(5.w)),
          onPressed: () {
            Future.microtask(() async {
              dashboardController.getTimeGraph();
              dashboardController.getActiveData(status: 1);
              dashboardController.getActiveData(status: 2);
              followBackFormController.getCallBackData();
              followBackFormController.getCallLogData();
              followBackFormController.getDisbursementData();
            });

            Navigator.pop(context);
          },
          child: const Text(
            'Apply Filter',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
