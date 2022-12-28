

import 'package:banhangrausach/databases/DBManager.dart';
import 'package:banhangrausach/model/sanpham_model.dart';
import 'package:banhangrausach/view/sanpham_chitiet_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewAllTypeScreen extends StatefulWidget{
  String type;
  ViewAllTypeScreen(this.type);
  @override
  State<StatefulWidget> createState()  => _ViewAllTypeScreen();
}
class _ViewAllTypeScreen extends State<ViewAllTypeScreen>{
  List<SanPhamModel> listSanPham = [];
  List<SanPhamModel> listSanPhamSearch = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  init()async{
    FirebaseFirestore.instance.collection("SanPham")
    .where("type",isEqualTo: widget.type.toString())
        .get().then((value) {
      if(value.docs.isNotEmpty){
        for(final data in value.docs){
          SanPhamModel sanPhamModel = SanPhamModel();
          sanPhamModel.id = data.id.toString();
          sanPhamModel.name = data.get("tensp");
          sanPhamModel.price = data.get("giatien");
          sanPhamModel.description = data.get("mota");
          sanPhamModel.imgPath = data.get("hinhanh");
          sanPhamModel.type = data.get("type");
          listSanPham.add(sanPhamModel);
        }
        setState(() {
          listSanPhamSearch.addAll(listSanPham);
        });
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text("Tất cả"),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        backgroundColor: Colors.green,
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(left: 45,right: 45,top: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200)
              ),
              child: TextFormField(
                textAlign: TextAlign.center,
                onChanged: (keySearch){
                   setState(() {
                     listSanPham.clear();
                     if(keySearch.isNotEmpty){
                       for(final i in listSanPhamSearch){
                         if(i.name.toString().toLowerCase().contains(keySearch.toLowerCase())){
                           listSanPham.add(i);
                         }
                       }
                     }else{
                       listSanPham.addAll(listSanPhamSearch);
                     }


                   });
                },
                decoration: InputDecoration(

                  hintText: "Nhập tên sản phẩm",
                  suffixIcon: Icon(Icons.search),
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
              width: double.infinity,
              height: 700,
              child: ListView.builder(
                  itemCount: listSanPham.length,
                  itemBuilder: (context,index)=> itemGioHang(listSanPham[index])),),

          ],
        ),
      ),
    ), onWillPop: ()async=>false);
  }
  itemGioHang(SanPhamModel gioHangModel){
    return InkWell(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
        height: 110,

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
              ],
            ),),


          ],
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> SanPhamChiTietScreen(gioHangModel)));
      },
    );
  }

}