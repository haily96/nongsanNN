

import 'package:banhangrausach/config/share_config.dart';
import 'package:banhangrausach/databases/DBManager.dart';
import 'package:banhangrausach/model/hoadon_model.dart';
import 'package:banhangrausach/view/admin/hoadon_chitiet_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';

class LichSuHoaDonScreen extends StatefulWidget{
  const LichSuHoaDonScreen({super.key});

  @override
  State<StatefulWidget> createState()  => _LichSuHoaDonScreen();
}
class _LichSuHoaDonScreen extends State<LichSuHoaDonScreen>{
  List<HoaDonModel> listHoaDon = [];
  String sdt ="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();

  }
  init()async{
    sdt = await SharedConfig.getSdt();

    FirebaseFirestore.instance.collection("ThanhToan")
    .where("sdt",isEqualTo: sdt)
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
      title: Text("Lịch Sử "),
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
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
        // height: 175,
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
            const SizedBox(height: 10,)
          ],
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HoaDonChiTietScreen(hoaDonModel)));
      },
    );
  }

}