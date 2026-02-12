import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/admin/admin_disbursement.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/utils/currency_util.dart';
import 'package:smart_solutions/views/spacing_constants.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/flutter_chiplist.dart';
import 'package:smart_solutions/widget/header_title.dart';
import 'package:smart_solutions/widget/loading_page.dart';
import 'package:smart_solutions/widget/searchbarwithclear.dart';
import 'package:smart_solutions/widget/text_style.dart';

class AdminDisbursement extends StatefulWidget {
  final String title;
  const AdminDisbursement({super.key, required this.title});

  @override
  State<AdminDisbursement> createState() => _AdminDisbursementState();
}

class _AdminDisbursementState extends State<AdminDisbursement> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _adminDisbursementController = Get.put(DisbursementController());

  @override
  void initState() {
    super.initState();
    // Team leaders are loaded in controller's onInit()
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      isDrawer: false,
      showBack: true,
      title: widget.title,
      key: _scaffoldKey,
      body: Obx(() {
        // Show loading if either team leaders or disbursement data is loading
        if (_adminDisbursementController.isLoading.value ||
            _adminDisbursementController.iscallDisbursedLoading.value) {
          return const LoadingPage();
        }

        return Column(
          children: [
            Container(
              color: AppColors.appBarTextColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderTitle(
                    title: widget.title,
                    style: AppTextStyle.headerTitle,
                  ),
                  SearchBarWithClear(
                    controller: _adminDisbursementController.searchController,
                    onClear: _adminDisbursementController.clearFilters,
                    onChanged: (value) {
                      _adminDisbursementController.getDisbursementData(
                          query: value);
                      // Handle search if needed
                    },
                  ),
                  kVerticalSpace(5),
                  _buildFilterChips(),
                  kVerticalSpace(10),
                  _buildTotalSummary(),
                ],
              ),
            ),
            Expanded(child: _buildDisbursementList()),
          ],
        );
      }),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
      final filterList = _adminDisbursementController.filters;

      if (filterList.isEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Center(
            child: Text(
              'Loading team leaders...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }

      return SizedBox(
        height: 50.h,
        child: FilterChipList(
          filters: filterList,
          controller: _adminDisbursementController.filterScrollController,
          selectedIndex: _adminDisbursementController.selectedFilter.value,
          onSelected: _adminDisbursementController.selectFilter,
        ),
      );
    });
  }

  // Widget _buildTotalSummary() {
  //   return Obx(() {
  //     final totalData = _adminDisbursementController.disbursementTotal.value;

  //     if (totalData == null) {
  //       return const SizedBox.shrink();
  //     }

  //     final totalSum =
  //         totalData.loginCountTotal + totalData.disbursedCountTotal;

  //     return SummaryHeaderCard(
  //       title: 'Total',
  //       duration: 'Login Files - ${totalData.loginCountTotal}',
  //       rows: [
  //         Row(mainAxisSize: MainAxisSize.min, children: [
  //           Icon(Icons.account_balance_wallet_outlined,
  //               color: Colors.blue, size: 20),
  //           const SizedBox(width: 6),
  //           Text(
  //             totalSum.toString(),
  //             style: TextStyle(
  //               fontSize: 16.sp,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           const SizedBox(width: 12),
  //           Text(
  //             '₹${CurrencyUtils.formatAmount(totalData.amountTotal.toString())}',
  //             style: TextStyle(
  //               color: Colors.green,
  //               fontSize: 14.sp,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           const SizedBox(width: 12),
  //           _statChip(
  //             icon: Icons.login,
  //             label: "Login",
  //             value: totalData.loginCountTotal.toString(),
  //             color: Colors.blue,
  //           ),
  //           const SizedBox(width: 6),
  //           _statChip(
  //             icon: Icons.check_circle_outline,
  //             label: "Disbursed",
  //             value: totalData.disbursedCountTotal.toString(),
  //             color: Colors.green,
  //           ),
  //         ])

  //         // Container(
  //         //   padding: const EdgeInsets.all(14),
  //         //   decoration: BoxDecoration(
  //         //     color: Colors.white,
  //         //     borderRadius: BorderRadius.circular(16),
  //         //     boxShadow: [
  //         //       BoxShadow(
  //         //         color: Colors.black.withOpacity(.05),
  //         //         blurRadius: 10,
  //         //         offset: const Offset(0, 4),
  //         //       ),
  //         //     ],
  //         //   ),
  //         //   child: Column(
  //         //     children: [
  //         //       Icon(Icons.account_balance_wallet_outlined,
  //         //           color: Colors.blue, size: 26),
  //         //       const SizedBox(height: 6),
  //         //       Text(
  //         //         totalSum.toString(),
  //         //         style: TextStyle(
  //         //           fontSize: 22.sp,
  //         //           fontWeight: FontWeight.bold,
  //         //         ),
  //         //       ),
  //         //       SizedBox(height: 6.h),
  //         //       Text(
  //         //         '₹${CurrencyUtils.formatAmount(totalData.amountTotal.toString())}',
  //         //         style: TextStyle(
  //         //           color: Colors.green,
  //         //           fontSize: 16.sp,
  //         //           fontWeight: FontWeight.w600,
  //         //         ),
  //         //       ),
  //         //       const Divider(height: 18),
  //         //       Row(
  //         //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //         children: [
  //         //           _statChip(
  //         //             icon: Icons.login,
  //         //             label: "Login",
  //         //             value: totalData.loginCountTotal.toString(),
  //         //             color: Colors.blue,
  //         //           ),
  //         //           _statChip(
  //         //             icon: Icons.check_circle_outline,
  //         //             label: "Disbursed",
  //         //             value: totalData.disbursedCountTotal.toString(),
  //         //             color: Colors.green,
  //         //           ),
  //         //         ],
  //         //       )
  //         //     ],
  //         //   ),
  //         // ),
  //       ],
  //     );
  //   });
  // }

  // Widget _buildTotalSummary() {
  //   return Obx(() {
  //     final totalData = _adminDisbursementController.disbursementTotal.value;

  //     if (totalData == null) {
  //       return const SizedBox.shrink();
  //     }

  //     final totalSum =
  //         totalData.loginCountTotal + totalData.disbursedCountTotal;

  //     return SummaryHeaderCard(
  //       title: 'Files: $totalSum',
  //       //  duration: 'Files: $totalSum',
  //       rows: [
  //         Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // const Icon(Icons.summarize_outlined,
  //             //     size: 18, color: Colors.blue),
  //             // const SizedBox(width: 4),
  //             // Text(
  //             //   totalSum.toString(),
  //             //   style: TextStyle(
  //             //     fontWeight: FontWeight.bold,
  //             //     fontSize: 14.sp,
  //             //   ),
  //             // ),
  //             // const SizedBox(width: 10),
  //             Text(
  //               '₹${CurrencyUtils.formatAmount(totalData.amountTotal.toString())}',
  //               style: TextStyle(
  //                 color: Colors.green,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 13.sp,
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //             _statChip(
  //               icon: Icons.login,
  //               label: "L",
  //               value: totalData.loginCountTotal.toString(),
  //               color: Colors.blue,
  //             ),
  //             const SizedBox(width: 4),
  //             _statChip(
  //               icon: Icons.check_circle_outline,
  //               label: "D",
  //               value: totalData.disbursedCountTotal.toString(),
  //               color: Colors.green,
  //             ),
  //           ],
  //         ),
  //       ],
  //     );
  //   });
  // }

  Widget _buildTotalSummary() {
    return Obx(() {
      final list = _adminDisbursementController.disbursementList;

      if (list.isEmpty) {
        return const SizedBox.shrink();
      }

      int loginTotal = 0;
      int disbursedTotal = 0;
      double amountTotal = 0;

      for (var e in list) {
        loginTotal += int.parse(e.loginCount);
        disbursedTotal += int.parse(e.disbursedCount);
        amountTotal += int.parse(e.amount);
      }

      final totalSum = loginTotal + disbursedTotal;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.blue.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// TOTAL COUNT BOX
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  totalSum.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// LOGIN + DISBURSED
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.login, size: 16, color: Colors.blue.shade700),
                  const SizedBox(width: 4),
                  Text(
                    "Login: $loginTotal",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.check_circle_outline,
                      size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    "Disbursed: $disbursedTotal",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            /// AMOUNT
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "₹${CurrencyUtils.formatAmount(amountTotal.toString())}",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDisbursementList() {
    return Obx(() {
      final data = _adminDisbursementController.disbursementList;

      if (data.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No disbursement data available',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(top: 6, bottom: 10),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];

          final itemTotal = (int.tryParse(item.loginCount) ?? 0) +
              (int.tryParse(item.disbursedCount) ?? 0);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xffEEF2FF),
                        child: Icon(Icons.person, color: Colors.indigo),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.name.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "₹${CurrencyUtils.formatAmount(item.amount)}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total: $itemTotal",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              _modernStat(
                                  "Login", item.loginCount, Colors.blue),
                              const SizedBox(width: 6),
                              _modernStat("Disbursed", item.disbursedCount,
                                  Colors.orange),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        },
      );
    });

    //  Padding(

    //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
    //   child: Container(
    //     padding: const EdgeInsets.all(14),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(14),
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.black.withOpacity(.05),
    //           blurRadius: 8,
    //           offset: const Offset(0, 3),
    //         ),
    //       ],
    //     ),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //          HEADER
    //         Row(
    //           children: [
    //             const CircleAvatar(
    //               radius: 18,
    //               backgroundColor: Color(0xffEEF2FF),
    //               child: Icon(Icons.person, color: Colors.indigo),
    //             ),
    //             const SizedBox(width: 10),
    //             Expanded(
    //               child: Text(
    //                 data.name.toString(),
    //                 style: const TextStyle(
    //                   fontWeight: FontWeight.w600,
    //                   fontSize: 14,
    //                 ),
    //               ),
    //             ),
    //             Text(
    //               "Total: $itemTotal",
    //               style: const TextStyle(
    //                 fontSize: 12,
    //                 color: Colors.grey,
    //               ),
    //             ),
    //           ],
    //         ),

    //         const SizedBox(height: 12),

    //          AMOUNT
    //         Text(
    //           "₹${CurrencyUtils.formatAmount(item.amount)}",
    //           style: const TextStyle(
    //             fontSize: 18,
    //             fontWeight: FontWeight.bold,
    //             color: Colors.green,
    //           ),
    //         ),

    //         const SizedBox(height: 10),

    //          STATS
    //         Row(
    //           children: [
    //             _modernStat("Login", item.loginCount, Colors.blue),
    //             const SizedBox(width: 10),
    //             _modernStat("Disbursed", item.disbursedCount, Colors.orange),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    //  Padding(
    //   padding: EdgeInsets.only(top: 4.h, bottom: 10.h),
    //   child: ListView.builder(
    //     itemCount: data.length,
    //     itemBuilder: (context, index) {
    //       final item = data[index];

    //       // Calculate total for this item
    //       final itemTotal = (int.tryParse(item.loginCount) ?? 0) +
    //           (int.tryParse(item.disbursedCount) ?? 0);

    //       return Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
    //         child: SummaryCard(
    //           title: item.name.toString(),
    //           duration: 'Total: $itemTotal',
    //           icon: Icons.person,
    //           rows: [
    //             Wrap(
    //               spacing: 8,
    //               runSpacing: 6,
    //               alignment: WrapAlignment.end,
    //               children: [
    //                 _statChip(
    //                   icon: Icons.currency_rupee,
    //                   label: "Amount",
    //                   value: CurrencyUtils.formatAmount(item.amount),
    //                   color: Colors.green,
    //                 ),
    //                 _statChip(
    //                   icon: Icons.file_copy_outlined,
    //                   label: "Login",
    //                   value: item.loginCount,
    //                   color: Colors.blue,
    //                 ),
    //                 _statChip(
    //                   icon: Icons.check_circle_outline,
    //                   label: "Disbursed",
    //                   value: item.disbursedCount,
    //                   color: Colors.orange,
    //                 ),
    //               ],
    //             )

    //             // Container(
    //             //   padding: EdgeInsets.all(8.h),
    //             //   decoration: BoxDecoration(
    //             //     color: AppColors.appBarTextColor,
    //             //     borderRadius: BorderRadius.circular(15),
    //             //   ),
    //             //   child: Column(
    //             //     crossAxisAlignment: CrossAxisAlignment.end,
    //             //     children: [
    //             //       // Amount
    //             //       Text(
    //             //         '₹${CurrencyUtils.formatAmount(item.amount)}',
    //             //         style: AppTextStyle.blueHeaderTitletStyle.copyWith(
    //             //           fontSize: 14.sp,
    //             //           fontWeight: FontWeight.bold,
    //             //         ),
    //             //       ),
    //             //       SizedBox(height: 8.h),

    //             //       // Login Files
    //             //       Row(
    //             //         mainAxisSize: MainAxisSize.min,
    //             //         children: [
    //             //           RichText(
    //             //             text: TextSpan(
    //             //               children: [
    //             //                 const TextSpan(
    //             //                   text: 'Login Files - ',
    //             //                   style: TextStyle(
    //             //                     color: Colors.grey,
    //             //                     fontSize: 12,
    //             //                   ),
    //             //                 ),
    //             //                 TextSpan(
    //             //                   text: item.loginCount,
    //             //                   style: const TextStyle(
    //             //                     color: Colors.black,
    //             //                     fontSize: 12,
    //             //                     fontWeight: FontWeight.w600,
    //             //                   ),
    //             //                 ),
    //             //               ],
    //             //             ),
    //             //           ),
    //             //           SizedBox(width: 15.w),
    //             //           // Disbursed Files
    //             //           RichText(
    //             //             text: TextSpan(
    //             //               children: [
    //             //                 const TextSpan(
    //             //                   text: 'Disbursed Files - ',
    //             //                   style: TextStyle(
    //             //                     color: Colors.grey,
    //             //                     fontSize: 12,
    //             //                   ),
    //             //                 ),
    //             //                 TextSpan(
    //             //                   text: item.disbursedCount,
    //             //                   style: const TextStyle(
    //             //                     color: Colors.black,
    //             //                     fontSize: 12,
    //             //                     fontWeight: FontWeight.w600,
    //             //                   ),
    //             //                 ),
    //             //               ],
    //             //             ),
    //             //           ),
    //             //         ],
    //             //       ),
    //             //     ],
    //             //   ),
    //             // ),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}

Widget _modernStat(String label, String value, Color color) {
  return Chip(
    padding: EdgeInsets.zero,
    labelPadding: const EdgeInsets.symmetric(horizontal: 6),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
    backgroundColor: color.withOpacity(.08),
    label: Text(
      "$label: $value",
      style: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    ),
  );
}

// Widget _modernStat(String label, String value, Color color) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//     decoration: BoxDecoration(
//       color: color.withOpacity(.08),
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           "$label: ",
//           style: const TextStyle(fontSize: 11, color: Colors.grey),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//       ],
//     ),
//   );
// }
