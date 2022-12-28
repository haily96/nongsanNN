

import 'dart:collection';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../databases/DBManager.dart';
import '../../model/sanpham_model.dart';

class SanPhamScreen extends StatefulWidget{
  const SanPhamScreen({super.key});

  @override
  State<StatefulWidget> createState()  => _SanPhamScreen();
}
class _SanPhamScreen extends State<SanPhamScreen>{
  List<SanPhamModel> listSanPham = [];
  TextEditingController txtName= TextEditingController();
  TextEditingController txtprice= TextEditingController();
  TextEditingController txtMota= TextEditingController();
  TextEditingController txtHinhAnh= TextEditingController();
  TextEditingController txtSoLuong= TextEditingController();
  List<String> itemsType = ["Gạo","Rau","Củ", "Trứng - Thịt"];
  String first ="Gạo";
  int type = 1;

  init() async {
     FirebaseFirestore.instance.collection("SanPham")
     .get().then((value) {
        if(value.docs.isNotEmpty){
          for(final data in value.docs){
            SanPhamModel sanPhamModel = SanPhamModel();
            sanPhamModel.soluong = data.get("soluong");
            sanPhamModel.id = data.id.toString();
            sanPhamModel.name = data.get("tensp");
            sanPhamModel.price = data.get("giatien");
            sanPhamModel.description = data.get("mota");
            sanPhamModel.imgPath = data.get("hinhanh");
            sanPhamModel.type = data.get("type");


            listSanPham.add(sanPhamModel);
          }
          setState(() {

          });
        }
     });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text("Sản Phẩm"),
        actions: [
          IconButton(onPressed: (){
            showAddDialog();
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
          listSanPham.isNotEmpty ?  Expanded(child: ListView.builder(
              itemCount: listSanPham.length,
              itemBuilder: (context,index)=> itemSanPham(listSanPham[index])),) :
              Container(
                width: double.infinity,
                height: 42,
                margin: EdgeInsets.only(top: 50),
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
        ],
      )
    ), onWillPop: ()async=>false);
  }
  itemSanPham(SanPhamModel gioHangModel){
    return InkWell(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
        height: 130,

        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 90,
              height: 90,
              margin: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(gioHangModel.imgPath.toString()),
              ),
            ),
            Expanded(flex: 1,child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(left: 5,top: 15),child: Text("${gioHangModel.name}",style: GoogleFonts.oswald(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black
                ),),),

