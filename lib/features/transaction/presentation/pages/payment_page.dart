// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ppob/core/core.dart';
import 'package:ppob/features/common/common.dart';

import 'package:ppob/features/transaction/transaction.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatelessWidget {
  static const routeName = 'payment';
  const PaymentPage({
    super.key,
    required this.serviceIcon,
    required this.serviceName,
    required this.serviceCode,
    required this.amount,
  });
  final String serviceIcon;
  final String serviceName;
  final String serviceCode;
  final String amount;

  @override
  Widget build(BuildContext context) {
    Future<void> fetch() async {
      context.read<TransactionProvider>().balance();
    }

    double totalBalance = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PemBayaran'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.15,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage(ImageName.backgroundSaldo),
                  fit: BoxFit.cover,
                ),
              ),
              child: FutureBuilder(
                future: fetch(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: ElevatedButton.icon(
                        onPressed: () => fetch(),
                        label: const Text('Muat ulang'),
                        icon: const Icon(Icons.sync),
                      ),
                    );
                  }
                  return Consumer<TransactionProvider>(
                    builder: (context, transaction, child) {
                      if (transaction.isUpdatePayment) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            if (transaction.errorMessage != null) {
                              dialogSuccessOrFailure(
                                context: context,
                                amount: amount,
                                message: '$serviceName sebesar',
                              );
                            } else {
                              dialogSuccessOrFailure(
                                context: context,
                                amount: amount,
                                message: '$serviceName sebesar',
                                isSuccess: true,
                              );
                            }
                            transaction.resetUpdatePayment();
                          },
                        );
                      }
                      String amountString() {
                        if (transaction.result != null) {
                          totalBalance = transaction.result?.balance.toDouble() ?? 0.0;
                          return CurrencyFormat.formatNumber('${transaction.result?.balance}');
                        }
                        return '';
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Saldo anda',
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Rp ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              children: [TextSpan(text: amountString())],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const Gap(50),
            Text(
              'Pembayaran',
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
            const Gap(10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: serviceIcon,
                  fit: BoxFit.cover,
                  height: 35,
                  width: 35,
                  progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                    height: 25,
                    width: 25,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.image),
                ),
                const Gap(5),
                Text(
                  serviceName,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Gap(20),
            FormWidget(
              hintText: amount,
              readOnly: true,
              prefixIcon: const Icon(Icons.money),
            ),
            Gap(MediaQuery.sizeOf(context).height * 0.3),
            Consumer<TransactionProvider>(
              builder: (context, transaction, child) {
                return PrimaryButton(
                    onPressed: () {
                      final inputAmount =
                          double.tryParse(amount.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
                      if (inputAmount > totalBalance) {
                        insufficientBalance(context: context);
                      } else {
                        confirmTopUp(
                          context: context,
                          amount: CurrencyFormat.formatNumber(amount),
                          messsage: serviceName,
                          titleButton: 'Bayar',
                          onPressed: () {
                            context.read<TransactionProvider>().payment(serviceCode);
                            Navigator.pop(context);
                          },
                        );
                      }
                    },
                    text: 'Bayar');
              },
            ),
          ],
        ),
      ),
    );
  }
}
