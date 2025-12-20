import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:rxdart/utils.dart';

typedef OnSortSelected = void Function(Sorting);

class SortPicker extends ConsumerStatefulWidget {
  final bool useSliver;
  final OnSortSelected onSortSelected;
  const SortPicker({
    required this.useSliver,
    required this.onSortSelected,
    super.key,
  });

  @override
  ConsumerState<SortPicker> createState() => _SortPickerState();
}

class _SortPickerState extends ConsumerState<SortPicker> {
  Sorting selectedSort = Sorting.aToz;

  @override
  Widget build(BuildContext context) {
    if (widget.useSliver) {
      return SliverToBoxAdapter(child: buildRow());
    } else {
      return buildRow();
    }
  }

  Widget buildRow() {
    return Row(
      children: [
        const Spacer(),
        // Glassmorphic Sort Button
        Container(
          height: 36,
          margin: const EdgeInsets.only(right: 20), // Added spacing from edge
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: PopupMenuButton<Sorting>(
            offset: const Offset(0, 40),
            color: const Color(0xFF1E1E1E).withOpacity(0.9), // Darker, simpler background for dropdown for better readability
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                addHorizontalSpace(8),
                Text(
                  selectedSort.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                addHorizontalSpace(4),
                const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 20),
                addHorizontalSpace(4),
              ],
            ),
            onSelected: (Sorting value) {
              widget.onSortSelected(value);
            },
            itemBuilder: (BuildContext context) {
              return Sorting.values.mapIndexed<PopupMenuItem<Sorting>>((
                int index,
                Sorting sort,
              ) {
                return PopupMenuItem<Sorting>(
                  value: sort,
                  onTap: () {
                    setState(() {
                      selectedSort = sort;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        selectedSort == sort
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: selectedSort == sort ? Colors.white : Colors.grey,
                        size: 18,
                      ),
                      addHorizontalSpace(12),
                      Text(
                        sort.name,
                        style: TextStyle(
                          color: selectedSort == sort ? Colors.white : Colors.grey,
                          fontWeight: selectedSort == sort ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ),
      ],
    );
  }
}
