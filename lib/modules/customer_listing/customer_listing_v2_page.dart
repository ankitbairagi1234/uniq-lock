import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/app/utils/date_formate.dart';
import 'package:zlock_smart_finance/model/user_model.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_details/customer_detail_v2_controller.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_details/customer_detail_v2_page.dart';
import 'package:zlock_smart_finance/modules/retailer/Add_new_key/new_key_controller.dart';
import 'package:zlock_smart_finance/modules/retailer/dashboard/dashboard_retailer.dart';
import 'package:zlock_smart_finance/modules/retailer/edit_key/edit_key.dart';

import 'customer_listing_v2_controller.dart';

class CustomerListingV2Page extends StatelessWidget {
  final String? title;
  CustomerListingV2Page({super.key, this.title});

  final _scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<CustomerListingV2Controller>()) {
      Get.delete<CustomerListingV2Controller>(force: true);
    }
    final CustomerListingV2Controller c = Get.put(CustomerListingV2Controller());

    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
        c.loadMore();
      }
    });

    final appBarTitle =
    (title != null && title!.trim().isNotEmpty) ? title!.trim() : "Users";

    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(appBarTitle, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _searchBar(c),
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (c.filteredUsers.isEmpty) {
                return const Center(child: Text("No users found"));
              }

              return RefreshIndicator(
                onRefresh: () => c.refreshList(),
                child: ListView.builder(
                  controller: _scrollCtrl,
                  physics: const AlwaysScrollableScrollPhysics(), // 🔥 MUST

                  padding: const EdgeInsets.all(16),
                  itemCount: c.filteredUsers.length + 1,
                  itemBuilder: (_, i) {
                    if (i == c.filteredUsers.length) {
                      return Obx(() {
                        if (c.isLoadingMore.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return const SizedBox(height: 20);
                      });
                    }

                    return _userCard(c.filteredUsers[i], context);
                  },
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _searchBar(CustomerListingV2Controller c) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (v) => c.search.value = v,
        decoration: InputDecoration(
          hintText: 'Search name, mobile, IMEI',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _userCard(UserModel u, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          _cardHeader(u),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _avatar(u),
                const SizedBox(width: 12),
                Expanded(child: _details(u)),
                const VerticalDashedDivider(height: 135),
                _tags(u),
              ],
            ),
          ),
          const Divider(height: 1),
          _actions(u, context),
        ],
      ),
    );
  }

  Widget _cardHeader(UserModel u) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Key ID: ${u.keyId}', style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _avatar(UserModel u) {
    final String? imageUrl = u.productImage.isNotEmpty ? u.productImage.first : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 66,
        color: const Color(0xffEEF1FF),
        child: imageUrl == null
            ? const Icon(Icons.image_not_supported, size: 26, color: Colors.grey)
            : Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
          const Icon(Icons.broken_image, size: 26, color: Colors.grey),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _details(UserModel u) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${u.name}'),
        Text('Mobile: ${u.mobile}'),
        Text('IMEI: ${u.imei}'),
        Text('Loan by: ${u.loanBy}', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xffEEF2FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('EMI Status: ${u.emi}', style: const TextStyle(color: Colors.blue)),
        )
      ],
    );
  }

  Widget _tags(UserModel u) {
    final date = formatApiDate(u.createdDate);
    final time = formatApiTime(u.createdDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _chip(u.deviceType, Colors.blue),
        _chip(u.loanBy, Colors.orange),
        _chip(date, Colors.green),
        _chip(time, Colors.purple),
      ],
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _actions(UserModel u, context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Get.to(
                //       () => DetailsScreen(),
                //   arguments: {
                //     "keyId": u.keyId,
                //     "deviceId": u.deviceId,
                //   },
                //   binding: BindingsBuilder(() {
                //     Get.create<DetailsController>(() => DetailsController());
                //   }),
                // );
                  Get.to(
                        () => CustomerDetailV2Page(),
                    arguments: {
                      "customerId": u.deviceId, // yaha hum _id pass kar rahe
                      "deviceId": u.deviceId,
                    },
                    binding: BindingsBuilder(() {
                      Get.put(CustomerDetailV2Controller());
                      Get.put(NewKeyController(entry: NewKeyEntry.android));
                    }),
                  );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4F6BED),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('View Details', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 8),
          Builder(
            builder: (ctx) {
              final key = GlobalKey();

              return InkResponse(
                key: key,
                radius: 22,
                onTap: () => _showMoreMenuFromKeyV2(ctx, key, u),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.more_vert, size: 22),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class VerticalDashedDivider extends StatelessWidget {
  final double height;
  final Color color;

  const VerticalDashedDivider({
    super.key,
    this.height = 80,
    this.color = const Color(0xFFD6DEEB),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          12,
              (index) => Container(
            width: 1.2,
            height: 6,
            color: color,
          ),
        ),
      ),
    );
  }
}

void _showMoreMenuFromKeyV2(BuildContext context, GlobalKey key, UserModel u) async {
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final RenderBox button = key.currentContext!.findRenderObject() as RenderBox;

  final Offset topLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
  final Offset bottomRight =
  button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay);

  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(topLeft, bottomRight),
    Offset.zero & overlay.size,
  );

  if (Get.isRegistered<CustomerListingV2Controller>()) {
    Get.delete<CustomerListingV2Controller>(force: true);
  }
  final CustomerListingV2Controller c = Get.put(CustomerListingV2Controller());

  final value = await showMenu<String>(
    context: context,
    color: Colors.white,
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    position: position,
    items: [
      PopupMenuItem(
        value: 'qr',
        child: Row(
          children: const [
            Icon(Icons.qr_code_2, size: 20, color: Colors.black),
            SizedBox(width: 10),
            Text('Show QR', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'edit',
        child: Row(
          children: const [
            Icon(Icons.edit, size: 20, color: Colors.black),
            SizedBox(width: 10),
            Text('Edit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    ],
  );

  if (value == 'qr') {
    // c.fetchRetailerDashboardQR();
    c.openUserQr(u);

    // yaha later customer-specific QR flow add kar sakte ho
  } else if (value == 'edit') {
    final entry = _entryFromUserV2(u);
    // Get.to(
    //       () => EditKeyScreen(
    //     title: entry == NewKeyEntry.iphone
    //         ? "Edit iPhone Key"
    //         : entry == NewKeyEntry.running
    //         ? "Edit Running Key"
    //         : "Edit Android Key",
    //     entry: entry,
    //     keyId: u.keyId,
    //     deviceId: u.deviceId,
    //   ),
    //   arguments: {
    //     "entry": entry,
    //     "keyId": u.keyId,
    //     "deviceId": u.deviceId,
    //     "user": u, // ✅ ADD THIS
    //   },
    // );
    Get.to(
          () => EditKeyScreen(
        title: "Edit Customer",
        entry: NewKeyEntry.android,
        keyId: u.keyId,
        deviceId: u.deviceId,
      ),
      arguments: {
        "user": u, // FULL OBJECT PASS
      },
    );
  }
}


NewKeyEntry _entryFromUserV2(dynamic u) {
  final t = (u.deviceType ?? u.keyType ?? "").toString().toUpperCase();

  if (t.contains("IPHONE") || t.contains("IOS")) return NewKeyEntry.iphone;
  if (t.contains("RUNNING")) return NewKeyEntry.running;
  return NewKeyEntry.android;
}