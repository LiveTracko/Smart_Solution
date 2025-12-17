import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/text_style.dart';

/// ============= MAIN ATTENDANCE DETAILS MENU =============

class AttendenceDetailPage extends StatelessWidget {
  const AttendenceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Attendance Details',
      body: ListView(
        children: [
          _menuTile(
            context,
            title: 'Attendance Modes',
            subtitle: 'Punch type & GPS / QR / Selfie',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AttendanceModesScreen()),
            ),
          ),
          _menuTile(
            context,
            title: 'Automation Rules',
            subtitle: 'Auto present / half day rules',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AutomationRulesScreen()),
            ),
          ),
          _menuTile(
            context,
            title: 'Leave History',
            subtitle: 'Past leave records',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LeaveHistoryScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

/// ============= 1. ATTENDANCE MODES SCREEN =============
class AttendanceModesScreen extends StatefulWidget {
  const AttendanceModesScreen({super.key});

  @override
  State<AttendanceModesScreen> createState() => _AttendanceModesScreenState();
}

class _AttendanceModesScreenState extends State<AttendanceModesScreen> {
  bool allowPunchFromStaffApp = true;
  bool selfieAttendance = true;
  bool qrAttendance = true;
  bool gpsAttendance = true;
  String markFrom = 'office';

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Attendance Modes',
      body: Column(
        children: [
          // TOP WHITE SECTION
          Container(
            width: double.infinity,
            color: const Color(0xffFFFFFF),
            padding: const EdgeInsets.all(12),
            child: const Text(
              'Attendance Modes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 5, 6, 8),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ===================== GREY AREA START =====================
          Container(
            width: double.infinity,
            color: _AutomationRulesScreenState.greyBg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                // 1st CARD
                Card(
                  color: Color(0xffFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    child: _switchRow(
                      title: 'Allow Punch in From Staff App',
                      value: allowPunchFromStaffApp,
                      onChanged: (v) =>
                          setState(() => allowPunchFromStaffApp = v),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 2nd CARD (Selfie + QR + GPS)
                Card(
                  color: const Color(0xffFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Column(
                    children: [
                      _iconSwitchRow(
                        svgPath: 'assets/hrms/user.svg',
                        title: 'Selfie Attendance',
                        value: selfieAttendance,
                        onChanged: (v) => setState(() => selfieAttendance = v),
                      ),
                      const Divider(height: 1),
                      _iconSwitchRow(
                        svgPath: 'assets/hrms/briefcase-01.svg',
                        title: 'QR Attendance',
                        value: qrAttendance,
                        onChanged: (v) => setState(() => qrAttendance = v),
                      ),
                      const Divider(height: 1),
                      _iconSwitchRow(
                        svgPath: 'assets/hrms/calendar-check-02.svg',
                        title: 'GPS Attendance',
                        value: gpsAttendance,
                        onChanged: (v) => setState(() => gpsAttendance = v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 3rd CARD (Radio)
                Card(
                  color: Color(0xffFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mark Attendance From',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF344054),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Radio(
                              value: 'office',
                              //ignore:deprecated_member_use
                              groupValue: markFrom,
                              //ignore:deprecated_member_use
                              onChanged: (v) => setState(() => markFrom = v!),
                              activeColor: Color(0xFF2F6DF6),
                            ),
                            const Text("Office"),
                            const SizedBox(width: 16),
                            Radio(
                              value: 'anywhere',
                              //ignore:deprecated_member_use
                              groupValue: markFrom,
                              //ignore:deprecated_member_use
                              onChanged: (v) => setState(() => markFrom = v!),
                              activeColor: Color(0xFF2F6DF6),
                            ),
                            const Text("Anywhere"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 100.h),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F6DF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Save Details',
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _switchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: AppTextStyle.headerTitle),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          //ignore:deprecated_member_use
          activeColor: Colors.white,
          activeTrackColor: Color(0xff12AF69),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFF3F4F6),
        ),
      ],
    );
  }

  Widget _iconSwitchRow({
    required String svgPath,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        children: [
          SvgPicture.asset(svgPath, width: 24, height: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.headerTitle,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            
            //ignore:deprecated_member_use
            activeColor: Colors.white,
            activeTrackColor: Color(0xff12AF69),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFF3F4F6),
          ),
        ],
      ),
    );
  }
}

/// ============= 2. AUTOMATION RULES SCREEN =============

class AutomationRulesScreen extends StatefulWidget {
  const AutomationRulesScreen({super.key});

  @override
  State<AutomationRulesScreen> createState() => _AutomationRulesScreenState();
}

class _AutomationRulesScreenState extends State<AutomationRulesScreen> {
  // interactive state for switches
  bool autoPresentAtStart = true;
  bool presentOnPunchIn = true;

  TimeOfDay _lateByTime = const TimeOfDay(hour: 11, minute: 0);
  String _halfDayHours = '04';
  String _fullDayHours = '09';

  static const Color primaryBlue = Color(0xFF2F6DF6);
  // static const Color activeGreen = Color(0xff12AF69);
  static const Color greyBg = Color(0xFFF2F4F7);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _lateByTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: primaryBlue)),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _lateByTime = picked);
  }

  Future<void> _pickHalfHours() async {
    final value = await _pickNumber(['03', '04', '05', '06'], _halfDayHours);
    if (value != null) setState(() => _halfDayHours = value);
  }

  Future<void> _pickFullHours() async {
    final value = await _pickNumber(['07', '08', '09', '10'], _fullDayHours);
    if (value != null) setState(() => _fullDayHours = value);
  }

  Future<String?> _pickNumber(List<String> options, String current) async {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (v) => ListTile(
                    title: Text(v),
                    trailing: v == current ? const Icon(Icons.check) : null,
                    onTap: () => Navigator.pop(context, v),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // small card builder (rounded white box with shadow)
  Widget _smallCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDEDED)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  // custom styled compact switch to better match screenshot
  Widget _styledSwitch(bool value, ValueChanged<bool> onChanged) {
    return SizedBox(
      width: 54,
      height: 30,
      child: Transform.scale(
        scale: 1.0,
        child: Switch(
          value: value,
          onChanged: onChanged,
          //ignore:deprecated_member_use
          activeColor: Colors.white,
          activeTrackColor: Color(0xff12AF69),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFF3F4F6),
        ),
      ),
    );
  }

  // right small white box for dropdown/time
  Widget _box(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 253, 252, 252),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color.fromARGB(255, 210, 209, 209)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _cardRow({
    required String title,
    Widget? trailing,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 14,
    ),
  }) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // list of cards (each separate white rounded box with gap between)
    final cardList = <Widget>[
      _smallCard(
        child: _cardRow(
          title: 'Auto Present at Day Start',
          trailing: _styledSwitch(
            autoPresentAtStart,
            (v) => setState(() => autoPresentAtStart = v),
          ),
        ),
      ),
      _smallCard(
        child: _cardRow(
          title: 'Present on punch in',
          trailing: _styledSwitch(
            presentOnPunchIn,
            (v) => setState(() => presentOnPunchIn = v),
          ),
        ),
      ),
      _smallCard(
        child: _cardRow(
          title: 'Auto half day if late by',
          trailing: _box(_formatTime(_lateByTime), onTap: _pickTime),
        ),
      ),
      _smallCard(
        child: _cardRow(
          title: 'Mandatory Half Day Hours',
          trailing: _box(_halfDayHours, onTap: _pickHalfHours),
        ),
      ),
      _smallCard(
        child: _cardRow(
          title: 'Mandatory Full Day Hours',
          trailing: _box(_fullDayHours, onTap: _pickFullHours),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: greyBg,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        leading: const BackButton(color: Color(0xffFFFFFF)),
        title: const Text(
          'Automation Rules',
          style: TextStyle(
            color: Color(0xffFFFFFF),
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      // Using ListView so grey gaps show between cards and header stays white
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // TOP WHITE HEADER BAR
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Attendance Modes',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color.fromARGB(255, 5, 6, 8),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Cards with gaps (grey bg shows in between)
                for (int i = 0; i < cardList.length; i++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: cardList[i],
                  ),
                  if (i != cardList.length - 1) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Stack(
              children: [
                Container(color: Color(0xffFFFFFF), height: 400),
                Positioned(
                  bottom: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 400,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F6DF6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Save Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Save button correctly placed in bottomNavigationBar
      // bottomNavigationBar: SafeArea(
      //   minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      //     child: SizedBox(
      //       width: double.infinity,
      //       height: 50,
      //       child: ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: primaryBlue,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //         ),
      //         onPressed: () {
      //           // Save action
      //         },
      //         child: const Text(
      //           'Save Details',
      //           style: TextStyle(
      //             color: Color(0xffFFFFFF),
      //             fontWeight: FontWeight.w600,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
    );
  }
}

/// ============= 4. LEAVE HISTORY SCREEN =============

class LeaveHistoryScreen extends StatelessWidget {
  const LeaveHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AutomationRulesScreenState.greyBg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F6DF6),
        elevation: 0,
        leading: const BackButton(color: Color(0xffFFFFFF)),
        title: const Text(
          'Leave History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.menu), onPressed: () {})],
      ),

      // main content
      body: SafeArea(
        child: Column(
          children: [
            // add a little top spacing similar to screenshot
            const SizedBox(height: 12),

            // list of cards expands
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: const [
                  _LeaveHistoryCard(
                    date: '24th Feb 2025',
                    type: 'CASUAL LEAVE',
                    status: 'APPROVED',
                    statusColor: Colors.green,
                    svgPath: 'assets/images/Frame.svg',
                  ),
                  _LeaveHistoryCard(
                    date: '20th Jan 2025',
                    type: 'CASUAL LEAVE',
                    status: 'NOT APPROVED',
                    statusColor: Colors.red,
                    svgPath: 'assets/images/Frame.svg',
                  ),
                  _LeaveHistoryCard(
                    date: '3rd Dec 2024',
                    type: 'CASUAL LEAVE',
                    status: 'PENDING',
                    statusColor: Colors.orange,
                    svgPath: 'assets/images/Frame.svg',
                  ),

                  // add extra space so list doesn't hide behind bottom bar
                  SizedBox(height: 60),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Stack(
                children: [
                  Expanded(
                    child: Container(color: Color(0xffFFFFFF), height: 550),
                  ),
                  Positioned(
                    bottom: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 400,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2F6DF6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Request Leave',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // pinned bottom button (like screenshot)
      // bottomNavigationBar: SafeArea(
      //   top: false,
      //   child: Container(
      //     color: const Color.fromARGB(0, 253, 253, 253),
      //     padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      //     child: SizedBox(
      //       height: 48,
      //       width: double.infinity,
      //       child: ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: const Color(0xFF2F6DF6),
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //           elevation: 0,
      //         ),
      //         onPressed: () {},
      //         child: const Text(
      //           'Request Leave',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontWeight: FontWeight.w600,
      //             fontSize: 16,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

class _LeaveHistoryCard extends StatelessWidget {
  final String date;
  final String type;
  final String svgPath;
  final String status;
  final Color statusColor;

  const _LeaveHistoryCard({
    required this.svgPath,
    required this.date,
    required this.type,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                // left icon box (small rounded rectangle with icon inside)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(svgPath, fit: BoxFit.contain),
                  ),
                  //  Center(
                  //   child: SizedBox(
                  //     width: 28,
                  //     height: 28,
                  //     child: ClipOval(
                  //       child: SvgPicture.asset(svgPath, fit: BoxFit.fill),
                  //     ),
                  //   ),
                  // ),
                ),

                const SizedBox(width: 12),

                // date + type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // status chip aligned right
                _StatusChip(text: status, color: statusColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  const _StatusChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
