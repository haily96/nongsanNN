class SanPhamModel {
  String? id;
  String? type;
  String? name;
  String? description;
  String? imgPath;
  String? price;
  String? dateCreate;
  String? soluong;
  String? sdt;

  SanPhamModel(
      {this.id,
      this.type,
      this.name,
      this.description,
      this.imgPath,
      this.price,
      this.dateCreate,
      this.soluong,
        this.sdt
      });

  factory SanPhamModel.fromJson(Map<String, dynamic> map) {
    return SanPhamModel(
      id: map['ID'],
      type: map['TYPE'],
      name: map['NAME'],
      description: map['DESCRIPTION'],
      imgPath: map['IMGPATH'],
      price: map['PRICE'],
      dateCreate: map['DATECREATE'],
        sdt: map['SDT']
    );
  }
}
