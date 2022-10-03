import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:flutter_trust_wallet_core_example/base_example.dart';
import 'package:flutter_trust_wallet_core/protobuf/bitcoin.pb.dart' as Bitcoin;
import 'package:fixnum/fixnum.dart' as $fixnum;

class BitcoinTransactionExample extends BaseExample {
  final HDWallet wallet;

  const BitcoinTransactionExample(this.wallet, {Key? key})
      : super('Bitcoin Transaction', key: key);

  @override
  _BitcoinTransactionExampleState createState() =>
      _BitcoinTransactionExampleState();
}

class _BitcoinTransactionExampleState
    extends BaseExampleState<BitcoinTransactionExample> {
  @override
  void initState() {
    super.initState();
    int coin = TWCoinType.TWCoinTypeBitcoin;
    final addressBtc = widget.wallet.getAddressForCoin(coin);
    final toAddress = "1Bp9U1ogV3A14FMvKbRJms7ctyso4Z4Tcx";
    final changeAddress = "1FQc5LdgGHMHEN9nwkjmz6tWkxhPpxBvBU";
    final secretPrivateKeyBtc = widget.wallet.getKeyForCoin(coin);
    final signingInput = Bitcoin.SigningInput(
      amount: $fixnum.Int64.parseInt('600'),
      hashType: BitcoinScript.hashTypeForCoin(coin),
      toAddress: toAddress,
      changeAddress: changeAddress,
      byteFee: $fixnum.Int64.parseInt('1'),
      coinType: coin,
      utxo: [
        Bitcoin.UnspentTransaction(
          amount: $fixnum.Int64.parseInt('5151'),
          outPoint: Bitcoin.OutPoint(
            hash: hex
                .decode(
                    '1b23757cdc023b3ac9f033522abb9f845815b65cce1e25411e8ad950899c0e71')
                .reversed
                .toList(),
            index: 0,
            sequence: 4294967295,
          ),
          script: BitcoinScript.lockScriptForAddress(addressBtc, coin)
              .data()
              .toList(),
        ),
      ],
      privateKey: [
        secretPrivateKeyBtc.data().toList(),
      ],
    );
    final transactionPlan = Bitcoin.TransactionPlan.fromBuffer(
        AnySigner.signerPlan(signingInput.writeToBuffer(), coin).toList());
    logger.d(
        'availableAmount: ${transactionPlan.availableAmount} amount: ${transactionPlan.amount} fee: ${transactionPlan.fee} change: ${transactionPlan.change}');
    print(
        'availableAmount: ${transactionPlan.availableAmount} amount: ${transactionPlan.amount} fee: ${transactionPlan.fee} change: ${transactionPlan.change}');
    signingInput.plan = transactionPlan;
    signingInput.amount = transactionPlan.amount;
    final sign = AnySigner.sign(signingInput.writeToBuffer(), coin);
    final signingOutput = Bitcoin.SigningOutput.fromBuffer(sign);
    print(hex.encode(signingOutput.encoded));
    logger.d(hex.encode(signingOutput.encoded));
  }
}
