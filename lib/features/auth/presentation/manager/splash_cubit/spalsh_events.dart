sealed class SplashEvents {}

class GetAcceptedOrder extends SplashEvents {
  final String driverId;

  GetAcceptedOrder(this.driverId);
}
