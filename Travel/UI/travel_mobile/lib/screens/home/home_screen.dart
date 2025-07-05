import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/notification/notification.dart';
import 'package:travel_mobile/screens/home/notification_deatils_screen.dart';
import '../../providers/notification_provider.dart';
import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late NotificationProvider _notificationProvider;
  late String? currentUserId;
  List<NotificationModel>? notifications;
  List<int> readNotificationIds = [];
  String filter = 'All'; // Filter: All, Read, Unread

  @override
  void initState() {
    super.initState();
    _notificationProvider = context.read<NotificationProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var currentUser = await context.read<AccountProvider>().getCurrentUser();
      currentUserId = currentUser.nameid;

      var allNotifications = await _notificationProvider.getData();
      var readNotifications =
          await _notificationProvider.getReadNotifications(currentUserId!);

      setState(() {
        notifications = allNotifications.result;
        readNotificationIds = readNotifications.map((n) => n.id!).toList();
      });
    } catch (e) {
      print("Error loading notifications: $e");
    }
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    var filter = {
      "passengerId": currentUserId,
      "notificationId": notification.id.toString()
    };
    await _notificationProvider.markNotificationAsRead(filter: filter);
    _loadData(); // Refresh after marking as read
  }

  List<NotificationModel> _getFilteredNotifications() {
    if (notifications == null) return [];

    switch (filter) {
      case 'Read':
        return notifications!
            .where((n) => readNotificationIds.contains(n.id))
            .toList();
      case 'Unread':
        return notifications!
            .where((n) => !readNotificationIds.contains(n.id))
            .toList();
      default:
        return notifications!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _getFilteredNotifications();

    return MasterScreenWidget(
      title_widget: const Text("Home"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notifications != null && notifications!.isNotEmpty) ...[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    "Filter:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: filter,
                    items: ['All', 'Read', 'Unread']
                        .map((status) => DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => filter = value);
                      }
                    },
                  ),
                ],
              ),
            ),
            _buildHeading('Notifications (${filteredNotifications.length})'),
          ],
          _buildNotifications(filteredNotifications),
        ],
      ),
    );
  }

  Widget _buildHeading(String heading) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        heading,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotifications(List<NotificationModel> list) {
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("No notifications found."),
      );
    }

    return Column(
      children: list.map((notification) {
        final isRead = readNotificationIds.contains(notification.id);
        final shortContent = (notification.content?.length ?? 0) > 80
            ? "${notification.content!.substring(0, 80)}..."
            : notification.content ?? "";

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(notification.heading ?? ''),
            subtitle: Text(shortContent),
            trailing: isRead
                ? const Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.mark_email_unread_outlined, color: Colors.orange),
            onTap: () async {
              if (!isRead) {
                await _markAsRead(notification);
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      NotificationDetailScreen(notification: notification),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
