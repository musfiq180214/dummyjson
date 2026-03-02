import 'package:flutter/material.dart';

class RoundedRadioGroup<T> extends StatelessWidget {
  final T selectedValue;
  final List<RadioOption<T>> options;
  final ValueChanged<T> onChanged;

  const RoundedRadioGroup({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((opt) {
        final isSelected = selectedValue == opt.value;
        return InkWell(
          onTap: () => onChanged(opt.value),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.withOpacity(0.2) : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.green : Colors.grey.shade400,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Radio<T>(
                  value: opt.value,
                  groupValue: selectedValue,
                  onChanged: (val) => onChanged(val as T),
                  activeColor: Colors.green,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -1,
                  ),
                ),
                Expanded(child: Text(opt.label)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class RadioOption<T> {
  final String label;
  final T value;

  RadioOption({required this.label, required this.value});
}
