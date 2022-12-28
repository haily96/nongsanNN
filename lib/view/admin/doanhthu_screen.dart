

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/hoadon_model.dart';

class DoanhThuScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => _DoanhThuScreen();
}
class _DoanhThuScreen extends State<DoanhThuScreen>{
  int tongTienThang = 0;
  int tongTienNam = 0;
  int tongTienNgay = 0;

  DateTime selectDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  init(){
    tongTienNam=0;
    tongTienThang = 0;
    tongTienNgay = 0;
    FirebaseFirestore.instance.collection("ThanhToan")
        .get().then((value) {
      if(value.docs.isNotEmpty){
        for(final data in value.docs){
          if(data.get("ngaymua").toString().split("/")[0] == selectDate.day.toString()){
            tongTienNgay+= int.parse(data.get("tongtien").toString());
          }
          if(data.get("ngaymua").toString().split("/")[1] == selectDate.month.toString()){
            tongTienThang+= int.parse(data.get("tongtien").toString());
          }
          if(data.get("ngaymua").toString().split("/")[2] == selectDate.year.toString()){
            tongTienNam+= int.parse(data.get("tongtien").toString());
          }

        }
        setState(() {

        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.green,
        elevation: 0,
        actions: [
          IconButton(onPressed: ()async{
           final ftime = await showDatePicker(context: context, initialDate: selectDate, firstDate: DateTime(1990), lastDate: DateTime(2030));
           if(ftime!=null){
             selectDate = ftime!;
           }
           setState(() {
             init();
           });
          }, icon: Icon(Icons.date_range))
        ],
        title: Text("Doanh thu"),
      ),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity,),
          Padding(padding: const EdgeInsets.only(left: 5,top: 30),child: Text("Tổng Doanh Thu Ngày: ",style: GoogleFonts.oswald(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.w700
          ),),),
          Padding(padding: const EdgeInsets.only(left: 5,top: 10),child: Text("$tongTienNgay V.N.D",style: GoogleFonts.roboto(
              fontSize: 28,
              color: Colors.redAccent,
              fontWeight: FontWeight.w900
          ),),),
          Padding(padding: const EdgeInsets.only(left: 5,top: 30),child: Text("Tổng Doanh Thu Tháng: ",style: GoogleFonts.oswald(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.w700
          ),),),
          Padding(padding: const EdgeInsets.only(left: 5,top: 10),child: Text("$tongTienThang V.N.D",style: GoogleFonts.roboto(
            fontSize: 28,
            color: Colors.redAccent,
            fontWeight: FontWeight.w900
          ),),),
          Padding(padding: const EdgeInsets.only(left: 5,top: 30),child: Text("Tổng Doanh Thu Năm: ",style: GoogleFonts.oswald(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.w700
          ),),),
          Padding(padding: const EdgeInsets.only(left: 5,top: 10),child: Text("$tongTienNam V.N.D",style: GoogleFonts.roboto(
              fontSize: 28,
                color: Colors.redAccent,
                fontWeight: FontWeight.w900
            ),),),


        ],
      ),
    );

  }

}