import 'package:flutter/material.dart';
import 'package:mademe/app/auth_widget.dart';
import 'package:mademe/app/auth_widget_builder.dart';
import 'package:mademe/services/firebase_auth_service.dart';
import 'package:mademe/services/image_picker_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
        Provider<ImagePickerService>(
          create: (_) => ImagePickerService(),
        ),
      ],
      child: AuthWidgetBuilder(builder: (context, userSnapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xFF433D3E),
          ),
          home: AuthWidget(userSnapshot: userSnapshot),
        );
      }),
    );
  }
}

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Login UI',
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(),
//     );
//   }
// }
