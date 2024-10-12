// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:ppob/core/core.dart';
import 'package:ppob/features/auth/auth.dart';
import 'package:ppob/features/common/common.dart';

class EditProfilePage extends StatefulWidget {
  static const routeName = 'edit-profile';
  const EditProfilePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.email,
  });

  final String firstName;
  final String lastName;
  final String image;
  final String email;

  @override
  State<EditProfilePage> createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final file = ValueNotifier<File?>(null);

  final formKey = GlobalKey<FormState>();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  FutureOr<File?> selectOrTakePhoto(ImageSource imageSource) async {
    int maxSizeInBytes = 102400;
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      String filePath = pickedFile.path;
      int fileSize = await File(filePath).length();
      if (fileSize > maxSizeInBytes) {
        _showErrorDialog('Size image yang diupload maksimum 100 kb');
      } else if (filePath.endsWith('.jpeg') || filePath.endsWith('.png')) {
        file.value = File(filePath);
        return file.value;
      } else {
        _showErrorDialog('Format Image yang boleh di upload hanya jpeg dan png');
      }
    }
    return null;
  }

  void pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
            valueListenable: file,
            builder: (context, v, _) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final image = await selectOrTakePhoto(ImageSource.camera);
                        if (image != null) {
                          context.read<ProfileProvider>().updatePhoto(file.value ?? File(''));
                        }
                      },
                      label: const Text('Kamera'),
                      icon: const Icon(Icons.camera_alt_outlined),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final image = await selectOrTakePhoto(ImageSource.gallery);
                        if (image != null) {
                          context.read<ProfileProvider>().updatePhoto(file.value ?? File(''));
                        }
                      },
                      label: const Text('Galery'),
                      icon: const Icon(Icons.folder_outlined),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  @override
  void initState() {
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Akun')),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, _) {
          if (profile.isUpdate) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit profile sukses'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
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
                                  child: widget.image.contains('null')
                                      ? Image.asset(ImageName.profilePhoto1, fit: BoxFit.cover)
                                      : CachedNetworkImage(
                                          imageUrl: widget.image,
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
                              ButtonEditImage(onTap: pickImage),
                            ],
                          ),
                        ),
                        const Gap(10),
                        Text(
                          '${widget.firstName} ${widget.lastName}',
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
                        hintText: widget.email,
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
                        hintText: widget.firstName,
                        controller: firstNameController,
                        prefixIcon: const Icon(Icons.person_outline, size: 20),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'nama depan tidak boleh kosong';
                          }
                          return null;
                        },
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
                        hintText: widget.lastName,
                        controller: lastNameController,
                        prefixIcon: const Icon(Icons.person_outline, size: 20),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'nama belakang tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const Gap(30),
                  PrimaryButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final param = UpdateProfileParam(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                        );
                        context.read<ProfileProvider>().update(param);
                      }
                    },
                    text: 'Simpan',
                  ),
                  const Gap(20),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Batalkan',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
