import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ppob/features/common/common.dart';
import 'package:provider/provider.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> fetch() async {
      context.read<BannerProvider>().fetch();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text('Temukan promo menarik'),
        ),
        const Gap(15),
        Container(
          width: double.infinity,
          height: 150,
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.center,
          child: FutureBuilder(
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
              return Consumer<BannerProvider>(
                builder: (context, banner, child) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (banner.result ?? []).length,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: CachedNetworkImage(
                          imageUrl: (banner.result ?? [])[i].bannerImage,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              const ShimmerEffect(
                            width: 20,
                            height: 20,
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.image),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
