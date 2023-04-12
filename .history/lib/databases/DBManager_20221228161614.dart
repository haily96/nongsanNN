import 'dart:collection';
import 'dart:io';

import 'package:banhangrausach/config/share_config.dart';
import 'package:banhangrausach/model/giohang_model.dart';
import 'package:banhangrausach/model/hoadon_model.dart';
import 'package:banhangrausach/model/sanpham_model.dart';
import 'package:banhangrausach/model/taikhoan_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBManager {
  Database? _database;

  static DBManager instances = DBManager._();

  DBManager._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await inItDB("bansausach.db");
    return _database!;
  }

  Future<Database> inItDB(String name) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, name);
    var exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "bansausach.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    Database database = await openDatabase(path,readOnly: false);

    return database;
  }

  Future<List<SanPhamModel>> getDataList() async {
    final db = await instances.database;
    String SQL = "SELECT * FROM  SanPham ";
    List<Map<String, dynamic>> list = await db.rawQuery(SQL);
    List<SanPhamModel> listSanPham = [];
    for (var i in list) {
      SanPhamModel categoryModel = SanPhamModel.fromJson(i);
      listSanPham.add(categoryModel);
    }
    return listSanPham;
  }
  Future<List<SanPhamModel>> getDataListType(int type) async {
    final db = await instances.database;
    String SQL = "SELECT * FROM  SanPham  WHERE TYPE = '${type}'";
    List<Map<String, dynamic>> list = await db.rawQuery(SQL);
    List<SanPhamModel> listSanPham = [];
    for (var i in list) {
      SanPhamModel categoryModel = SanPhamModel.fromJson(i);
      listSanPham.add(categoryModel);
    }
    return listSanPham;
  }
  Future<List<GioHangModel>> getDataListGioHang() async {
    final db = await instances.database;
    String SQL = "SELECT GioHang.ID,GioHang.SOLUONG,GioHang.TONGTIEN, SanPham.NAME,SanPham.IMGPATH FROM GioHang,SanPham WHERE GioHang.ID_SP = SanPham.ID ";
    List<Map<String, dynamic>> list = await db.rawQuery(SQL);
    List<GioHangModel> listSanPham = [];
    for (var i in list) {
      GioHangModel gioHangModel = GioHangModel.fromJson(i);
      listSanPham.add(gioHangModel);
    }
    return listSanPham;
  }
  Future<int> addGioHang(SanPhamModel sanPhamModel,int soluong,int tongtien,String idsp) async{
    final sdt = await SharedConfig.getSdt();
    Map<String,dynamic> map = HashMap();
    map.putIfAbsent("ID_SP", () => idsp);
    map.putIfAbsent("SOLUONG", () => soluong);
    map.putIfAbsent("tongtien", () => tongtien);
    map.putIfAbsent("SDT", () => sdt);
    final instanesDB = await instances.database;
   return  instanesDB.insert("GioHang", map);
  }
  Future<int> addHoaDon(String hoten,String diachi,int tongtien) async{
    final sdt = await SharedConfig.getSdt();
    Map<String,dynamic> map = HashMap();
    map.putIfAbsent("HOTEN", () => 'hoten');
    map.putIfAbsent("DIACHI", () => 'diachi');
    map.putIfAbsent("SDT", () => '967976');
    map.putIfAbsent("TONGTIEN", () => 'tongtien');
    final instanesDB = await instances.database;
    return  instanesDB.insert("HoaDon", map);
  }
  Future<bool> signIn(String sdt,String pass)async{
    final instanesDB = await instances.database;
    List<Map<String,dynamic>> list = await instanesDB.rawQuery("SELECT * FROM TaiKhoan WHERE SDT = '${sdt}' AND MK = '${pass}'");
    if(list.length > 0 ){
      return true;
    }
    return false;
  }
  Future<void> deleteAll()async{
    final sdt = await SharedConfig.getSdt();
    final instanesDB = await instances.database;
    instanesDB.rawDelete("DELETE FROM GioHang WHERE SDT = '${sdt}'");
  }

  void deleteGioHang(int id) async{
    final instanesDB = await instances.database;

    instanesDB.rawDelete("DELETE FROM GioHang WHERE ID = '${id}'");

  }

  signup(String sdt, String matkhau) async{
    final instanesDB = await instances.database;
    Map<String,dynamic> map = HashMap();
    map.putIfAbsent("SDT", () => sdt);
    map.putIfAbsent("MK", () => matkhau);
   return instanesDB.insert("TaiKhoan", map);
  }

 Future<List<HoaDonModel>> getDataListHD() async{
    final sdt = await SharedConfig.getSdt();
    final instanesDB = await instances.database;
    String SQL = "SELECT * FROM  HoaDon WHERE SDT = '${sdt}' ";
    List<Map<String, dynamic>> list = await instanesDB.rawQuery(SQL);
    List<HoaDonModel> listHD = [];
    for (var i in list) {
      HoaDonModel h = HoaDonModel.fromJson(i);
      listHD.add(h);
    }
    return listHD;
  }
 Future<List<HoaDonModel>> getDataListHDALL() async{
    final sdt = await SharedConfig.getSdt();
    final instanesDB = await instances.database;
    String SQL = "SELECT * FROM  HoaDon ";
    List<Map<String, dynamic>> list = await instanesDB.rawQuery(SQL);
    List<HoaDonModel> listHD = [];
    for (var i in list) {
      HoaDonModel h = HoaDonModel.fromJson(i);
      listHD.add(h);
    }
    return listHD;
  }
 Future<List<TaiKhoanModel>> getDataListTK() async{
    final sdt = await SharedConfig.getSdt();
    final instanesDB = await instances.database;
    String SQL = "SELECT * FROM  TaiKhoan ";
    List<Map<String, dynamic>> list = await instanesDB.rawQuery(SQL);
    List<TaiKhoanModel> listHD = [];
    for (var i in list) {
      TaiKhoanModel h = TaiKhoanModel.fromJson(i);
      listHD.add(h);
    }
    return listHD;
  }

  void deleteSanPham(int id) async{
    final instanesDB = await instances.database;
    instanesDB.rawDelete("DELETE FROM SanPham WHERE ID = '${id}'");
  }

  addSanPham(String tensp, int price, String mota, String hinhanh,int type) async{
    DateFormat d = DateFormat("dd/MM/yyyy");
    Map<String,dynamic> map = HashMap();
    map.putIfAbsent("NAME", () => tensp);
    map.putIfAbsent("DESCRIPTION", () => mota);
    map.putIfAbsent("IMGPATH", () => hinhanh);
    map.putIfAbsent("PRICE", () => price);
    map.putIfAbsent("DATECREATE", () => d.format(DateTime.now()));
    map.putIfAbsent("TYPE", () => type);
    final instanesDB = await instances.database;
    return  instanesDB.insert("SanPham", map);
  }

  updatesanpham(String tensp, int price, String mota, String hinhanh, String id,int type)async {
    DateFormat d = DateFormat("dd/MM/yyyy");
    Map<String,dynamic> map = HashMap();
    map.putIfAbsent("NAME", () => tensp);
    map.putIfAbsent("DESCRIPTION", () => mota);
    map.putIfAbsent("IMGPATH", () => hinhanh);
    map.putIfAbsent("PRICE", () => price);
    map.putIfAbsent("DATECREATE", () => d.format(DateTime.now()));
    map.putIfAbsent("TYPE", () => type);
    final instanesDB = await instances.database;
    return  instanesDB.update("SanPham", map,where: "ID= '${id}'");
  }


}
