import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// class SettingsTile extends StatelessWidget {
//   final String icon;
//   final String title;
//   final VoidCallback onTap;
//
//   const SettingsTile({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 9),
//         child: Row(
//           children: [
//             Container(
//               height: 42,
//               width: 42,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE8ECFF),
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: SvgPicture.asset(
//                   icon,
//                   height: 20,
//                   width: 20,
//                   color: const Color(0xFF3153D8),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFF1B1D28),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             const Icon(
//               Icons.arrow_forward_ios,
//               size: 18,
//               color: Color(0xFF1B1D28),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsTile extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B1B1B),
              Color(0xFF0A0A0A),
            ],
          ),

          border: Border.all(
            color: const Color(0x55D9B65A),
          ),

          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD9B65A).withOpacity(.12),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [

            /// ICON CONTAINER
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,

                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF4E19C),
                    Color(0xFFD9B65A),
                    Color(0xFFB8860B),
                  ],
                ),

                boxShadow: [
                  BoxShadow(
                    color: Color(0x66D9B65A),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  height: 20,
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// TITLE
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            /// ARROW
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Color(0xFFD9B65A),
            ),
          ],
        ),
      ),
    );
  }
}