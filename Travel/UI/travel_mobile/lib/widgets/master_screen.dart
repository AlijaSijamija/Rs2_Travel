import 'package:flutter/material.dart';
import 'package:travel_mobile/main.dart';
import 'package:travel_mobile/screens/booked_routes/booked_routes_screen.dart';
import 'package:travel_mobile/screens/booked_trips/booked_trips_screen.dart';
import 'package:travel_mobile/screens/home/home_screen.dart';
import 'package:travel_mobile/screens/organized_trip/organized_trip_list_screen.dart';
import 'package:travel_mobile/screens/routes/routes_list_screen.dart';
import 'package:travel_mobile/screens/saved_routes/saved_routes_screen.dart';
import 'package:travel_mobile/screens/user_profile/user_profile_screen.dart';
import 'package:travel_mobile/utils/util.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to the user profile screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(),
                ),
              );
            },
          ),
        ],
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
                title: Text("Home", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomePageScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.bus_alert,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Routes", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const RoutesSearchScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.bookmark,
                    color: Colors.white), // Add an icon to the ListTile
                title:
                    Text("Saved routes", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SavedRoutesScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.airplane_ticket,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Route tickets",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const BookedRoutesScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.trip_origin_sharp,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Trips", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const OrganizedTripListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.book_online_rounded,
                    color: Colors.white), // Add an icon to the ListTile
                title:
                    Text("Booked trips", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const BookedTripsScreen()),
                  );
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.video_camera_front,
              //       color: Colors.white), // Add an icon to the ListTile
              //   title:
              //       Text("Monitoring", style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //           builder: (context) => const MonitoringListScreen()),
              //     );
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.collections_bookmark_sharp,
              //       color: Colors.white), // Add an icon to the ListTile
              //   title:
              //       Text("Annual plans", style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //           builder: (context) => const AnnualPlanListScreen()),
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
