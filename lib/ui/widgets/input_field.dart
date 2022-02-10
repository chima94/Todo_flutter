import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:task_flutter/ui/theme.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? textEditingController;
  final Widget? widget;

  const MyInputField({
    Key? key,
    required this.title,
    required this.hint,
    this.textEditingController,
    this.widget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 14),
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                      readOnly: widget == null ? false : true,
                      autofocus: false,
                      cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                      controller: textEditingController,
                      style: subTitleStyle,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subTitleStyle,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.backgroundColor,
                            width: 0
                          )
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.backgroundColor,
                                width: 0
                            )
                        )
                      ),
                    )
                ),
                widget == null ? Container() : Container(child: widget,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
