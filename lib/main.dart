
import 'package:business_app/screens/AboutUs.dart';
import 'package:business_app/screens/HelpCentre.dart';
import 'package:business_app/screens/SetUpCollaboration.dart';
import 'package:business_app/screens/addOffer.dart';
import 'package:business_app/screens/application-submit.dart';
import 'package:business_app/screens/business_details.dart';
import 'package:business_app/screens/collaboration.dart';
import 'package:business_app/screens/dashboard.dart';
import 'package:business_app/screens/login.dart';
import 'package:business_app/screens/login_dashboard.dart';
import 'package:business_app/screens/onboarding_screen.dart';
import 'package:business_app/screens/owners_details.dart';
import 'package:business_app/screens/select_business_type_screen.dart';
import 'package:business_app/screens/settings.dart';
import 'package:business_app/screens/splash_screen.dart';
import 'package:business_app/screens/business_logo.dart';
import 'package:business_app/services/business_registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
  ChangeNotifierProvider(
    create: (_) => BusinessRegistrationProvider(),
    child: BusinessApp(),
  ));
}

class BusinessApp extends StatelessWidget {
  
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Business App',
      theme: ThemeData( 
        primarySwatch: Colors.blue,
      ),
      home:SplashScreen(),
      routes: {

        '/login-screen':(context) =>LoginScreen(),
        '/select-business-type': (context) => SelectBusinessTypeScreen(),
        '/business-details': (context) => BusinessDetailsScreen(),
        '/owner-details': (context) => OwnerDetailsScreen(),
        '/business-logo': (context) => BrandingScreen(),
        '/dashboard': (context) => BusinessHomeScreen(),
        '/dashboard1':(context)=>Dashboard(),
        '/submitted': (context) => ApplicationSubmittedScreen(),
        '/createOffer':(context) => AddOfferScreen(),
       
      },
    );
  }
}
