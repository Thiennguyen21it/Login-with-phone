import 'package:flutter/material.dart';

class UserInforPage extends StatefulWidget {
  const UserInforPage({super.key});

  @override
  State<UserInforPage> createState() => _UserInforPageState();
}

class _UserInforPageState extends State<UserInforPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("User page"),
    );
  }
}
