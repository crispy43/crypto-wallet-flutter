import 'package:flutter/material.dart';
import 'package:crypto_wallet/utils/filters.dart';

class TokenTile extends StatelessWidget {
  const TokenTile({
    Key? key,
    this.backgroundColor,
    this.logo,
    required this.symbol,
    required this.amount,
    required this.decimals,
  }) : super(key: key);

  final Color? backgroundColor;
  final Widget? logo;
  final String symbol;
  final double amount;
  final int decimals;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: SizedBox(
        height: 50.0,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // * 좌측 로고, 심볼
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 20.0,
                        minHeight: 20.0,
                        maxWidth: 20.0,
                        maxHeight: 20.0,
                      ),
                      child: logo,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      symbol,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
              // * 우측 수량
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  toComma(amount, decimals > 4 ? 4 : decimals),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
