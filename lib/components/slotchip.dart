import 'package:flutter/material.dart';

class SlotChip extends StatelessWidget {
 const SlotChip({Key? key, required this.text, required this.index, required this.onTap, this.isSelected = -1})
      : super(key: key);
  final String text;
  final int index;
  final Function(bool) onTap;
  final int isSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      onSelected: onTap,
      disabledColor: Colors.grey.shade300,
      backgroundColor: Colors.grey.shade200,
      selectedColor: Colors.green,
      label: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
      selected: isSelected == index,
    );
  }
}
