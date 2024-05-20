import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:crypto_wallet/widgets/forms/outline_text_field.dart';

class SingleTextFieldModal extends StatelessWidget {
  const SingleTextFieldModal({
    Key? key,
    this.backgroundColor,
    this.title,
    this.description,
    this.placeholder,
    this.submitLabel,
    this.willDismiss,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmit,
  }) : super(key: key);

  final Color? backgroundColor;
  final String? title;
  final String? description;
  final String? placeholder;
  final String? submitLabel;
  final bool? willDismiss;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Material(
            color: backgroundColor,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                height: 200.0,
                child: Column(
                  children: [
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          title!,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    if (title != null) const Divider(),
                    if (description != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(description!),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: OutlineTextField(
                        controller: controller,
                        backgroundColor: backgroundColor,
                        autoFocus: true,
                        placeholder: placeholder,
                        onChanged: onChanged,
                        onEditingComplete: onEditingComplete,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (onSubmit != null) onSubmit!();
                          if (willDismiss ?? true) Navigator.pop(context);
                        },
                        child: Text(submitLabel ?? '확인'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<T> showSingleTextFieldModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  String? title,
  String? description,
  String? placeholder,
  String? submitLabel,
  bool? willDismiss,
  TextEditingController? controller,
  void Function(String)? onChanged,
  void Function()? onEditingComplete,
  void Function()? onSubmit,
}) async {
  final result = await showCustomModalBottomSheet(
    context: context,
    builder: builder,
    containerWidget: (_, animation, child) => SingleTextFieldModal(
      backgroundColor: backgroundColor,
      title: title,
      description: description,
      placeholder: placeholder,
      submitLabel: submitLabel,
      willDismiss: willDismiss,
      controller: controller,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmit: onSubmit,
    ),
    expand: false,
  );
  return result;
}
