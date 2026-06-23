abstract class ApiEndPoints {
  static const String baseUrl = "https://flower.elevateegy.com/api/v1";

  static const String login = '/drivers/signin';
  static const String logout = '/drivers/logout';
  static const String apply = '/drivers/apply';

  static const String forgetPassword = "/drivers/forgotPassword";
  static const String verifyResetCode = "/drivers/verifyResetCode";
  static const String resetPassword = "/drivers/resetPassword";

  static const String getDriverData = "/drivers/profile-data";
  static const String pendingOrders = "/orders/pending-orders";
}
