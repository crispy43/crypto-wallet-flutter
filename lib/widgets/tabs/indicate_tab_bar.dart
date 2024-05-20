import 'package:flutter/material.dart';

class IndicateTabBar extends StatelessWidget {
  const IndicateTabBar({
    Key? key,
    required this.controller,
    required this.tabs,
  }) : super(key: key);

  final TabController controller;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      unselectedLabelColor: const Color(0xffadb4ba),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
      labelColor: Color(0xff484848),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14.0,
      ),
      indicatorColor: Color(0xff484848),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 1.5,
      // indicatorPadding: EdgeInsets.only(bottom: 5.0),
      tabs: tabs,
    );
  }
}

// * 탭바 사이즈 고정 위젯
class SizedTab extends StatelessWidget {
  const SizedTab({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;
  static const double height = 40.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: Tab(text: label),
    );
  }
}
