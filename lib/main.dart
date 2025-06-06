import 'package:business_app/screens/AboutUs.dart';
import 'package:business_app/screens/HelpCentre.dart';
import 'package:business_app/screens/OpeningHoursScreen.dart';
import 'package:business_app/screens/SetUpCollaboration.dart';
import 'package:business_app/screens/addOffer.dart';
import 'package:business_app/screens/application-submit.dart';
import 'package:business_app/screens/business_details.dart';
import 'package:business_app/screens/business_profile.dart';
import 'package:business_app/screens/check_in_points_screen.dart';
import 'package:business_app/screens/collaboration.dart';
import 'package:business_app/screens/collaboration_list_screen.dart';
import 'package:business_app/screens/contestScreen.dart';
import 'package:business_app/screens/createContest.dart';
import 'package:business_app/screens/createContest2.dart';
import 'package:business_app/screens/dashboard.dart';
import 'package:business_app/screens/login.dart';
import 'package:business_app/screens/login_dashboard.dart';
import 'package:business_app/screens/onboarding_screen.dart';
import 'package:business_app/screens/owner_profile.dart';
import 'package:business_app/screens/owners_details.dart';
import 'package:business_app/screens/select_business_type_screen.dart';
import 'package:business_app/screens/settings.dart';
import 'package:business_app/screens/splash_screen.dart';
import 'package:business_app/screens/business_logo.dart';
import 'package:business_app/screens/staff.dart';
import 'package:business_app/services/business_registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:business_app/screens/events/eventsList.dart';
import 'package:business_app/screens/events/createEvent.dart';
import 'screens/registration_success_screen.dart';
import 'screens/track_application_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
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
      home: SplashScreen(),
      routes: {
        '/createContest': (context) => const CreateContestScreen(),
        '/createContest2': (context) => CreateContest2Screen(
              contestData: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>,
            ),
        '/login-screen': (context) => LoginScreen(),
        '/select-business-type': (context) => SelectBusinessTypeScreen(),
        '/business-details': (context) => BusinessDetailsScreen(),
        '/owner-details': (context) => OwnerDetailsScreen(),
        '/business-logo': (context) => BrandingScreen(),
        '/dashboard': (context) => BusinessHomeScreen(),
        '/dashboard1': (context) => Dashboard(),
        '/submitted': (context) => ApplicationSubmittedScreen(),
        '/createOffer': (context) => AddOfferScreen(),
        // '/createContest2':(context) => ContestScreen(),
        '/editBusinessProfile': (context) => BusinessInfoScreen(),
        '/manageStaff': (context) => ManageStaffComponent(),
        '/editOwnerDetails': (context) => UpdateOwnerDetailsScreen(),
        '/settings': (context) => SettingsScreen(),
        '/openingHours': (context) => OpeningHoursScreen(),
        '/events': (context) => const EventsListScreen(),
        '/createEvent': (context) => const CreateEventScreen(),
        '/checkInPoints': (context) => CheckInPointsScreen(),
        // '/collaboration': (context) => Collaboration(),
        '/setup-collab': (context) => Collaboration(),
        '/registration-success': (context) => const RegistrationSuccessScreen(),
        '/track-application': (context) => const TrackApplicationScreen(),
      },
    );
  }
}
