import 'package:flutter/material.dart';
import 'package:ppob/core/core.dart';
import 'package:ppob/features/transaction/transaction.dart';
import 'package:provider/provider.dart';

class TopUpwidget extends StatelessWidget {
  const TopUpwidget({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> fetch() async {
      context.read<TransactionProvider>().balance();
    }

    return Container(
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
            builder: (context, balance, child) {
              String amount() {
                if (balance.result != null) {
                  return CurrencyFormat.formatNumber('${balance.result?.balance}');
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
                      children: [TextSpan(text: amount())],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
