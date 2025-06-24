import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/providers/account_provider.dart';
import 'package:travel_mobile/providers/city_provider.dart';
import 'package:travel_mobile/providers/notification_provider.dart';
import 'package:travel_mobile/providers/organized_trip_provider.dart';
import 'package:travel_mobile/providers/route_provider.dart';
import 'package:travel_mobile/providers/section_provider.dart';
import 'package:travel_mobile/screens/home/home_screen.dart';
import 'package:travel_mobile/screens/user_register/user_register.dart';
import 'package:travel_mobile/utils/util.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ChangeNotifierProvider(create: (_) => SectionProvider()),
      ChangeNotifierProvider(create: (_) => CityProvider()),
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => RouteProvider()),
      ChangeNotifierProvider(create: (_) => OrganizedTripProvider())
    ],
    child: const MyMaterialApp(),
  ));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RS II Material app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AccountProvider _accountProvider;
  late NotificationProvider _notificationProvider;

  @override
  Widget build(BuildContext context) {
    _accountProvider = context.read<AccountProvider>();
    _notificationProvider = context.read<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      constraints.maxWidth < 500 ? constraints.maxWidth : 400,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/logo.jpg",
                            height: 150,
                            width: 150,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Username",
                              prefixIcon: Icon(Icons.email),
                            ),
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.password),
                            ),
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$')
                                  .hasMatch(value)) {
                                return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
                              }
                              return null;
                            },
                            obscureText: true,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var username = _usernameController.text;
                                var password = _passwordController.text;
                                try {
                                  var body = {
                                    'username': username,
                                    'password': password,
                                  };
                                  var result =
                                      await _accountProvider.login(body);
                                  Authorization.token =
                                      result['accessToken'].toString();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => HomePageScreen()));
                                } on Exception catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text("Error"),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("OK"),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text("Login"),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserRegisterScreen()));
                            },
                            child: const Text("Do not have account?"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
