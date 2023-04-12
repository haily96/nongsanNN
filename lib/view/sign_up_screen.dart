


import 'dart:collection';

import 'package:banhangrausach/config/share_config.dart';

import 'package:banhangrausach/view/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState()  => _SignUpScreen();
}
class _SignUpScreen extends State<SignUpScreen>{
  TextEditingController txtSDT = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  TextEditingController txtRePass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)),
        title: const Text("Đăng ký tài khoản"),
      ),
      body:  SingleChildScrollView(
        child:  Column(
          children: [

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
                keyboardType: TextInputType.number,
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
                obscureText: true,
                obscuringCharacter: "*",


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
              margin: const EdgeInsets.only(left: 15,right: 15,top: 25),
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextFormField(
                controller: txtRePass,
                obscureText: true,
                obscuringCharacter: "*",

                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Nhập lại mật khẩu",
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
                  String matkhau = txtPass.text.toString().trim();
                  String nhaplaimatkhau = txtRePass.text.toString().trim();
                  if(sdt.length>=10 && sdt.length<=11){
                    if(matkhau.length>=6){
                      if(matkhau == nhaplaimatkhau){
                        HashMap<String,dynamic> hasMap  = HashMap();
                        hasMap.putIfAbsent("sdt", () => sdt);
                        hasMap.putIfAbsent("matkhau", () => SharedConfig.generateMd5(matkhau));
                        FirebaseFirestore.instance.collection("User")
                        .where("sdt",isEqualTo: sdt).get().then((value) {
                           if(value.docs.isNotEmpty){
                             showToast("SDT đã được đăng ký !");
                           }else{
                             FirebaseFirestore.instance.collection("User")
                                 .add(hasMap).then((value){
                               if(value.id.isNotEmpty){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                                 showToast("Đăng ký thành công");

                               }
                             });
                           }
                        });




                      }else{
                        showToast("Mật khẩu không khớp ");
                      }
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
                child: Text("Đăng Ký",style: GoogleFonts.oswald(
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