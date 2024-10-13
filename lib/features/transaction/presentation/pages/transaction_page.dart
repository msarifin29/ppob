// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'package:ppob/features/transaction/transaction.dart';

class TransactionPage extends StatefulWidget {
  static const routeName = 'transaction';
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TransactionHistoryProvider>(context, listen: false);
    provider.fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopUpwidget(),
            const Gap(20),
            Text(
              'Transaksi',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(10),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.56,
              child: Consumer<TransactionHistoryProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.records.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.records.length,
                          itemBuilder: (context, index) {
                            final record = provider.records[index];
                            return TransactionCard(record: record);
                          },
                        ),
                      ),
                      if (!provider.isLastPage)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextButton(
                            onPressed: provider.isLoading
                                ? null
                                : () {
                                    provider.fetchTransactions(loadMore: true);
                                  },
                            child: provider.isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                : const Text('Show More', style: TextStyle(color: Colors.red)),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
