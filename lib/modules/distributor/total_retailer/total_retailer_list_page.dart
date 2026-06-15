import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/modules/distributor/add_retailer/add_retailer_page.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_card.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_controller.dart';

// class TotalRetailerListPage extends StatelessWidget {
//   final String title;
//   const TotalRetailerListPage({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.put(RetailerController());
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F8FF),
//       body: Column(
//         children: [
//           /// HEADER
//           Container(
//             padding: const EdgeInsets.only(left: 8, right: 8,top: 50),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFDCE6FF), Color(0xFFF6F8FF)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//             child: Row(
//               children: [
//                 _circleBtn(Icons.arrow_back, Get.back),
//                 const SizedBox(width: 10),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const Spacer(),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     Get.to(AddRetailerPage());
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF3D5CFF),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   ),
//                   icon: const Icon(Icons.add, size: 18,color: Colors.white,),
//                   label: const Text("Add New Retailers",style: TextStyle(color: Colors.white),),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 10,),
//
//           /// SEARCH
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Container(
//               height: 48,
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Color(0x14000000),
//                     blurRadius: 8,
//                   )
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.search, color: Colors.grey),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: TextField(
//                       controller: c.searchCtrl,
//                       decoration: const InputDecoration(
//                         hintText: "Search name, ID, mobile, email",
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//
//           /// LIST
//           // Expanded(
//           //   child: Obx(() => ListView.builder(
//           //     padding: const EdgeInsets.symmetric(horizontal: 16),
//           //     itemCount: c.filteredList.length,
//           //     itemBuilder: (_, i) {
//           //       return RetailerCard(retailer: c.filteredList[i]);
//           //     },
//           //   )),
//           // ),
//           /// LIST
//           Expanded(
//             child: Obx(() {
//               // ✅ Loader show karo jab tak API se data aa raha hai
//               if (c.isLoading.value) {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.5,
//                     color: Color(0xFF3D5CFF),
//                   ),
//                 );
//               }
//
//               // ✅ Agar data empty hai
//               if (c.filteredList.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     "No Retailers Found",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 );
//               }
//
//               // ✅ Data show karo
//               return ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 itemCount: c.filteredList.length,
//                 itemBuilder: (_, i) {
//                   return RetailerCard(retailer: c.filteredList[i]);
//                 },
//               );
//             }),
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _circleBtn(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 40,
//         width: 40,
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.5),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/modules/distributor/add_retailer/add_retailer_page.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_card.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_controller.dart';

class TotalRetailerListPage extends StatelessWidget {
  final String title;
  const TotalRetailerListPage({super.key, required this.title});


  @override
  Widget build(BuildContext context) {

    // final type = title.toLowerCase().contains("active")
    //     ? RetailerListType.active
    //     : title.toLowerCase().contains("today")
    //     ? RetailerListType.today
    //     : RetailerListType.total;

    final lower = title.toLowerCase();

    // final isDistributor = lower.contains("distributor") && !lower.contains("sub");
    // final isSubDistributor = lower.contains("sub distributor");

    print("lower is >>>>>>>>>>${lower}");
    final isDistributor = lower.contains("distributor") && !lower.contains("sub");
    final isSubDistributor = lower.contains("sub distributor");
    final isSubRetailer = lower.contains("sub-retailer"); // 👈 FIRST CHECK
    final isRetailer = lower.contains("retailer") && !isSubRetailer;
    // final isRetailer = lower.contains("retailer");
    // final isSubRetailer = lower.contains("sub-retailer");
    print("is Sub retailr >>>>>>>>>${isSubRetailer}");

    // final status = lower.contains("active")
    //     ? "active"
    //     : lower.contains("deactive")
    //     ? "inactive"
    //     : null;
    final status = lower.contains("deactive")
        ? "inactive"   // 👈 API expects this
        : lower.contains("active")
        ? "active"
        : null;

    final type = lower.contains("today")
        ? RetailerListType.today
        : RetailerListType.total;


    // final c = Get.put(RetailerController(listType: type), tag: title);

    final c = Get.put(
      RetailerController(
        listType: type,
        vendorType: isDistributor
            ? "distributor"
            : isSubDistributor
            ? "sub_distributor"
            : isSubRetailer
            ? "retailer"   // ✅ FIXED
            : isRetailer
            ? "vendor"
            : null,

        status: status,
        tag: title, // 🔥 ADD THIS

      ),
      tag: title,
    );
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 50),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFDCE6FF), Color(0xFFF6F8FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                _circleBtn(Icons.arrow_back, () {
                  Get.delete<RetailerController>(tag: title, force: true);
                  Get.back();
                }),
                const SizedBox(width: 10),
                Text(
                  title,maxLines:  1 ,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => Get.to(AddRetailerPage()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D5CFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  icon: const Icon(Icons.add, size: 15, color: Colors.white),
                  label: const Text("Add Retailers", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: c.searchCtrl,
                      decoration: const InputDecoration(
                        hintText: "Search name, ID, mobile, email",
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF3D5CFF)),
                );
              }

              if (c.filteredList.isEmpty) {
                return const Center(
                  child: Text("No Retailers Found", style: TextStyle(fontSize: 14, color: Colors.grey)),
                );
              }

              return ListView.builder(
                controller: c.scrollController, // 🔥 ADD THIS

                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: c.filteredList.length,
                itemBuilder: (_, i) => RetailerCard(
                  retailer: c.filteredList[i],
                  controller: c, // ✅ pass controller so toggle works (tag issue solved)
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle),
        child: Icon(icon),
      ),
    );
  }
}
