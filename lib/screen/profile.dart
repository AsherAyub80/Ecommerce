import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/Widgets/bottom_nav.dart';
import 'package:hackathon_project/screen/home_screen.dart';
import 'package:hackathon_project/screen/order_detail.dart';
import 'package:hackathon_project/services/auth/auth_gate.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';
import 'package:hackathon_project/services/auth/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userDetails;

  final authService = AuthService();
  bool isLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference users;
  @override
  void initState() {
    super.initState();
    users = _firestore.collection('users');
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      final authservice = AuthService();
      final currentUser = authservice.getCurrentUser();
      if (currentUser != null) {
        final email = currentUser.email;
        if (email != null) {
          final QuerySnapshot querySnapshot =
              await users.where('email', isEqualTo: email).get();
          if (querySnapshot.docs.isNotEmpty) {
            setState(() {
              userDetails =
                  querySnapshot.docs.first.data() as Map<String, dynamic>;
              isLoading = false;
            });
          } else {
            throw Exception('No user data found');
          }
        } else {
          throw Exception('User email is null');
        }
      } else {
        throw Exception('No user is currently logged in');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
    if (userDetails == null) {
      return Scaffold(
        body: Center(child: Text('User details not available')),
      );
    }
    final email = userDetails!['email'] as String;
    final username = userDetails!['username'] as String;
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: CustomAppBar(
              barTitle: 'Profile',
              trailicon: const Icon(Icons.settings),
              leadicon: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNav()),
                  );
                },
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
          SizedBox(height: 50),
          Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Text(
                    username[0],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                title: Text(
                  username,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(email),
                  ],
                ),
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrderDetail()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shopping_bag_outlined),
                          SizedBox(width: 8),
                          Text(
                            'My Orders',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () async {
                  try {
                    await authService.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AuthGate()));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign out failed: $e')),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 8),
                          Text(
                            'Sign out',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Icon(Icons.logout_outlined),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
