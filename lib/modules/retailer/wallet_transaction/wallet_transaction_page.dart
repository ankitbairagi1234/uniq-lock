import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/modules/retailer/wallet_transaction/wallet_controller.dart';

class WalletTransactionPage extends StatelessWidget {
  WalletTransactionPage({super.key});

  final ctrl = Get.put(WalletTransactionController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      body: RefreshIndicator(
        onRefresh: () async {
          await ctrl.fetchFirstPage(); // ✅ refresh API
        },
        child: Obx(() => SingleChildScrollView(
          controller: ctrl.scrollController, // ✅ pagination
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // AppColors.topBgColour,
                  Colors.white,
                  Colors.white,
                  Colors.white
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF2F4FA),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back, size: 18),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "My Transaction",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ],
                  ),

                  // const SizedBox(height: 25),
                  // _platformTabs(),
                  // const SizedBox(height: 25),

                  // _summaryCards(),
                  // const SizedBox(height: 25),

                  _transactionList(),

                  // ✅ bottom spacing + loader
                  // const SizedBox(height: 40),

                  if (ctrl.isLoadingMore.value)
                    const Center(child: CircularProgressIndicator()),

                  // const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }


  // ---------------- HEADER ----------------
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Container(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xffEEF2FF),
              child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back, color: Colors.black)),
            ),
            const Spacer(),
            const Text(
              'Key Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  // ---------------- ANDROID / IPHONE TAB ----------------
  Widget _keyTabs() {
    return Obx(() {
      final isAndroid = ctrl.selectedKey.value == KeyType.android;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xffF1F5FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _tabButton(
              selected: isAndroid,
              text: 'Android Key',
              icon: Icons.android,
              activeColor: const Color(0xff3BAF6B),
              onTap: () => ctrl.selectedKey.value = KeyType.android,
            ),
            _tabButton(
              selected: !isAndroid,
              text: 'iPhone Key',
              icon: Icons.apple,
              badge: '120',
              activeColor: const Color(0xffC0392B),
              onTap: () => ctrl.selectedKey.value = KeyType.iphone,
            ),
          ],
        ),
      );
    });
  }


  // 🤖 Android / 🍎 iPhone
