import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ppob/features/auth/auth.dart';
import 'package:ppob/features/common/common.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = 'register';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final isVisible = ValueNotifier<bool>(true);
  final isConfirmVisible = ValueNotifier<bool>(true);

  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmPwdController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    pwdController.dispose();
    confirmPwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(MediaQuery.sizeOf(context).height * 0.05),
              const HeaderLoginOrRegister(title: 'Lengkapi data untuk membuat akun'),
              const Gap(30),
              FormWidget(
                controller: emailController,
                hintText: 'masukkan email anda',
                prefixIcon: const Icon(Icons.alternate_email, size: 20),
                validator: (v) {
                  final bool isValid = EmailValidator.validate(emailController.text.trim());
                  if (v == null || v.isEmpty) {
                    return 'email tidak boleh kosong';
                  } else if (!isValid) {
                    return 'email tidak valid';
                  }
                  return null;
                },
              ),
              const Gap(20),
              FormWidget(
                controller: firstNameController,
                hintText: 'nama depan',
                prefixIcon: const Icon(Icons.person_outline_outlined, size: 20),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'nama depan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const Gap(20),
              FormWidget(
                controller: lastNameController,
                hintText: 'nama belakang',
                prefixIcon: const Icon(Icons.person_outline_outlined, size: 20),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'nama belakang tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const Gap(20),
              ValueListenableBuilder(
                valueListenable: isVisible,
                builder: (context, v, _) {
                  return FormWidget(
                    controller: pwdController,
                    hintText: 'buat password',
                    prefixIcon: const Icon(Icons.lock_open_outlined, size: 20),
                    obscureText: isVisible.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        isVisible.value = !isVisible.value;
                      },
                      icon: Icon(
                        isVisible.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'password tidak boleh kosong';
                      } else if (v.length < 8) {
                        return 'password minimal terdiri dari 8 karakter';
                      }
                      return null;
                    },
                  );
                },
              ),
              const Gap(20),
              ValueListenableBuilder(
                valueListenable: isConfirmVisible,
                builder: (context, v, _) {
                  return FormWidget(
                    controller: confirmPwdController,
                    hintText: 'konfirmasi password',
                    prefixIcon: const Icon(Icons.lock_open_outlined, size: 20),
                    obscureText: isConfirmVisible.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        isConfirmVisible.value = !isConfirmVisible.value;
                      },
                      icon: Icon(
                        isConfirmVisible.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'konfirmasi password tidak boleh kosong';
                      } else if (v.length < 8) {
                        return 'password minimal terdiri dari 8 karakter';
                      } else if (v != pwdController.text) {
                        return 'password tidak sama';
                      }
                      return null;
                    },
                  );
                },
              ),
              const Gap(30),
              Consumer<RegisterProvider>(builder: (context, register, _) {
                if (register.isSuccess && register.errorMessage == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Register sukses'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    await Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginPage.routeName,
                      (route) => false,
                    );
                  });
                }
                if (register.errorMessage != null) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(register.errorMessage!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                }
                return register.isLoading
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final param = RegisterParam(
                              email: emailController.text,
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              password: pwdController.text,
                            );
                            register.call(param);
                          }
                        },
                        text: 'Register',
                      );
              }),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('sudah punya akun? login'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoginPage.routeName,
                        (route) => false,
                      );
                    },
                    child: Text(
                      'di sini',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
