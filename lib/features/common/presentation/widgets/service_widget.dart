import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ppob/features/common/common.dart';
import 'package:provider/provider.dart';

class ServicesWidget extends StatelessWidget {
  const ServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> fetch() async {
      context.read<ServiceProvider>().fetch();
    }

    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.25,
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
          return Consumer<ServiceProvider>(
            builder: (context, service, child) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 60,
                ),
                itemCount: (service.result ?? []).length,
                itemBuilder: (context, i) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: (service.result ?? [])[i].serviceIcon,
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.image),
                        ),
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text(
                          (service.result ?? [])[i].serviceName,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                fontSize: 10,
                              ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}