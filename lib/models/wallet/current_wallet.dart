// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:crypto_wallet/databases/adaptors/base_key_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/wallet_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/wallet_branch_adaptor.dart';

class CurrentWallet {
  Wallet wallet;
  WalletBranch walletBranch;
  BaseKey baseKey;
  CurrentWallet({
    required this.wallet,
    required this.walletBranch,
    required this.baseKey,
  });

  CurrentWallet copyWith({
    Wallet? wallet,
    WalletBranch? walletBranch,
    BaseKey? baseKey,
  }) {
    return CurrentWallet(
      wallet: wallet ?? this.wallet,
      walletBranch: walletBranch ?? this.walletBranch,
      baseKey: baseKey ?? this.baseKey,
    );
  }

  @override
  String toString() =>
      'CurrentWallet(wallet: $wallet, walletBranch: $walletBranch, baseKey: $baseKey)';

  @override
  bool operator ==(covariant CurrentWallet other) {
    if (identical(this, other)) return true;

    return other.wallet == wallet &&
        other.walletBranch == walletBranch &&
        other.baseKey == baseKey;
  }

  @override
  int get hashCode =>
      wallet.hashCode ^ walletBranch.hashCode ^ baseKey.hashCode;
}
