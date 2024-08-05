import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:hackathon_project/provider/favourite_provider.dart';
import 'package:hackathon_project/provider/provider.dart';
import 'package:hackathon_project/services/auth/auth_gate.dart';
import 'package:hackathon_project/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavouriteProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(), //1. call BotToastInit
        navigatorObservers: [
          BotToastNavigatorObserver()
        ], //2. registered route observer
        home: AuthGate(),
      ),
    );
  }
}
