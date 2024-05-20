import 'package:flutter/material.dart';
import 'package:crypto_wallet/constants/style_constants.dart';
import 'package:crypto_wallet/controllers/eth_controller.dart';
import 'package:crypto_wallet/widgets/icons/theme_icon.dart';
import 'package:crypto_wallet/widgets/modals/networks_modal.dart';

class NetworkAppBar extends StatefulWidget implements PreferredSizeWidget {
  const NetworkAppBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  final Size preferredSize = const Size.fromHeight(appBarHeight);

  final EthController controller;

  @override
  State<NetworkAppBar> createState() => _NetworkAppBarState();
}

class _NetworkAppBarState extends State<NetworkAppBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: AppBar(
        centerTitle: true,
        // leading: IconButton(
        //   icon: const ThemeIcon(
        //     Icons.menu_rounded,
        //   ),
        //   onPressed: () => Scaffold.of(context).openDrawer(),
        // ),
        // actions: [
        //   IconButton(
        //     icon: const ThemeIcon(Icons.notifications_outlined),
        //     onPressed: () => null,
        //   )
        // ],
        title: InkWell(
          onTap: () => showNetworksModal<void>(
            context: context,
            controller: widget.controller,
            builder: (BuildContext context) {
              return NetworksModal(controller: widget.controller);
            },
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // TODO: Network 동적 변경 추가할 것
            children: [
              Text(
                "${widget.controller.network.name[0].toUpperCase()}${widget.controller.network.name.substring(1)}",
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
              const ThemeIcon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
