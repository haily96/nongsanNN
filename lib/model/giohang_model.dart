

class GioHangModel{
   String? id;
   String? soluong;
   String? tongtien;
   String? name;
   String? imgPath;

   GioHangModel({this.id,this.soluong,this.tongtien,this.name,this.imgPath});

   factory GioHangModel.fromJson(Map<String,dynamic> map){
     return GioHangModel(
       id: map['ID'],
       soluong: map['SOLUONG'],
       tongtien: map['TONGTIEN'],
       name: map['NAME'],
       imgPath: map['IMGPATH']

     );
   }

}