import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterOption extends StatelessWidget {
  const FilterOption({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      'Item2',
      'Item3',
      'Item4',
    ];
    String? selectedValue;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Text(
          'Filters',
          style: TextStyle(
              fontSize: 14,
              color: Color(0xff9CA3AF)
          ),
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {},
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 110,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
