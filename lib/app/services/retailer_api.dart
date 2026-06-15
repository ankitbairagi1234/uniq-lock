// class RetailerAPI {
//
//
//   // static String baseUrl = "https://sunil-z-plus-project.vercel.app";
//   static String baseUrl = "https://lockpepro.com";
//
//   // static String login = "$baseUrl/api/v1/user/login";
//   // ✅ NEW APIs
//   static String login = "$baseUrl/api/v1/auth/login";
//   static String getDashBoard = "$baseUrl/api/dashboard";
//
//   static String getRetailerDashboard = "$baseUrl/api/v1/retailer/dashboard";
//   static String getUserProfile = "$baseUrl/api/v1/user/profile";
//   static String editProfile = "$baseUrl/api/v1/user/edit/profile";
//   static String uploadProfilePicture = "$baseUrl/api/v1/user/upload-profile-picture";
//   static String changePassword = "$baseUrl/api/v1/user/change/Password";
//   static String getUpcomingEmis = "$baseUrl/api/v1/retailer/upcoming-emis";
//   static String setSecurityPin = "$baseUrl/api/v1/user/setSecurityPin/add";
//   static String verifySecurityPin = "$baseUrl/api/v1/user/verifySecurityPin/add";
//   static String addNewKey = "$baseUrl/api/v1/retailer/add-key";
//   static String lockDevice = "$baseUrl/api/v1/retailer/device/lock";
//   static String unlockDevice = "$baseUrl/api/v1/retailer/device/unlock";
//   static String sendDeviceCommand = "$baseUrl/api/v1/retailer/device/command";
//   static String keyDetail = "$baseUrl/api/v1/retailer/key-summary";
//   static String devicesList = "$baseUrl/api/v1/retailer/devices";
//   static String uploadIdPicture = "$baseUrl/api/v1/user/upload-id-picture";
//   // static String removeKey(String keyDocId) => "$baseUrl/api/v1/retailer/remove-key/$keyDocId";
//   static String removeKey(String keyDocId) => "$baseUrl/api/v1/retailer/delete-key/$keyDocId";
//
//   static String keyDetails(String keyId) => "$baseUrl/api/v1/retailer/keys/$keyId/details";
//   static String deviceQr(String deviceMongoId) =>
//       "$baseUrl/api/v1/retailer/device/$deviceMongoId/qr";
//
//   static String updateEmi(String emiId) =>
//       "$baseUrl/api/v1/retailer/emi/$emiId";
//
//   static String updateKey(String id) => "$baseUrl/api/v1/retailer/update-key/$id";
//
//
//   // ✅ DISTRIBUTOR
//   static String getDistributorDashboard = "$baseUrl/api/v1/distributor/dashboard";
//   // static String getDistributorRetailers = "$baseUrl/api/v1/distributor/retailers";
//   // static String getDistributorKeyTransactions = "$baseUrl/api/v1/distributor/key-transactions";
//   static String getDistributorKeyTransactions({
//     required String keyType,
//     required int page,
//     required int limit,
//   }) =>
//       "$baseUrl/api/v1/distributor/key-transactions?keyType=$keyType&page=$page&limit=$limit";
//
//   static String addRetailer = "$baseUrl/api/v1/distributor/retailers/add";
//   static String getDistributorRetailers({required int page, required int limit}) =>
//       "$baseUrl/api/v1/distributor/retailers?page=$page&limit=$limit";
//
//   static String getRetailerDetails(String retailerId) =>
//       "$baseUrl/api/v1/distributor/retailers/$retailerId";
//
//   static String updateRetailer(String retailerId) =>
//       "$baseUrl/api/v1/distributor/retailers/$retailerId";
//
//   static String toggleRetailerStatus(String retailerId) =>
//       "$baseUrl/api/v1/distributor/retailers/$retailerId/toggle-status";
//
//   static String getActiveRetailers() =>
//       "$baseUrl/api/v1/distributor/retailers/active/get";
//
//   // ✅ TODAY (no pagination)
//   static String getTodayRetailers() =>
//       "$baseUrl/api/v1/distributor/retailers/today/get";
//
//   static String transferKeysToRetailer = "$baseUrl/api/v1/distributor/retailer/key-transfer";
//
// }

class RetailerAPI {


  static String baseUrl = "https://lockpepro.com";

  // static String login = "$baseUrl/api/v1/user/login";
  // ✅ NEW APIs
  static String login = "$baseUrl/api/v1/auth/login";
  static String registerVendor = "$baseUrl/api/v1/auth/vendor/create-form";

  static String getDashBoard = "$baseUrl/api/dashboard";
  static String customerAdd = "$baseUrl/api/customers/customerAdd";
  // static String customersListingV2 = "$baseUrl/api/customers/getAllCustomer";
  static String customersListingV2 =
      "$baseUrl/api/customers/getAllCustomerWithDevices";

