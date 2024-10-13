import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ppob/core/core.dart';
import 'package:ppob/features/common/common.dart';
import 'package:ppob/features/transaction/transaction.dart';
import 'package:provider/provider.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class TopUpPage extends StatefulWidget {
  static const routeName = 'top-up';
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final isDisable = ValueNotifier(true);

  final globalKey = GlobalKey<FormState>();

  final inputController = TextEditingController();

  final fitNominal = [10000, 20000, 50000, 100000, 250000, 500000];

  CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: 0,
  );

  String? validatorInput(String? v) {
    if (v == null || v.isEmpty) {
      return 'Nominal Top Up tidak boleh kosong';
    }

    final input = double.tryParse(inputController.text.replaceAll(RegExp(r'[^0-9]'), ''));

    if (input == null) {
      return 'Nominal Top Up tidak valid';
    }

    const minimumTopUp = 10000;
    const maximumTopUp = 1000000;

    if (input < minimumTopUp) {
      return 'Minimum Top Up adalah 10.000';
    } else if (input > maximumTopUp) {
      return 'Maksimum Top Up adalah 1.000.000';
    }
    return null;
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopUpwidget(),
            const Gap(50),
            RichText(
              text: TextSpan(
                text: 'Silahkan masukkan\n',
                style: Theme.of(context).textTheme.bodyLarge!,
                children: [
                  TextSpan(
                    text: 'nominal Top Up',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const Gap(50),
            ValueListenableBuilder(
              valueListenable: isDisable,
              builder: (context, v, _) {
                return Form(
                  key: globalKey,
                  child: Column(
                    children: [
                      FormWidget(
                        hintText: 'masukkan nominal Top Up',
                        prefixIcon: const Icon(Icons.money),
                        controller: inputController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [formatter],
                        onFieldSubmitted: (v) {
                          if (v.isNotEmpty) {
                            isDisable.value = false;
                          } else {
                            isDisable.value = true;
                          }
                          return null;
                        },
                        validator: validatorInput,
                      ),
                      const Gap(20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 20,
                        alignment: WrapAlignment.spaceEvenly,
                        children: fitNominal.map(
                          (n) {
                            return InkWell(
                              onTap: () {
                                isDisable.value = false;
                                inputController.text = CurrencyFormat.formatNumber('$n');
                              },
                              child: Container(
                                height: 45,
                                width: MediaQuery.sizeOf(context).width * 0.27,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(CurrencyFormat.convertToIdr(n)),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      const Gap(30),
                      Consumer<TransactionProvider>(
                        builder: (context, transaction, child) {
                          if (transaction.isUpdate) {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) {
                                if (transaction.errorMessage != null) {
                                  dialogSuccessOrFailure(
                                    context: context,
                                    amount: inputController.text,
                                    message: 'Top Up sebesar',
                                  );
                                } else {
                                  dialogSuccessOrFailure(
                                    context: context,
                                    amount: inputController.text,
                                    message: 'Top Up sebesar',
                                    isSuccess: true,
                                  );
                                }
                                inputController.text = '';
                                isDisable.value = true;
                                transaction.resetUpdate();
                              },
                            );
                          }

                          return PrimaryButton(
                            onPressed: isDisable.value == true
                                ? null
                                : () {
                                    if (globalKey.currentState!.validate()) {
                                      confirmTopUp(
                                        context: context,
                                        amount: inputController.text,
                                        onPressed: () {
                                          context
                                              .read<TransactionProvider>()
                                              .topup(inputController.text);
                                          Navigator.pop(context);
                                        },
                                      );
                                    }
                                  },
                            text: 'Top Up',
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
