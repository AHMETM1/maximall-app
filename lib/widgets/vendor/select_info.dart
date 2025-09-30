import 'package:flutter/material.dart';

class SelectInfoData {
  const SelectInfoData({required this.label, required this.value});

  final String label;
  final dynamic value;
}

class SelectInfo extends StatelessWidget {
  final String? title;
  final String? hint;
  final dynamic valueSelected;
  final List<SelectInfoData>? data;
  final Function(dynamic)? onChanged;

  const SelectInfo({
    super.key,
    this.valueSelected,
    this.data,
    this.onChanged,
    this.title,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(width: 8.0),
        Flexible(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return DropdownButton(
                hint: LimitedBox(
                  maxWidth: constraints.maxWidth - 24,
                  child: Text(
                    hint ?? 'Choose item',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                value: valueSelected,
                underline: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down_circle),
                items: List.generate(
                  data!.length,
                  (index) {
                    return DropdownMenuItem(
                      value: data![index].value,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 140),
                        child: Text(
                          data![index].label,
                        ),
                      ),
                    );
                  },
                ),
                onChanged: onChanged,
              );
            },
          ),
        )
      ],
    );
  }
}
