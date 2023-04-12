


import 'package:banhangrausach/config/share_config.dart';

import 'package:banhangrausach/view/home_screen.dart';
import 'package:banhangrausach/view/sign_in_admin.dart';
import 'package:banhangrausach/view/sign_up_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget{
  const SignInScreen({super.key});

  @override
  State<StatefulWidget> createState()  => _SignInScreen();
}
class _SignInScreen extends State<SignInScreen>{
  TextEditingController txtSDT = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body:  SingleChildScrollView(
        child:  Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 50,right: 15),
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignInAdminScreen()));
                },
                child: Text("Đăng nhập quản trị viên",style: GoogleFonts.oswald(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade700,
                    decoration: TextDecoration.underline
                ),),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 80),
              child: Text("Đăng nhập tài khoản",style: GoogleFonts.oswald(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black
              ),),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 15,right: 15,top: 25),
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextFormField(
                controller: txtSDT,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Nhập số điện thoại",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none
                  ),

                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 15,right: 15,top: 25),
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextFormField(
                controller: txtPass,
                obscuringCharacter: "*",
                obscureText: true,

                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Nhập mật khẩu",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none
                  ),

                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 15,right: 15),
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpScreen()));
                },
                child: Text("Đăng ký tài khoản ?",style: GoogleFonts.oswald(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  decoration: TextDecoration.underline
                ),),
              ),
            ),
            Container(
              width: 220,
              height: 50,
              margin: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: ()async{
                  String sdt = txtSDT.text.toString().trim();
                  String mk = txtPass.text.toString().trim();
                  if(sdt.length>=10 && sdt.length<=11){
                    if(mk.length>=6){
                      FirebaseFirestore.instance.collection("User")
                      .where("sdt",isEqualTo: sdt)
                      .where("matkhau",isEqualTo: SharedConfig.generateMd5(mk)).get().then((value) {
                        if(value.docs.isNotEmpty){
                          DocumentSnapshot d = value.docs[0];
                          SharedConfig.setSDT(sdt);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                        }else{
                          showToast("Sai tài khoản hoặc mật khẩu ");
                        }
                      });


                    }else{
                      showToast("Mật khẩu tối thiểu 6 ký tự !");
                    }

                  }else{
                    showToast("Số điện thoại không hợp lệ");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green
                ),
                child: Text("Đăng Nhập",style: GoogleFonts.oswald(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white
                ),),
              ),
            )
          ],
        ),
      ),
    ), onWillPop: ()async=>false);
  }
  void showToast(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }

}