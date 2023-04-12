import 'dart:collection';
import 'dart:ui';

import 'package:banhangrausach/config/share_config.dart';
import 'package:banhangrausach/databases/DBManager.dart';
import 'package:banhangrausach/model/giohang_model.dart';
import 'package:banhangrausach/view/home_screen.dart';
import 'package:banhangrausach/view/lichsu_hoadon_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../model/sanpham_model.dart';

class GioHangScreen extends StatefulWidget {
  const GioHangScreen({super.key});
  @override
  State<StatefulWidget> createState() => _GioHangScreen();
}

class _GioHangScreen extends State<GioHangScreen> {
  List<GioHangModel> listGioHang = [];
  TextEditingController txtYourName = TextEditingController();
  TextEditingController txtDiachi = TextEditingController();
  TextEditingController txtSDT = TextEditingController();
  int tongtien = 0;
  String sdt = "";
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    sdt = await SharedConfig.getSdt();
    tongtien = 0;
    FirebaseFirestore.instance
        .collection("GioHang")
        .where("sdt", isEqualTo: sdt)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (final data in value.docs) {
          GioHangModel sanPhamModel = GioHangModel();
          sanPhamModel.name = data.get("tensp");
          sanPhamModel.imgPath = data.get("hinhanh");
          sanPhamModel.id = data.id.toString();
          sanPhamModel.soluong = data.get("soluong");
          sanPhamModel.tongtien = data.get("tongtien");

          listGioHang.add(sanPhamModel);
        }
        setState(() {
          for (var i in listGioHang) {
            tongtien += int.parse(i.tongtien.toString());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Giỏ Hàng"),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                },
                icon: const Icon(Icons.arrow_back)),
            elevation: 0,
            backgroundColor: Colors.green,
          ),
          body: Column(
            children: [
              listGioHang.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: listGioHang.length,
                          itemBuilder: (context, index) =>
                              itemGioHang(listGioHang[index])))
                  : Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            "Giỏ hàng trống !",
                            style: GoogleFonts.oswald(
                                fontSize: 18, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
              listGioHang.isNotEmpty
                  ? Container(
                      width: 160,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialogThanhToan();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: Text(
                          "Đặt hàng",
                          style: GoogleFonts.oswald(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        onWillPop: () async => false);
  }

  itemGioHang(GioHangModel gioHangModel) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
      height: 110,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            height: 90,
            margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(gioHangModel.imgPath.toString()),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 15),
                  child: Text(
                    "${gioHangModel.name}",
                    style: GoogleFonts.oswald(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text("Số lượng: ${gioHangModel.soluong}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "Tổng: ${gioHangModel.tongtien}",
                    style: GoogleFonts.oswald(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  FirebaseFirestore.instance
                      .collection("GioHang")
                      .doc(gioHangModel.id.toString())
                      .delete()
                      .then((value) {
                    listGioHang.remove(gioHangModel);
                    setState(() {});
                  });
                });
              },
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red,
              ))
        ],
      ),
    );
  }

  void showDialogThanhToan() async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 420,
              width: 320,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: txtYourName,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Họ tên người nhận hàng",
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: txtDiachi,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Nhập địa chỉ người nhận hàng",
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: txtSDT,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Nhập SĐT người nhận hàng",
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 30,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 30),
                    child: Text(
                      "Tổng tiền :$tongtien",
                      style: GoogleFonts.oswald(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    width: 220,
                    height: 50,
                    margin: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      onPressed: () async {
                        String hoten = txtYourName.text.toString().trim();
                        String diachi = txtDiachi.text.toString().trim();
                        String sdt = txtSDT.text.toString().trim();
                        if (hoten.isNotEmpty) {
                          if (diachi.isNotEmpty) {
                            int result = await DBManager.instances
                                .addHoaDon(hoten, diachi, tongtien);
                            if (result > 0) {
                              DateFormat date = DateFormat("dd/MM/yyyy");
                              String ngaymua = date.format(DateTime.now());
                              HashMap<String, String> hash = HashMap();
                              hash.putIfAbsent("hoten", () => hoten);
                              hash.putIfAbsent("diachi", () => diachi);
                              hash.putIfAbsent(
                                  "tongtien", () => tongtien.toString());
                              hash.putIfAbsent("trangthai", () => "Đang xử lý");
                              hash.putIfAbsent("ngaymua", () => ngaymua);
                              hash.putIfAbsent("sdt", () => sdt);
                              FirebaseFirestore.instance
                                  .collection("ThanhToan")
                                  .add(hash)
                                  .then((value) {
                                if (value.id.isNotEmpty) {
                                  for (GioHangModel sapham in listGioHang) {
                                    HashMap<String, String> hash = HashMap();
                                    hash.putIfAbsent("giatien",
                                        () => sapham.tongtien.toString());
                                    hash.putIfAbsent(
                                        "tensp", () => sapham.name.toString());
                                    hash.putIfAbsent("hinhanh",
                                        () => sapham.imgPath.toString());
                                    hash.putIfAbsent("soluong",
                                        () => sapham.soluong.toString());
                                    hash.putIfAbsent("sdt", () => sdt);
                                    hash.putIfAbsent(
                                        "idhoadon", () => value.id.toString());
                                    FirebaseFirestore.instance
                                        .collection("ChiTietHD")
                                        .add(hash)
                                        .then((value) {});
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LichSuHoaDonScreen()));
                                }
                              });
                            } else {}
                          } else {
                            showToast("Địa chỉ không để trống");
                          }
                        } else {
                          showToast("Họ tên không để trống");
                        }                    
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(
                        "Xác nhận",
                        style: GoogleFonts.oswald(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void showToast(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }
}
