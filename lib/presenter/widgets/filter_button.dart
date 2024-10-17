import 'package:flutter/material.dart';
import 'package:treeview_tractian/presenter/utils/colors.dart';
import 'package:treeview_tractian/presenter/widgets/image.dart';
import 'package:treeview_tractian/presenter/widgets/text.dart';

class FilterItem<T> {
  bool enabled = false;
  bool isSelect = false;
  T value;
  String text;
  String iconSelected;
  String iconDefault;

  FilterItem(
      {required this.enabled,
      required this.isSelect,
      required this.value,
      required this.text,
      required this.iconDefault,
      required this.iconSelected});
}

class FilterGroupWidget<T> extends StatefulWidget {
  final List<FilterItem<T>> list;
  final Function onChanged;
  final bool oneMandatorySelection;

  const FilterGroupWidget(
      {super.key,
      required this.list,
      required this.onChanged,
      this.oneMandatorySelection = false});

  @override
  FilterGroupWidgetState createState() => FilterGroupWidgetState();
}

class FilterGroupWidgetState extends State<FilterGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: List<Widget>.generate(widget.list.length, (index) {
        return _buildRadio(index);
      }),
    );
  }

  _buildRadio(int index) {
    final radio = widget.list[index];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: radio.isSelect ? AppColors.blue : AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
            color: radio.isSelect ? AppColors.blue : AppColors.neutralGrey200),
      ),
      child: InkWell(
        onTap: !radio.enabled
            ? null
            : () {
                setState(() {
                  final interable =
                      widget.list.where((element) => element.isSelect);
                  // nao existe um item selecionado
                  if (interable.isEmpty) {
                    widget.list[index].isSelect = true;
                    widget.onChanged(radio);
                  } else if (interable.isNotEmpty &&
                      interable.first.value == radio.value &&
                      !widget.oneMandatorySelection) {
                    // existe um item selecionado e quero desmarcar ele
                    for (var element in widget.list) {
                      element.isSelect = false;
                    }
                    widget.onChanged(null);
                  } else {
                    for (var element in widget.list) {
                      element.isSelect = false;
                    }
                    widget.list[index].isSelect = true;
                    widget.onChanged(radio);
                  }
                });
              },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImage(
              asset: radio.isSelect ? radio.iconSelected : radio.iconDefault,
              color:
                  radio.isSelect ? AppColors.white : AppColors.neutralGrey500,
            ).fromAsset(width: 9, height: 9),
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: CustomText(
                      value: radio.text,
                      color: radio.isSelect
                          ? AppColors.white
                          : AppColors.greyBodyText)
                  .filterButton,
            ),
          ],
        ),
      ),
    );
  }
}
