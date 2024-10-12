import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ppob/core/core.dart';
import 'package:ppob/features/auth/auth.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeProfile extends StatelessWidget {
  const HomeProfile({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> fetch() async {
      context.read<ProfileProvider>().fetch();
    }

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 20),
      child: FutureBuilder(
          future: fetch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return ElevatedButton.icon(
                onPressed: () => fetch(),
                label: const Text('Muat ulang'),
                icon: const Icon(Icons.sync),
              );
            }
            return Consumer<ProfileProvider>(
              builder: (context, profile, _) {
                final image = profile.user?.profileImage;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(ImageName.logo),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Gap(10),
                              Text(
                                'SIMS PPOB',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(35 / 2),
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: (image ?? '').contains('null')
                                ? Image.asset(ImageName.profilePhoto, fit: BoxFit.cover)
                                : CachedNetworkImage(
                                    imageUrl: image ?? '',
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        CircularProgressIndicator(value: downloadProgress.progress),
                                    errorWidget: (context, url, error) => const Icon(Icons.person),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(30),
                    RichText(
                      text: TextSpan(
                        text: 'Selamat Datang,\n',
                        style: Theme.of(context).textTheme.titleMedium!,
                        children: [
                          TextSpan(
                            text: '${profile.user?.firstName} ${profile.user?.lastName}',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}
