


import 'package:banhangrausach/view/admin_screen.dart';
import 'package:banhangrausach/view/home_screen.dart';
import 'package:banhangrausach/view/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInAdminScreen extends StatefulWidget{
  const SignInAdminScreen({super.key});

  @override
  State<StatefulWidget> createState()  => _SignInAdminScreen();
}
class _SignInAdminScreen extends State<SignInAdminScreen>{
  TextEditingController txtSDT = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)),
        title: const Text("Quản trị viên"),
      ),
      body:  SingleChildScrollView(
        child:  Column(
          children: [

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

                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Nhập tên tài khoản",
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
              width: 220,
              height: 50,
              margin: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: ()async{
                  String sdt = txtSDT.text.toString().trim();
                  String mk = txtPass.text.toString().trim();
                  if(sdt == "Admin"){
                    if(mk  == "123456"){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const AdminScreen()));

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