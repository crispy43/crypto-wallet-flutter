import 'package:flutter/material.dart';
import 'package:crypto_wallet/constants/style_constants.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleAppBar(
    this.title, {
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  final Size preferredSize = const Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
    );
  }
}
