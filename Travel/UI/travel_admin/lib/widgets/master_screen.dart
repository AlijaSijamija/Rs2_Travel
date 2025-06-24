import 'package:flutter/material.dart';
import 'package:travel_admin/main.dart';
import 'package:travel_admin/screens/agencies/agency_list_screen.dart';
import 'package:travel_admin/screens/dashboard/dashboard.dart';
import 'package:travel_admin/screens/notifications/notification_list_screen.dart';
import 'package:travel_admin/screens/organized_trips/organized_trip_list_screen.dart';
import 'package:travel_admin/screens/route_ticket_report/route_ticket_report_screen.dart';
import 'package:travel_admin/screens/routes/route_list_screen.dart';
import 'package:travel_admin/screens/users/user_list_screen.dart';
import 'package:travel_admin/utils/util.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final String? title;
  final Widget? title_widget;
  final bool showBackButton;

  MasterScreenWidget({
    this.child,
    this.title,
    this.title_widget,
    this.showBackButton = false, // Default to false for other pages
    super.key,
  });

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.showBackButton
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
        title: widget.title_widget ?? Text(widget.title ?? ""),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.indigo, // Change the color of the drawer here
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.arrow_back,
                    color: Colors.white), // Add an icon to the ListTile
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.home,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Dashboard", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.supervised_user_circle_sharp,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Users", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const UserListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Notifications",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const NotificationListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.apartment,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Agencies", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const AgencyListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.route_sharp,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Routes", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const RouteListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.directions_bus,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Organized trips",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const OrganizedTripListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.report,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Reports", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const AgencyReportScreen()),
                  );
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.volunteer_activism_sharp,
              //       color: Colors.white), // Add an icon to the ListTile
              //   title: Text("Volunteering Announcements",
              //       style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //           builder: (context) =>
              //               const VolunteeringAnnouncementListcreen()),
              //     );
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.report_gmailerrorred,
              //       color: Colors.white), // Add an icon to the ListTile
              //   title: Text("Reports", style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //           builder: (context) => const ReportListScreen()),
              //     );
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.category_rounded,
              //       color: Colors.white), // Add an icon to the ListTile
              //   title: Text("Company categories",
              //       style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //           builder: (context) =>
              //               const CompanyCategoryListScreen()),
              //     );
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.apartment_rounded,
              //       color: Colors.white), // Add an icon to the ListTile
              //   title: Text("Companies", style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //           builder: (context) => const CompanyListScreen()),
              //     );
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.event,
              //       color: Colors.white), // Add an icon to the ListTile
              //   title: Text("Company events",
              //       style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //           builder: (context) => const CompanyEventListScreen()),
              //     );
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.video_camera_front,
              //       color: Colors.white), // Add an icon to the ListTile
              //   title: Text("Monitoring",
              //       style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //           builder: (context) => const MonitoringListScreen()),
              //     );
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.logout,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Logout", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Authorization.token = null;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: widget.child!,
    );
  }
}
