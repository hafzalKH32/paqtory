class Product {
  final String id;
  final String name;
  final String image;
  final double price;

  Product({required this.id, required this.name, required this.image, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    image: json['image'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'productId': id,
    'name': name,
    'image': image,
    'price': price,
  };
}