// 🤖 Android / 🍎 iPhone Tabs
  Widget _platformTabs() => Obx(() => Row(
    children: [
      _platformTab(
        title: 'Android Key',
        count: 0,
        index: 0,
        icon: Icons.android,
        activeGradient: const LinearGradient(
          colors: [Color(0xffE6F6EE), Color(0xffBFE8D4)],
        ),
        activeColor: const Color(0xff2E7D32),
      ),
      _platformTab(
        title: 'Iphone Key',
        // title: 'Used Key',
        count: 0,
        index: 1,
        icon: Icons.apple,
        activeGradient: const LinearGradient(
          colors: [Color(0xffFCE8E8), Color(0xffF5BABA)],
        ),
        activeColor: const Color(0xffB3261E),
      ),
    ],
  ));

  Widget _platformTab({
    required String title,
    required int count,
    required int index,
    required IconData icon,
    required LinearGradient activeGradient,
    required Color activeColor,
  }) {
    final isActive = ctrl.selectedKey.value.index == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => ctrl.selectedKey.value =
        index == 0 ? KeyType.android : KeyType.iphone,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isActive ? activeGradient : null,
            border: Border(
              bottom: BorderSide(
                color: isActive ? activeColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? activeColor : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive ? activeColor : Colors.grey,
                ),
              ),
              if (count > 0)
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }


  Widget _tabButton({
    required bool selected,
    required String text,
    required IconData icon,
    String? badge,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
              colors: [
                activeColor.withOpacity(0.15),
                activeColor.withOpacity(0.35),
              ],
            )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: selected ? activeColor : Colors.grey),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? activeColor : Colors.grey,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 11),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- SUMMARY ----------------
  // Widget _summaryCards() {
  //   return Row(
  //     children: [
  //       _summaryItem('Total Key', ctrl.totalKey.value),//isko bhi total
  //       _summaryItem('Used Key', ctrl.usedKey.value),//isko clicable bana he  only usde key
  //       _summaryItem('Balance Key', ctrl.balanceKey.value),
  //     ],
  //   );
  // }

  Widget _summaryCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _summaryItem(
          'Total Key',
          ctrl.totalKey.value,
          onTap: () {
            ctrl.filterType.value = "all"; // ✅ ALL
            print("tabbed all >>>>>>>${ctrl.filterType.value}");

          },
        ),
        _summaryItem(
          'Used Key',
          ctrl.usedKey.value,
          onTap: () {
            ctrl.filterType.value = "used"; // ✅ USED ONLY
            print("tabbed used >>>>>>>${ctrl.filterType.value}");

          },
        ),
        _summaryItem(
          'Balance Key',
          ctrl.balanceKey.value,
          onTap: () {
            ctrl.filterType.value = "all"; // optional (no change)
          },
        ),
      ],
    );
  }
  // Widget _summaryItem(String title, int value,{VoidCallback? onTap}) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Expanded(
  //       child: Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 6),
  //         padding: const EdgeInsets.all(14),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(14),
  //           border: Border.all(color: const Color(0xffD6DCFF)),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(title,
  //                 style: const TextStyle(
  //                     fontSize: 12, color: Color(0xff3F51B5))),
  //             const SizedBox(height: 8),
  //             Text(
  //               value.toString(),
  //               style: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _summaryItem(String title, int value, {VoidCallback? onTap}) {
    return Expanded( // ✅ YAHAN HOGA
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xffD6DCFF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xff3F51B5))),
              const SizedBox(height: 8),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // ---------------- TRANSACTION LIST ----------------
  // Widget _transactionList() {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     padding: EdgeInsets.zero,
  //
  //     // padding: const EdgeInsets.symmetric(horizontal: 16),
  //     itemCount: ctrl.transactions.length,
  //     itemBuilder: (_, i) {
  //       final t = ctrl.transactions[i];
  //       return _transactionCard(t);
  //     },
  //   );
  // }
  // Widget _transactionList() {
  //   return Obx(() => ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: ctrl.transactions.length,
  //     itemBuilder: (_, i) {
  //       final t = ctrl.transactions[i];
  //       return _transactionCard(t);
  //     },
  //   ));
  // }
  // Widget _transactionList() {
  //   return Obx(() {
  //     // 👉 iPhone selected
  //     if (ctrl.selectedKey.value == KeyType.iphone) {
  //       return _comingSoonWidget();
  //     }
  //
  //     // 👉 Android data
  //     if (ctrl.transactions.isEmpty && !ctrl.isLoading.value) {
  //       return const Padding(
  //         padding: EdgeInsets.only(top: 40),
  //         child: Center(child: Text("No Transactions Found")),
  //       );
  //     }
  //     final list = ctrl.filteredTransactions;
  //
  //
  //     return ListView.builder(
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       // itemCount: ctrl.transactions.length,
  //       itemCount: list.length,
  //
  //       itemBuilder: (_, i) {
  //         // final t = ctrl.transactions[i];
  //         final t = list[i];
  //
  //         return _transactionCard(t);
  //       },
  //     );
  //   });
  // }

  Widget _transactionList() {
    return Obx(() {
      final list = ctrl.filteredTransactions;

      // 👉 iPhone selected
      if (ctrl.selectedKey.value == KeyType.iphone) {
        return _comingSoonWidget();
      }

      if (list.isEmpty && !ctrl.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: Text("No Transactions Found")),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (_, i) {
          final t = list[i];
          return _transactionCard(t);
        },
      );
    });
  }

  Widget _comingSoonWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.lock_clock, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              "Coming Soon",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "iPhone key transactions will be available soon",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionCard(TransactionModel t) {
    final color = t.isCredit ? const Color(0xff3BAF6B) : const Color(0xffC0392B);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(
              t.isCredit ? Icons.call_received : Icons.call_made,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${t.title}:',
                    style: TextStyle(
                        color: color, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(t.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('${t.date}  •  ${t.time}',
                    style:
                    const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                // Text('Received By: Z+ Lock',
                //     style:
                //     const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(
            t.amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
