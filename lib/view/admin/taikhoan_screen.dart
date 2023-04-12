

import 'dart:collection';

import 'package:banhangrausach/model/hoadon_model.dart';
import 'package:banhangrausach/model/taikhoan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/share_config.dart';

class TaiKhoanScreen extends StatefulWidget{
  const TaiKhoanScreen({super.key});

  @override
  State<StatefulWidget> createState()  => _TaiKhoanScreen();
}
class _TaiKhoanScreen extends State<TaiKhoanScreen>{
  List<TaiKhoanModel> listHoaDon = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();

  }
  init()async{
    FirebaseFirestore.instance.collection("User")
        .get().then((value) {
      if(value.docs.isNotEmpty){
        for(final data in value.docs){
          TaiKhoanModel sanPhamModel = TaiKhoanModel();
          sanPhamModel.id = data.id.toString();
          sanPhamModel.sdt = data.get("sdt");
          sanPhamModel.matkhau = data.get("matkhau");

          listHoaDon.add(sanPhamModel);
        }
        setState(() {

        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
  return WillPopScope(child: Scaffold(
    appBar: AppBar(
      title: const Text("Tài khoản"),
      actions: [
        IconButton(onPressed: (){
          showDiaLogAdd();
        }, icon: Icon(Icons.add))
      ],
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: const Icon(Icons.arrow_back)),
      elevation: 0,
      backgroundColor: Colors.green,
    ),
    body:  Column(
      children: [
        Expanded(child: ListView.builder(
            itemCount: listHoaDon.length,
            itemBuilder: (context,index)=> itemLichSu(listHoaDon[index])))
      ],
    ),
  ), onWillPop: ()async=>false);
  }
  itemLichSu(TaiKhoanModel hoaDonModel){
    return InkWell(
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.only(left: 10),
        margin: const EdgeInsets.only(top: 15,bottom: 15,left: 15,right: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(left: 5,top: 5),child: Text("SDT: "+hoaDonModel.sdt.toString(),style: GoogleFonts.oswald(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black
            ),),),
            Padding(padding: const EdgeInsets.only(left: 5,top: 5),child: Text("Mật khẩu: "+hoaDonModel.matkhau.toString(),style: GoogleFonts.oswald(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black
            ),),),

          ],
        ),
      ),
      onLongPress: (){
        FirebaseFirestore.instance.collection("User")
            .doc(hoaDonModel.id.toString())
            .delete().then((value) {
          listHoaDon.remove(hoaDonModel);
          setState(() {

          });
        });
      },

    );
  }

  void showDiaLogAdd() {
    TextEditingController txtSDT = TextEditingController();
    TextEditingController txtPass = TextEditingController();

    showDialog(context: context, builder: (context){
      return Dialog(
        child: Container(
          width: 320,
          height: 300,
          child: Column(
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
                width: 220,
                height: 50,
                margin: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  onPressed: ()async{
                    String sdt = txtSDT.text.toString().trim();
                    String matkhau = txtPass.text.toString().trim();

                    if(sdt.length>=10 && sdt.length<=11){
                      if(matkhau.length>=6){
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
                                setState(() {
                                  listHoaDon = [];
                                  init();
                                  Navigator.pop(context);
                                });
                                showToast("Tạo thành công");

                              }
                            });
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
                  child: Text("Tạo tài khoản",style: GoogleFonts.oswald(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                  ),),
                ),
              )
            ],
          ),
        )
      );
    });
  }
  void showToast(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }
}