import 'package:local_notifier/local_notifier.dart';

class NotificationRepository {
  Future<void> showInfoNotification() async {
    final notification = LocalNotification(
      title: 'Twenty is running 👀',
      body: 'Twenty will remind you to relax your eyes in 20min',
    );
    return notification.show();
  }
}
