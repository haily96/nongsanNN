import 'package:banhangrausach/config/share_config.dart';
import 'package:banhangrausach/databases/DBManager.dart';
import 'package:banhangrausach/model/sanpham_model.dart';
import 'package:banhangrausach/view/admin/doanhthu_screen.dart';
import 'package:banhangrausach/view/admin/hoadon_screen.dart';
import 'package:banhangrausach/view/admin/sanpham_screen.dart';
import 'package:banhangrausach/view/admin/taikhoan_screen.dart';
import 'package:banhangrausach/view/giohang_screen.dart';
import 'package:banhangrausach/view/sanpham_chitiet_screen.dart';
import 'package:banhangrausach/view/sign_in_screen.dart';
import 'package:banhangrausach/view/view_all_screen.dart';
import 'package:banhangrausach/view/view_all_type_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'lichsu_hoadon_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminScreen();
}

class _AdminScreen extends State<AdminScreen> {
  List<SanPhamModel> listSanPham = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back)),
            backgroundColor: Colors.green,
            title: Text(
              "ADMIN",
              style: GoogleFonts.oswald(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            elevation: 0,

          ),

          body: Column(
            children: [

              Container(
                width: double.infinity,
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200)),
                        child: Column(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              margin: const EdgeInsets.only(top: 10),
                              child: Image.asset("icon/bill.png"),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Hóa Đơn",
                                style: GoogleFonts.oswald(
                                    fontSize: 18, color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const HoaDonScreen()));
                      },
                    ),

                    InkWell(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200)),
                        child: Column(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              margin: const EdgeInsets.only(top: 10),
                              child: Image.asset("icon/profile.png"),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Tài Khoản",
                                style: GoogleFonts.oswald(
                                    fontSize: 18, color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const TaiKhoanScreen()));
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200)),
                        child: Column(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              margin: const EdgeInsets.only(top: 10),
                              child: Image.asset("icon/rau.png"),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Sản Phẩm",
                                style: GoogleFonts.oswald(
                                    fontSize: 18, color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SanPhamScreen()));
                      },
                    ),
                  ],
                ),

              ),
              Container(
                width: double.infinity,
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200)),
                        child: Column(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              margin: const EdgeInsets.only(top: 10),
                              child: Image.asset("icon/bill.png"),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Doanh Thu",
                                style: GoogleFonts.oswald(
                                    fontSize: 18, color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> DoanhThuScreen()));
                      },
                    ),


                  ],
                ),

              ),


            ],
          ),
        ),
        onWillPop: () async => false);
  }


}
