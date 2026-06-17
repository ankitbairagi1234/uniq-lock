import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// class RoundedField extends StatelessWidget {
//   final String iconPath;
//   final String text;
//   final VoidCallback? onTap;
//   final double verticalPadding;
//   final Widget? trailing;
//
//   const RoundedField({
//     super.key,
//     required this.iconPath,
//     required this.text,
//     this.onTap,
//     this.verticalPadding = 18,
//     this.trailing,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final radius = 18.0;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(radius),
//           border: Border.all(color: Colors.grey.shade200),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12.withOpacity(0.02),
//               blurRadius: 6,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             SvgPicture.asset(
//               iconPath,
//               width: 20,
//               height: 20,
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 text,
//                 style: TextStyle(fontSize: 15, color: Colors.black87),
//               ),
//             ),
//             if (trailing != null) trailing!,
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundedField extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback? onTap;
  final double verticalPadding;
  final Widget? trailing;

  const RoundedField({
    super.key,
    required this.iconPath,
    required this.text,
    this.onTap,
    this.verticalPadding = 18,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final radius = 18.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B1B1B),
              Color(0xFF0A0A0A),
            ],
          ),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: const Color(0x55D9B65A),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD9B65A).withOpacity(.10),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Color(0xFFD9B65A),
                BlendMode.srcIn,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (trailing != null) trailing!,

            if (trailing == null)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFFD9B65A),
              ),
          ],
        ),
      ),
    );
  }
}