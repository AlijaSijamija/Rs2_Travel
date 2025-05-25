import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/notification/notification.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/master_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late NotificationProvider _notificationProvider;
  List<NotificationModel>? notifications;

  @override
  void initState() {
    super.initState();
    _notificationProvider = context.read<NotificationProvider>();
    _loadData();
  }

  _loadData() async {
    try {
      var notificationsData = await _notificationProvider.get();

      setState(() {
        notifications = notificationsData.result;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Home"),
      child: Container(
        child: Column(
          children: [
            if (notifications != null && notifications!.isNotEmpty)
              _buildHeading('Notifications'),
            _buildNotifications(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading(String heading) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        heading,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotifications() {
    return Column(
      children: (notifications ?? []).map((NotificationModel notification) {
        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(notification.heading ?? ''),
            subtitle: Text(notification.content ?? ''),
          ),
        );
      }).toList(),
    );
  }
}
