import 'package:dummyjson/core/utils/sizes.dart';
import 'package:flutter/material.dart';

// class AppButton extends StatelessWidget {
//   final VoidCallback? ontap;
//   final String text;
//   final Color backgroundColor;
//   final Color? forgroudColor;
//   final Color textColor;
//   final bool isLoading; // 👈 new

//   AppButton({
//     super.key,
//     required this.ontap,
//     required this.backgroundColor,
//     this.forgroudColor,
//     required this.textColor,
//     required this.text,
//     this.isLoading = false, // default false
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: ontap,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//         child: Padding(
//           padding: AppSpacing.paddingM,
//           child: isLoading
//               ? SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//               : Text(
//                   text,
//                   textAlign: TextAlign.center,
//                   style: AppTextStyles.bodyS
//                       .copyWith(color: textColor, fontWeight: FontWeight.bold),
//                 ),
//         ),
//       ),
//     );
//   }
// }

class AppButton extends StatelessWidget {
  final VoidCallback? ontap;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.ontap,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: ontap,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey; // ✅ disabled color
            }
            return backgroundColor; // ✅ enabled color
          }),
        ),
        child: Padding(
          padding: AppSpacing.paddingM,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyS.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
