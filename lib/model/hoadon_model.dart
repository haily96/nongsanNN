

class HoaDonModel{
  String? id;
  String? hoten;
  String? diachi;
  String? sdt;
  String? trangthai;
  String? tongtien;
  String? ngaymua;

  HoaDonModel({this.id,this.hoten,this.diachi,this.sdt,this.tongtien,this.ngaymua});

  factory HoaDonModel.fromJson(Map<String,dynamic> map){
    return HoaDonModel(
      id: map['ID'],
      hoten: map['HOTEN'],
      diachi: map['DIACHI'],
      sdt: map['SDT'],
      tongtien: map['TONGTIEN']
    );
  }
}