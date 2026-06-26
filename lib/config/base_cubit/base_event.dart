sealed class BaseEvent {
  const BaseEvent();
}

class DisplayErrorEvent extends BaseEvent {
  final String errorMsg;

  const DisplayErrorEvent({required this.errorMsg});
}

class DisplaySuccessEvent extends BaseEvent {
  final String successMsg;

  const DisplaySuccessEvent({required this.successMsg});
}

class NavigationEvent extends BaseEvent {
  final String routeName;

  const NavigationEvent({required this.routeName});
}
