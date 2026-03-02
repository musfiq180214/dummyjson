import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color activeColor;
  final Color inactiveColor;
  final double circleRadius;
  final double lineWidth;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.circleRadius = 12,
    this.lineWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isEven) {
          final stepIndex = index ~/ 2;
          return _buildStep(stepIndex);
        } else {
          final lineIndex = (index - 1) ~/ 2;
          return _buildLine(lineIndex);
        }
      }),
    );
  }

  Widget _buildStep(int stepIndex) {
    final isActive = stepIndex <= currentStep;
    return Container(
      width: circleRadius * 2,
      height: circleRadius * 2,
      decoration: BoxDecoration(
        color: isActive ? activeColor : Colors.white,
        border: Border.all(
          color: isActive ? activeColor : inactiveColor,
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${stepIndex + 1}',
          style: TextStyle(
            color: isActive ? Colors.white : inactiveColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLine(int lineIndex) {
    final isActive = lineIndex < currentStep;
    return Expanded(
      child: Container(
        height: lineWidth,
        color: isActive ? activeColor : inactiveColor,
      ),
    );
  }
}