                Padding(padding: const EdgeInsets.only(left: 5),child: Text(" ${gioHangModel.price}",style: GoogleFonts.oswald(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.red
                ),),),
                Padding(padding: const EdgeInsets.only(left: 5),child: Text("Kho: ${gioHangModel.soluong}",style: GoogleFonts.oswald(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.red
                ),),),

              ],
            ),),
            Column(
              children: [
                IconButton(onPressed: (){
                  FirebaseFirestore.instance.collection("SanPham")
                      .doc(gioHangModel.id.toString())
                      .delete().then((value){
                    listSanPham.remove(gioHangModel);
                    setState(() {

                    });
                  });

                }, icon: Icon(Icons.delete,color: Colors.red,)),
                IconButton(onPressed: (){
                  showEdit(gioHangModel);
                }, icon: Icon(Icons.edit,color: Colors.grey,)),
              ],
            )


          ],
        ),
      ),

    );
  }
  void showAddDialog()async{
     showDialog(context: context, builder: (context){
       return Dialog(
         child: StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
           return Container(
             width: 320,
             height: 500,
             child:  SingleChildScrollView(
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
                       controller: txtName,

                       textAlign: TextAlign.center,
                       decoration: const InputDecoration(
                         hintText: "Nhập tên sản phẩm",
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
                       controller: txtprice,
                       keyboardType: TextInputType.number,
                       inputFormatters: [
                         FilteringTextInputFormatter.digitsOnly
                       ],

                       textAlign: TextAlign.center,
                       decoration: const InputDecoration(
                         hintText: "Nhập giá tiền",
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
                       controller: txtMota,
                       textAlign: TextAlign.center,
                       decoration: const InputDecoration(
                         hintText: "Nhập mô tả",
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
                       controller: txtHinhAnh,


                       textAlign: TextAlign.center,
                       decoration:  InputDecoration(
                         hintText: "Nhập link hình ảnh",
                         suffixIcon: IconButton(onPressed: (){
                           FlutterClipboard.paste().then((value) {
                             // Do what ever you want with the value.
                             setState(() {
                               txtHinhAnh.text = value;

                             });
                           });
                         }, icon: Icon(Icons.paste,color: Colors.green,)),
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
                       controller: txtSoLuong,
                       keyboardType:  TextInputType.number,

                       inputFormatters: [
                         FilteringTextInputFormatter.digitsOnly
                       ],


                       textAlign: TextAlign.center,
                       decoration:  InputDecoration(
                         hintText: "Nhập số lượng sản phẩm",

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
                     height: 50,
                     margin: EdgeInsets.only(top: 10,left: 15,right: 15),
                     decoration: BoxDecoration(
                       color: Colors.grey.shade200,
                       borderRadius: BorderRadius.circular(10)
                     ),
                     child: DropdownButton<String>(
                       value: first,
                       underline: Container(),
                       alignment: Alignment.center,

                       isExpanded: true,

                       items: itemsType.map((e) {
                         return DropdownMenuItem(child: Padding(padding: EdgeInsets.only(left: 15),child: Text(e,textAlign: TextAlign.center,),),value: e,);
                       }).toList(),
                       onChanged: (key){
                         setState(() {
                           first = key!;
                           for(int i = 0 ; i< itemsType.length;i++){
                               if(first == itemsType[i]){
                                 type=i+1;
                               }
                           }
                           print(type);
                         });
                       },
                     ),
                   ),
                   Container(
                     width: 220,
                     height: 50,
                     margin: const EdgeInsets.only(top: 30),
                     child: ElevatedButton(
                       onPressed: ()async{
                         String tensp = txtName.text.toString().trim();
                         String giatien = txtprice.text.toString().trim();
                         String mota = txtMota.text.toString().trim();
                         String hinhanh = txtHinhAnh.text.toString().trim();
                         String soluong = txtSoLuong.text.toString().trim();
                         if(tensp.isNotEmpty){
                           if(giatien.isNotEmpty){
                             int price = int.parse(giatien);
                             if(mota.isNotEmpty){

                               if(hinhanh.isNotEmpty){

                                 HashMap<String,String> map = HashMap();
                                 map.putIfAbsent("tensp", () => tensp);
                                 map.putIfAbsent("giatien", () => giatien);
                                 map.putIfAbsent("mota", () => mota);
                                 map.putIfAbsent("hinhanh", () => hinhanh);
                                 map.putIfAbsent("type", () => first);
                                 map.putIfAbsent("soluong", () => soluong);
                                 FirebaseFirestore.instance.collection("SanPham")
                                 .add(map).then((value){
                                    if(value.id.isNotEmpty){

                                      setState(() {
                                        init();
                                      });
                                    }
                                 });




                               }else{
                                 showToast("Vui lòng nhập link hình ảnh");
                               }

                             }else{
                               showToast("Vui lòng nhập mô tả");
                             }

                           }else{
                             showToast("Giá tiền > 0");
                           }
                         }else{
                           showToast("Vui lòng nhập tên sản phẩm ");
                         }


                       },
                       style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.green
                       ),
                       child: Text("Xác nhận",style: GoogleFonts.oswald(
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
         },

         ),
       );
     });
  }
  void showEdit(SanPhamModel sanPhamModel)async{
       txtHinhAnh.text = sanPhamModel.imgPath.toString();
       txtprice.text = sanPhamModel.price.toString();
       txtMota.text = sanPhamModel.description.toString();
       txtName.text = sanPhamModel.name.toString();
       txtSoLuong.text = sanPhamModel.soluong.toString();
       first = sanPhamModel.type.toString();
     showDialog(context: context, builder: (context){
       return Dialog(
         child: StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
           return Container(
             width: 320,
             height: 500,
             child:  SingleChildScrollView(
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
                       controller: txtName,

                       textAlign: TextAlign.center,
                       decoration: const InputDecoration(
                         hintText: "Nhập tên sản phẩm",
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
                       controller: txtprice,
                       keyboardType: TextInputType.number,
                       inputFormatters: [
                         FilteringTextInputFormatter.digitsOnly
                       ],

                       textAlign: TextAlign.center,
                       decoration: const InputDecoration(
                         hintText: "Nhập giá tiền",
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
                       controller: txtMota,


                       textAlign: TextAlign.center,
                       decoration: const InputDecoration(
                         hintText: "Nhập mô tả",
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
                       controller: txtHinhAnh,


                       textAlign: TextAlign.center,
                       decoration:  InputDecoration(
                         hintText: "Nhập link hình ảnh",
                         suffixIcon: IconButton(onPressed: (){
                           FlutterClipboard.paste().then((value) {
                             // Do what ever you want with the value.
                             setState(() {
                               txtHinhAnh.text = value;

                             });
                           });
                         }, icon: Icon(Icons.paste,color: Colors.green,)),
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
                       controller: txtSoLuong,
                       inputFormatters: [
                         FilteringTextInputFormatter.digitsOnly
                       ],


                       textAlign: TextAlign.center,
                       decoration:  InputDecoration(
                         hintText: "Nhập số lượng sản phẩm",

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
                     height: 50,
                     margin: EdgeInsets.only(top: 10,left: 15,right: 15),
                     decoration: BoxDecoration(
                       color: Colors.grey.shade200,
                       borderRadius: BorderRadius.circular(10)
                     ),
                     child: DropdownButton<String>(
                       value: first,
                       underline: Container(),
                       alignment: Alignment.center,

                       isExpanded: true,

                       items: itemsType.map((e) {
                         return DropdownMenuItem(child: Padding(padding: EdgeInsets.only(left: 15),child: Text(e,textAlign: TextAlign.center,),),value: e,);
                       }).toList(),
                       onChanged: (key){
                         setState(() {
                           first = key!;
                           for(int i = 0 ; i< itemsType.length;i++){
                               if(first == itemsType[i]){
                                 type=i+1;
                               }
                           }
                           print(type);
                         });
                       },
                     ),
                   ),
                   Container(
                     width: 220,
                     height: 50,
                     margin: const EdgeInsets.only(top: 30),
                     child: ElevatedButton(
                       onPressed: ()async{
                         String tensp = txtName.text.toString().trim();
                         String giatien = txtprice.text.toString().trim();
                         String mota = txtMota.text.toString().trim();
                         String hinhanh = txtHinhAnh.text.toString().trim();
                         String soluong = txtSoLuong.text.toString().trim();
                         if(tensp.isNotEmpty){
                           if(giatien.isNotEmpty){
                             int price = int.parse(giatien);
                             if(mota.isNotEmpty){

                               if(hinhanh.isNotEmpty){

                                 HashMap<String,String> map = HashMap();
                                 map.putIfAbsent("tensp", () => tensp);
                                 map.putIfAbsent("giatien", () => giatien);
                                 map.putIfAbsent("mota", () => mota);
                                 map.putIfAbsent("hinhanh", () => hinhanh);
                                 map.putIfAbsent("type", () => first);
                                 map.putIfAbsent("soluong", () => soluong);
                                 FirebaseFirestore.instance.collection("SanPham")
                                 .doc(sanPhamModel.id.toString())
                                 .update(map).whenComplete(() {
                                   setState(() {
                                     listSanPham = [];
                                     init();
                                   });
                                   Navigator.pop(context);
                                 });





                               }else{
                                 showToast("Vui lòng nhập link hình ảnh");
                               }

                             }else{
                               showToast("Vui lòng nhập mô tả");
                             }

                           }else{
                             showToast("Giá tiền > 0");
                           }
                         }else{
                           showToast("Vui lòng nhập tên sản phẩm ");
                         }


                       },
                       style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.green
                       ),
                       child: Text("Xác nhận",style: GoogleFonts.oswald(
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
         },

         ),
       );
     });
  }
  void showToast(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }
}