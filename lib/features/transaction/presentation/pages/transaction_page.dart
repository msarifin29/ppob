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
    Provider.of<TransactionHistoryProvider>(context, listen: false).fetchTransactions();
  }

  Future<dynamic> onRefresh() async {
    Provider.of<TransactionHistoryProvider>(context, listen: false).refreshTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await onRefresh();
        return Future.delayed(const Duration(milliseconds: 300));
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaksi'),
          centerTitle: true,
          surfaceTintColor: Colors.white,
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  builder: (context, transaction, child) {
                    if (transaction.records.isEmpty) {
                      return const Center(child: Text('Belum ada data transaksi'));
                    }
                    if (transaction.isLoading && transaction.records.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (transaction.errorMessage != null) {
                      return Center(child: Text(transaction.errorMessage!));
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: transaction.records.length,
                            itemBuilder: (context, index) {
                              final record = transaction.records[index];
                              return TransactionCard(record: record);
                            },
                          ),
                        ),
                        if (!transaction.isLastPage)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextButton(
                              onPressed: transaction.isLoading
                                  ? null
                                  : () {
                                      transaction.fetchTransactions(loadMore: true);
                                    },
                              child: transaction.isLoading
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
      ),
    );
  }
}
