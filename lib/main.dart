import 'package:banhangrausach/view/home_screen.dart';
import 'package:banhangrausach/view/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FARMER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: PageHome()
    );
  }
}

class PageHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => _PageHome();

}
class _PageHome extends State<PageHome>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        children: [
            Container(
              width: double.infinity,
              height: 135,
              margin: EdgeInsets.only(top: 100),
              alignment: Alignment.center,
              child: Image.asset("icon/logo.png",width: 135,height: 135,),
            ),
          Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            child: Text("FARMER",style: GoogleFonts.oswald(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.green
            ),),
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignInScreen()));
    });
  }

}
