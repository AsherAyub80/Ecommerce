import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hackathon_project/provider/favourite_provider.dart';
import 'package:hackathon_project/provider/page_view_provider.dart';
import 'package:hackathon_project/provider/product_provider.dart';
import 'package:hackathon_project/provider/provider.dart';
import 'package:hackathon_project/screen/checkoutProcess/payment/payment_provider.dart';
import 'package:hackathon_project/services/auth/auth_gate.dart';
import 'package:hackathon_project/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey =
      'pk_test_51PxQxmJJK1h5n0shSnV82WeDJ3YihnBiFAUR65gFhNeRBySsCXAmlpxdWQ3FsS0glrKi8KdkFzy6Rn5qBT4AEdmH00aMbo8fiA';
  await dotenv.load(fileName: "lib/assets/.env");

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
          create: (_) => PageIndexProvider(),
        ),
       
        ChangeNotifierProvider(
          create: (_) => FavouriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentService(),
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
