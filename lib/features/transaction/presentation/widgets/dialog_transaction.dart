import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ppob/core/core.dart';

Future<T?> confirmTopUp<T>({
  required BuildContext context,
  String amount = '',
  String messsage = 'Anda yakin untuk Top Up sebesar',
  String titleButton = 'Top Up',
  VoidCallback? onPressed,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                ImageName.logo,
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
              const Gap(20),
              Text(
                '$messsage senilai',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Rp $amount',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onPressed,
                child: Text(
                  'Ya, lanjutkan $titleButton',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Batalkan',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<T?> dialogSuccessOrFailure<T>({
  required BuildContext context,
  String amount = '',
  String message = '',
  bool isSuccess = false,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: isSuccess ? Colors.teal[300] : Colors.red),
                child: Icon(
                  isSuccess ? Icons.check : Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const Gap(20),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Rp$amount',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                isSuccess ? 'berhasil!' : 'gagal',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Kembali ke beranda',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<T?> insufficientBalance<T>({
  required BuildContext context,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const Gap(20),
              Text(
                'Maaf, Saldo anda tidak cukup',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Kembali ke beranda',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
