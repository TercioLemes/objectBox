import 'package:objectbox/objectbox.dart';

@Entity()
class Produto {
  @Id()
  int id = 0;
  String name;
  String country;
  int productId;

  Produto({
    required this.name,
    required this.country,
    required this.productId,
  });

  @Transient()
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      name: json['productName'],
      country: json['country'],
      productId: int.parse(json['productId']),
    );
  }

  @Transient()
  Map<String, dynamic> toJson() {
    return {
      'productName': name,
      'country': country,
      'productId': productId,
    };
  }
}
