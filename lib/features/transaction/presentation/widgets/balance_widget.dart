import 'package:flutter/material.dart';
import 'package:ppob/core/core.dart';
import 'package:ppob/features/transaction/transaction.dart';
import 'package:provider/provider.dart';

class BalanceWidget extends StatefulWidget {
  const BalanceWidget({super.key});

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  final isVisible = ValueNotifier(true);
  final amount = ValueNotifier('');

  Future<void> fetch() async {
    context.read<TransactionProvider>().balance();
  }

  String maskString(String input) {
    amount.value = '•' * input.length;
    return amount.value;
  }

  String unmaskString(String original) {
    amount.value = original;
    return amount.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.19,
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            builder: (context, balance, child) {
              String formatString() {
                if (balance.result != null) {
                  return CurrencyFormat.formatNumber('${balance.result?.balance}');
                }
                return '';
              }

              return ValueListenableBuilder(
                valueListenable: isVisible,
                builder: (context, v, _) {
                  if (isVisible.value) {
                    maskString(formatString());
                  }
                  return ValueListenableBuilder(
                    valueListenable: amount,
                    builder: (context, v, _) {
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
                              children: [TextSpan(text: amount.value)],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Lihat saldo',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              IconButton(
                                onPressed: () {
                                  isVisible.value = !isVisible.value;
                                  if (isVisible.value) {
                                    maskString(formatString());
                                  } else {
                                    unmaskString(formatString());
                                  }
                                },
                                icon: Icon(
                                  isVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
