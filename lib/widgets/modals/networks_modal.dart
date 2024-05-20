import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:crypto_wallet/controllers/eth_controller.dart';
import 'package:crypto_wallet/widgets/icons/theme_icon.dart';

class NetworksModal extends StatelessWidget {
  const NetworksModal({
    Key? key,
    required this.controller,
    this.backgroundColor,
  }) : super(key: key);

  final EthController controller;
  final Color? backgroundColor;

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
            child: SizedBox(
              height: 40.0 * controller.options.length,
              child: ListView.separated(
                itemCount: controller.options.length,
                separatorBuilder: (context, _) => const Divider(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      controller.changeNetwork(controller.options[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        height: 40.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.options[index].name.toUpperCase(),
                            ),
                            if (controller.options[index].chainId ==
                                controller.network.chainId)
                              const ThemeIcon(Icons.done),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<T> showNetworksModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required EthController controller,
  Color? backgroundColor,
}) async {
  final result = await showCustomModalBottomSheet(
    context: context,
    builder: builder,
    containerWidget: (_, animation, child) => NetworksModal(
      controller: controller,
      backgroundColor: backgroundColor,
    ),
    expand: false,
  );
  return result;
}
