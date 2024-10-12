// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ppob/features/common/common.dart';
import 'package:provider/provider.dart';

import 'package:ppob/core/core.dart';
import 'package:ppob/features/auth/auth.dart';

class AccountPage extends StatefulWidget {
  static const routeName = 'account';
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<void> fetch() async {
    context.read<ProfileProvider>().fetch();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Apakah anda yakin ingin logout?'),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        context.read<LoginProvider>().unAuthorize();
                        await Future.delayed(const Duration(seconds: 1)).then((_) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            LoginPage.routeName,
                            (route) => false,
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Ya', style: TextStyle(color: Colors.white)),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tidak'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Akun')),
      body: FutureBuilder(
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
          return Consumer<ProfileProvider>(
            builder: (context, profile, _) {
              final image = profile.user?.profileImage;
              final email = profile.user?.email;
              final firstName = profile.user?.firstName;
              final lastName = profile.user?.lastName;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100 / 2),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: (image ?? '').contains('null')
                                        ? Image.asset(ImageName.profilePhoto1, fit: BoxFit.cover)
                                        : CachedNetworkImage(
                                            imageUrl: image ?? '',
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder:
                                                (context, url, downloadProgress) =>
                                                    CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                            ),
                                            errorWidget: (context, url, error) =>
                                                const Icon(Icons.person),
                                          ),
                                  ),
                                ),
                                const ButtonEditImage(),
                              ],
                            ),
                          ),
                          const Gap(10),
                          Text(
                            '${profile.user?.firstName} ${profile.user?.lastName}',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Email'),
                        const Gap(10),
                        FormWidget(
                          hintText: '$email',
                          readOnly: true,
                          prefixIcon: const Icon(Icons.alternate_email, size: 20),
                        ),
                      ],
                    ),
                    const Gap(30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nama Depan'),
                        const Gap(10),
                        FormWidget(
                          hintText: '$firstName',
                          readOnly: true,
                          prefixIcon: const Icon(Icons.person_outline, size: 20),
                        ),
                      ],
                    ),
                    const Gap(30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nama Belakang'),
                        const Gap(10),
                        FormWidget(
                          hintText: '$lastName',
                          readOnly: true,
                          prefixIcon: const Icon(Icons.person_outline, size: 20),
                        ),
                      ],
                    ),
                    const Gap(30),
                    PrimaryButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          EditProfilePage.routeName,
                          arguments: {
                            'email': email,
                            'image': image,
                            'firstName': firstName,
                            'lastName': lastName,
                          },
                        );
                      },
                      text: 'Edit Profile',
                    ),
                    const Gap(20),
                    InkWell(
                      onTap: () => _showLogoutDialog(),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.red),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Logout',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Colors.red,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
