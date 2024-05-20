import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeModal extends StatelessWidget {
  const QrCodeModal({
    Key? key,
    this.backgroundColor,
    required this.address,
  }) : super(key: key);

  final Color? backgroundColor;
  final String address;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          color: backgroundColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: QrImage(data: address),
          ),
        ),
      ),
    );
  }
}

Future<T> showQrCodeModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  required String address,
}) async {
  final result = await showCustomModalBottomSheet(
    context: context,
    builder: builder,
    containerWidget: (_, animation, child) => QrCodeModal(
      backgroundColor: backgroundColor,
      address: address,
    ),
    expand: false,
  );
  return result;
}
