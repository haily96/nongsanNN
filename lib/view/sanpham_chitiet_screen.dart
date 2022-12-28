
import 'dart:collection';

import 'package:banhangrausach/config/share_config.dart';
import 'package:banhangrausach/databases/DBManager.dart';
import 'package:banhangrausach/model/sanpham_model.dart';
import 'package:banhangrausach/view/giohang_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SanPhamChiTietScreen extends StatefulWidget {
  SanPhamModel sanPhamModel;

  SanPhamChiTietScreen(this.sanPhamModel);

  @override
  State<StatefulWidget> createState() => _SanPhamChiTietScreen();
}

class _SanPhamChiTietScreen extends State<SanPhamChiTietScreen> {
  int count = 1;
  TextEditingController txtNumber = TextEditingController();
  String sdt = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    setState(() {
      txtNumber.text = count.toString();
    });
  }
  init()async{
    sdt = await SharedConfig.getSdt();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            elevation: 0,
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back)),
            title: const Text("Chi tiết sản phẩm"),
            actions: [
              Container(
                width: 120,
                height: 30,
                margin: EdgeInsets.only(top: 5,left: 15,bottom: 5,right: 15),
                child: ElevatedButton(
                  onPressed: ()async{
                    int tongtien  = count * int.parse(widget.sanPhamModel.price.toString());
                    HashMap<String,String> map = HashMap();
                    map.putIfAbsent("soluong", () => count.toString());
                    map.putIfAbsent("tongtien", () => tongtien.toString());
                    map.putIfAbsent("tensp", () => widget.sanPhamModel.name.toString());
                    map.putIfAbsent("hinhanh", () => widget.sanPhamModel.imgPath.toString());
                    map.putIfAbsent("sdt", () => sdt);
// ok amnh ve xpomg r dp

                    FirebaseFirestore.instance.collection("SanPham")
                    .where("tensp",isEqualTo: widget.sanPhamModel.name )
                    .get().then((value) {
                       if(value.docs.isNotEmpty){
                         DocumentSnapshot d = value.docs[0];
                          String soluong = d.get("soluong");

                          if(int.parse(soluong) >= count){
                            HashMap<String, String> map1 = HashMap();
                            int tongSL = int.parse(soluong) - count;
                            map.putIfAbsent("soluong", () => tongSL.toString());
                            FirebaseFirestore.instance.collection("SanPham")
                                .doc(d.id)
                                .update(map1).then((value) {
                              FirebaseFirestore.instance.collection("GioHang")
                                  .add(map).then((value){
                                if(value.id.isNotEmpty){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const GioHangScreen()));
                                }
                              });
                            });
                          }else{
                            ScaffoldMessenger.of(context).
                            showSnackBar(SnackBar(content: Text("Kho tạm thời còn : $soluong ")));
                          }
                       }

                    });







                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade800
                  ),
                  child: Text("Đặt Hàng"),
                ),
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      child:
                          Image.network(widget.sanPhamModel.imgPath.toString()),
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(widget.sanPhamModel.name.toString(),style: GoogleFonts.oswald(
                            fontSize: 20,
                            color: Colors.black
                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15,top: 5),
                          child: Text(widget.sanPhamModel.price.toString()+" V.N.D",style: GoogleFonts.oswald(
                            fontSize: 20,
                            color: Colors.red
                          ),),
                        ),

                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                child: ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      count++;
                                      txtNumber.text = count.toString();
                                    });
                                  },
                                  child: Text("+"),
                                ),
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)
                                ),
                                child: TextFormField(
                                  controller: txtNumber,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 42,
                                height: 42,
                                child: ElevatedButton(
                                  onPressed: (){
                                    setState(() {

                                      if(count>1){
                                        count--;
                                      }
                                      txtNumber.text = count.toString();
                                    });
                                  },
                                  child: Text("-"),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 15),child: Text("Mô tả sản phẩm",style: GoogleFonts.oswald(
                fontSize: 18,
                color: Colors.black
              ),),),

              Expanded(child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                    child: Text(widget.sanPhamModel.description.toString(),textAlign: TextAlign.justify,),
                  ))),
              Padding(padding: EdgeInsets.only(left: 15),child: Text("Quy ước tính số lượng sản phẩm trên app Nông sản: Với rau tính theo mớ, gạo - thịt- củ tính theo kg, trứng tính theo quả",style: GoogleFonts.oswald(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.black
              ),),),
            ],
          ),
        ),
        onWillPop: () async => false);
  }
}
