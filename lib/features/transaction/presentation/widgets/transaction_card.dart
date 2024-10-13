import 'package:flutter/material.dart';
import 'package:ppob/core/core.dart';
import 'package:ppob/features/transaction/transaction.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.record});

  final TransactionRecord record;

  @override
  Widget build(BuildContext context) {
    TextStyle amountStyle(String value) {
      return Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: value == 'TOPUP' ? Colors.teal.shade300 : Colors.red,
          );
    }

    return Container(
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: record.transactionType == 'TOPUP' ? '+ ' : '- ',
                  style: amountStyle(record.transactionType),
                  children: [
                    TextSpan(
                      text: CurrencyFormat.convertToIdr(record.totalAmount),
                      style: amountStyle(record.transactionType),
                    )
                  ],
                ),
              ),
              Text(CurrencyFormat.convertToWIB(record.createdOn),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.grey.shade400)),
            ],
          ),
          Text(
            record.description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
