class DistributorAPI {
  static String baseUrl = "https://sunil-z-plus-project.vercel.app/";

  static login(email, password) => "$baseUrl/user/login";
  static String getDashboard = "$baseUrl/dashboard";
  static String getUserProfile = "$baseUrl/user/profile";
  static String setSecurityPin = "$baseUrl/user/setSecurityPin/add";
  static String verifySecurityPin = "$baseUrl/user/verifySecurityPin/add";
}
