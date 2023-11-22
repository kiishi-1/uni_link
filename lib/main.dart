import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_link/providers/user_provider.dart';
import 'package:uni_link/resources/navigation_service.dart';
import 'package:uni_link/router/router.dart';
import 'package:uni_link/utils/colors.dart';
import 'package:uni_link/views/home.dart';
import 'package:uni_link/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Uni Link',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        navigatorKey: NavigationService.instance.navigatorKey,
        onGenerateRoute: AppRouter.generateRoute,
        home: StreamBuilder(
          //firebase returns StreamBuilder
          //persisting user authentication state
          //we are using the uid
          //a user can only have uid if they're authenticated(registered)
          //and the uid is in the User object
          //firebase has provided use with a method we can use to know if the user is signed in
          //that method is authStateChanges()
          //this method runs when the user signs in or out
          stream: FirebaseAuth.instance.authStateChanges(),

          builder: ((context, snapshot) {
            //checking if we've made connection to our stream, if the connection is active
            if (snapshot.connectionState == ConnectionState.active) {
              //then if it is active, does it have data as in the user object
              //we are getting data back from the stream when the user sign's in
              //the FirebaseAuth service is going to send something to us every time the user sign's in or out
              //and that something could be a null value if they signed out or user object. if they're signed in
              //our flutter app is going to receive those event object when thet happen
              // and determine based on the value inside of them whether they are user object or not i.e
              //whether the user is logged in or not
              //the snapshot holds the values(data)
              //the snapshot ony has data when the user is signed in
              if (snapshot.hasData) {
                //so, if it has data
                return const Home();
              } else if (snapshot.hasError) {
                //if it does not have data. if it has error
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              //ConnectionState.waiting means Connected to an asynchronous computation and awaiting interaction as in waiting for the result you want to get or for the result to set in the database
              return const Center(
                child: CircularProgressIndicator(color: secondColor),
              );
            }
            return const LoginView();
            //so if the snapshot has no data i.e the user is signed out, it should show the login screen
          }),
        ),
      ),
    );
  }
}
