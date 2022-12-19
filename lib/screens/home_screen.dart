import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:phone_auths/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Center(child: Text("TMESS APP")),
        actions: [
          IconButton(
            onPressed: () {
              app.userSignOut().then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen())));
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple,
            backgroundImage: NetworkImage(app.userModel.profilePic),
            radius: 60,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(app.userModel.uid),
          Text(app.userModel.name),
          Text(app.userModel.email),
          Text(app.userModel.phoneNumber),
          Text(app.userModel.bio),
        ],
      )),
    );
  }
}