  static String sendDeviceCommand = "$baseUrl/api/mdm/device/sendCommand";

  // ✅ NEW LOCATION API
  static String deviceLocation(String deviceId) =>
      "$baseUrl/api/mdm/devices/$deviceId/location";

  static String getProfile = "$baseUrl/api/v1/auth/profile";
  static String updateProfile =
      "$baseUrl/api/v1/auth/vendor/update";

  static String changePassword = "$baseUrl/api/v1/auth/change-password";

  static String changePasswordAdmin = "$baseUrl/api/v1/auth/change-password-admin";

///mic me issue he mere wait let me fix
  static String keyDetail = "$baseUrl/api/dashboard/key-summary";

  static String keyLedger = "$baseUrl/api/keys/ledger";

  static String updateFrpEmail =
      "$baseUrl/api/v1/auth/frp-email/update";

  ///old apis
  // static String baseUrl = "https://sunil-z-plus-project.vercel.app";
  // static String login = "$baseUrl/api/v1/user/login";
  static String getRetailerDashboard = "$baseUrl/api/v1/retailer/dashboard";
  static String getUserProfile = "$baseUrl/api/v1/user/profile";
  static String editProfile = "$baseUrl/api/v1/user/edit/profile";
  static String uploadProfilePicture = "$baseUrl/api/v1/user/upload-profile-picture";
  // static String changePassword = "$baseUrl/api/v1/user/change/Password";
  static String getUpcomingEmis = "$baseUrl/api/v1/retailer/upcoming-emis";
  static String setSecurityPin = "$baseUrl/api/v1/user/setSecurityPin/add";
  static String verifySecurityPin = "$baseUrl/api/v1/user/verifySecurityPin/add";
  static String addNewKey = "$baseUrl/api/v1/retailer/add-key";
  static String lockDevice = "$baseUrl/api/v1/retailer/device/lock";
  static String unlockDevice = "$baseUrl/api/v1/retailer/device/unlock";
  // static String sendDeviceCommand = "$baseUrl/api/v1/retailer/device/command";
  // static String keyDetail = "$baseUrl/api/v1/retailer/key-summary";
  static String devicesList = "$baseUrl/api/v1/retailer/devices";
  static String uploadIdPicture = "$baseUrl/api/v1/user/upload-id-picture";
  // static String removeKey(String keyDocId) => "$baseUrl/api/v1/retailer/remove-key/$keyDocId";
  static String removeKey(String keyDocId) => "$baseUrl/api/v1/retailer/delete-key/$keyDocId";

  static String keyDetails(String keyId) => "$baseUrl/api/v1/retailer/keys/$keyId/details";
  static String deviceQr(String deviceMongoId) =>
      "$baseUrl/api/v1/retailer/device/$deviceMongoId/qr";

  static String updateEmi(String emiId) =>
      "$baseUrl/api/v1/retailer/emi/$emiId";

  static String updateKey(String id) => "$baseUrl/api/v1/retailer/update-key/$id";


  // ✅ DISTRIBUTOR
  static String getDistributorDashboard = "$baseUrl/api/v1/distributor/dashboard";
  // static String getDistributorRetailers = "$baseUrl/api/v1/distributor/retailers";
  // static String getDistributorKeyTransactions = "$baseUrl/api/v1/distributor/key-transactions";
  static String getDistributorKeyTransactions({
    required String keyType,
    required int page,
    required int limit,
  }) =>
      "$baseUrl/api/v1/distributor/key-transactions?keyType=$keyType&page=$page&limit=$limit";

  // static String addRetailer = "$baseUrl/api/v1/distributor/retailers/add";
  static String addRetailer = "$baseUrl/api/v1/auth/register/vendor";
  static String getDistributorRetailers({required int page, required int limit}) =>
      "$baseUrl/api/v1/distributor/retailers?page=$page&limit=$limit";

  static String getRetailerDetails(String retailerId) =>
      "$baseUrl/api/v1/distributor/retailers/$retailerId";

  static String updateRetailer(String retailerId) =>
      "$baseUrl/api/v1/distributor/retailers/$retailerId";

  // static String toggleRetailerStatus(String retailerId) =>
  //     "$baseUrl/api/v1/distributor/retailers/$retailerId/toggle-status";

  static String toggleRetailerStatus() =>
      "$baseUrl/api/v1/auth/vendor/toggle-active";

  static String getActiveRetailers() =>
      "$baseUrl/api/v1/distributor/retailers/active/get";

  // ✅ TODAY (no pagination)
  static String getTodayRetailers() =>
      "$baseUrl/api/v1/distributor/retailers/today/get";

  static String transferKeysToRetailer = "$baseUrl/api/v1/distributor/retailer/key-transfer";

}
