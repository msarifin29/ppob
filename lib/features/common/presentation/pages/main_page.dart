import 'package:flutter/material.dart';
import 'package:ppob/features/auth/auth.dart';
import 'package:ppob/features/common/common.dart';
import 'package:ppob/features/transaction/transaction.dart';

class MainPage extends StatefulWidget {
  static const routeName = 'main';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final currentIndex = ValueNotifier<int>(0);

  void selectedTab(int index) {
    currentIndex.value = index;
  }

  final List<Widget> pages = [
    const HomePage(),
    const TopUpPage(),
    const TransactionPage(),
    const AccountPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (context, v, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: pages.elementAt(currentIndex.value),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              height: 65,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(blurRadius: 0, blurStyle: BlurStyle.solid),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ItemNewNavBar(
                    icon: currentIndex.value == 0 ? Icons.home : Icons.home_outlined,
                    title: 'Home',
                    color: currentIndex.value == 0 ? Colors.black : Colors.grey,
                    onTap: () => currentIndex.value = 0,
                  ),
                  ItemNewNavBar(
                    icon: currentIndex.value == 1 ? Icons.money : Icons.money,
                    title: 'Top Up',
                    color: currentIndex.value == 1 ? Colors.black : Colors.grey,
                    onTap: () => currentIndex.value = 1,
                  ),
                  ItemNewNavBar(
                    icon: currentIndex.value == 2 ? Icons.credit_card : Icons.credit_card,
                    title: 'Transaction',
                    color: currentIndex.value == 2 ? Colors.black : Colors.grey,
                    onTap: () => currentIndex.value = 2,
                  ),
                  ItemNewNavBar(
                    icon: currentIndex.value == 3 ? Icons.person : Icons.person_outline,
                    title: 'Akun',
                    color: currentIndex.value == 3 ? Colors.black : Colors.grey,
                    onTap: () => currentIndex.value = 3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
