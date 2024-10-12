import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ppob/features/auth/auth.dart';
import 'package:ppob/features/common/common.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final isVisible = ValueNotifier<bool>(true);

  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
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
              Gap(MediaQuery.sizeOf(context).height * 0.2),
              const HeaderLoginOrRegister(title: 'Masuk atau buat akun buat memulai'),
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
              ValueListenableBuilder(
                  valueListenable: isVisible,
                  builder: (context, v, _) {
                    return FormWidget(
                      controller: pwdController,
                      hintText: 'masukkan password anda',
                      prefixIcon: const Icon(Icons.lock_open_outlined),
                      obscureText: isVisible.value,
                      suffixIcon: IconButton(
                        onPressed: () {
                          isVisible.value = !isVisible.value;
                        },
                        icon: Icon(
                          isVisible.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
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
                  }),
              const Gap(30),
              Consumer<LoginProvider>(
                builder: (context, login, child) {
                  if (login.isLoading) {
                    return const CircularProgressIndicator();
                  } else if (login.isSuccess && login.errorMessage == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        MainPage.routeName,
                        (route) => false,
                      );
                    });
                  } else if (login.errorMessage != null) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(login.errorMessage!),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    );
                  }
                  return PrimaryButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final param = LoginParam(
                          email: emailController.text,
                          password: pwdController.text,
                        );
                        login.call(param);
                      }
                    },
                    text: 'Masuk',
                  );
                },
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('belum punya akun? register'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RegisterPage.routeName,
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
