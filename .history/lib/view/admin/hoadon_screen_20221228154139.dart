

import 'dart:collection';

import 'package:banhangrausach/databases/DBManager.dart';
import 'package:banhangrausach/model/hoadon_model.dart';
import 'package:banhangrausach/view/admin/hoadon_chitiet_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/share_config.dart';

class HoaDonScreen extends StatefulWidget{
  const HoaDonScreen({super.key});

  @override
  State<StatefulWidget> createState()  => _HoaDonScreen();
}
class _HoaDonScreen extends State<HoaDonScreen>{
  List<HoaDonModel> listHoaDon = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();

  }
  init()async{

    listHoaDon = [];
        FirebaseFirestore.instance.collection("ThanhToan")
        .get().then((value) {
      if(value.docs.isNotEmpty){
        for(final data in value.docs){
          HoaDonModel sanPhamModel = HoaDonModel();
          sanPhamModel.id = data.id.toString();
          sanPhamModel.diachi = data.get("diachi");
          sanPhamModel.hoten = data.get("hoten");
          sanPhamModel.tongtien = data.get("tongtien");
          sanPhamModel.trangthai = data.get("trangthai");
          sanPhamModel.ngaymua = data.get("ngaymua");

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
      title: Text("Hóa Đơn"),
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
  itemLichSu(HoaDonModel hoaDonModel){
    return InkWell(
      child: Container(
        width: double.infinity,
        // height: 200,
        padding: const EdgeInsets.only(left: 10),
        margin: const EdgeInsets.only(top: 15,bottom: 15,left: 15,right: 15),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(left: 5,top: 5),child: Text("Mã đơn hàng: ${hoaDonModel.id}",style: GoogleFonts.oswald(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black
            ),),),

            Padding(padding: const EdgeInsets.only(left: 5,top: 5),child: Text("Họ tên: ${hoaDonModel.hoten}",style: GoogleFonts.oswald(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black
            ),),),

            Padding(padding: const EdgeInsets.only(left: 5,top: 5),child: Text("Địa chỉ: ${hoaDonModel.diachi.toString()}",style: GoogleFonts.oswald(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black
            ),),),
            Padding(padding: const EdgeInsets.only(left: 5,top: 5),child: Text("Trạng thái: ${hoaDonModel.trangthai}",style: GoogleFonts.oswald(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black
            ),),),
            Padding(padding: const EdgeInsets.only(left: 5,top: 5),child: Text("Ngày mua: ${hoaDonModel.ngaymua}",style: GoogleFonts.oswald(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black
            ),),),
            Padding(padding: const EdgeInsets.only(left: 5,top: 5),child: Text("Tổng tiền: ${hoaDonModel.tongtien}",style: GoogleFonts.oswald(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.red
            ),),),
          ],
        ),
      ),
      onLongPress: (){
        updateTrangThaiDonHang(hoaDonModel);
      },
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HoaDonChiTietScreen(hoaDonModel)));
      },
    );
  }

  void updateTrangThaiDonHang(HoaDonModel hoaDonModel) {

     List<String> items = ["Đang xử lý","Đang giao hàng","Đã giao hàng", "Đã hủy"];
      String first = "Đang xử lý";
      for(String s in items){
        if(hoaDonModel.trangthai.toString() == s){
          first = s;
        }
      }

    showDialog(context: context, builder: (context){
       return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {

         return Dialog(
           child:  Container(
             width: 320,
             height: 260,
             child:  Column(
               children: [
                 Container(
                   width: 280,
                   height: 50,
                   margin: const EdgeInsets.only(top: 30),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     border: Border.all(color: Colors.grey.shade300)
                   ),
                   child: DropdownButton<String>(
                     value:  first,
                     onChanged: (valie){
                        first  = valie!;
                        setState(() {

                        });
                     },

                     isExpanded: true,
                     underline:  Container(),
                     items: items.map((e) {
                       return DropdownMenuItem(value: e,child: Padding(padding: const EdgeInsets.only(left: 10,right: 10),child: Text(e),),);
                     }).toList(),
                   ),
                 ),
                 Container(
                   width: 280,
                   height: 50,
                   margin: const EdgeInsets.only(top: 30),
                   child: ElevatedButton(
                     onPressed: (){
                       HashMap<String,String> map = HashMap();
                       map.putIfAbsent("trangthai", () => first);
                       FirebaseFirestore.instance.collection("ThanhToan")
                           .doc(hoaDonModel.id.toString())
                           .update(map).then((value) {
                            init();
                            Navigator.pop(context);
                            setState(() {


                            });
                       });
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor:  Colors.indigo
                     ),
                     child: Text("Cập nhật",style: GoogleFonts.oswald(
                       fontSize: 17,
                       fontWeight: FontWeight.bold,
                       color: Colors.white
                     ),),
                   ),
                 )
               ],
             ),
           ),
         );
       },

       );
    });
  }

}