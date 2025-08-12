import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String count;
  final Color backgroundColor;
  final IconData icon; // Use IconData instead of Icon

  const DashboardCard({
    Key? key,
    required this.title,
    required this.count,
    required this.backgroundColor,
    required this.icon, // Use icon as IconData
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r), // Responsive border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(15.sp), // Responsive padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp, // Responsive font size
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20.h), // Responsive height
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 15.r, // Responsive radius
                  backgroundColor: Colors.grey[50],
                  child: Icon(
                    icon, // Use icon variable
                    size: 20.sp, // Responsive icon size
                    color: const Color.fromRGBO(231, 156, 181, 1),
                  ),
                ),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 25.sp, // Responsive font size
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCardNew extends StatelessWidget {
  final String title;
  final String count;
  final String fileCount;
  final Color backgroundColor;
  final IconData icon; // Use IconData instead of Icon

  const DashboardCardNew({
    Key? key,
    required this.title,
    required this.count,
    required this.backgroundColor,
    required this.fileCount,
    required this.icon, // Use icon as IconData
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 150.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r), // Responsive border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(15.sp), // Responsive padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp, // Responsive font size
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            // SizedBox(height: 20.h), // Responsive height
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // CircleAvatar(
                //   radius: 15.r, // Responsive radius
                //   backgroundColor: Colors.grey[50],
                //   child: Icon(
                //     icon, // Use icon variable
                //     size: 20.sp, // Responsive icon size
                //     color: const Color.fromRGBO(231, 156, 181, 1),
                //   ),
                // ),
                // SizedBox(width: 12.w,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisSize: MainAxisSize.min ,
                  children: [
                    Flexible(
                      child: Text(
                        "Rs $count",
                        style: TextStyle(
                          fontSize: 18.sp, // Responsive font size
                          fontWeight: FontWeight.w200,
                          color: Colors.black,

                        ),
                      ),),
                    Flexible(
                      child: Text(
                        "$fileCount file",
                        style: TextStyle(
                          fontSize: 18.sp, // Responsive font size
                          fontWeight: FontWeight.w200,
                          color: Colors.black,

                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
