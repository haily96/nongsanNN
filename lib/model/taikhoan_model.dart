class TaiKhoanModel{
  String? id;
  String? sdt;
  String? matkhau;

  TaiKhoanModel({this.id,this.sdt,this.matkhau});
  factory TaiKhoanModel.fromJson(Map<String, dynamic> map) {
    return TaiKhoanModel(

      sdt: map['SDT'],
      matkhau: map['MK'],

    );
  }
}