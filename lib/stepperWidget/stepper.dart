import 'package:flutter/material.dart';

class StepperHeader extends StatelessWidget {
  final List<IconData> stepIcons;
  final int currentStep;
  final List<String> steps;

  const StepperHeader({
    Key? key,
    required this.stepIcons,
    required this.currentStep,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          bool isCompleted = index < currentStep;
          bool isCurrentStep = index == currentStep;

          return Expanded(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Animated container for the filling effect
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: isCurrentStep || isCompleted ? 50 : 30,
                      height: isCurrentStep || isCompleted ? 50 : 30,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.deepPurple
                            : isCurrentStep
                                ? Colors.deepPurple.shade200
                                : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        stepIcons[index],
                        color: Colors.white,
                        size: isCurrentStep || isCompleted ? 30 : 20,
                      ),
                    ),
                    if (index != 0)
                      Positioned(
                        left: -50,
                        right: null,
                        top: 0,
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 50,
                          height: 2,
                          color: isCompleted
                              ? Colors.deepPurple
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: isCurrentStep ? 14 : 12,
                    fontWeight:
                        isCurrentStep ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted
                        ? Colors.deepPurple
                        : isCurrentStep
                            ? Colors.deepPurple
                            : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
