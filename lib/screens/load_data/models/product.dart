class Product {
  final int id;
  final String productName;
  final String productDescription;
  final String categoryName;
  final int categoryID;
  final String dateCreate;

  Product({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.categoryName,
    required this.categoryID,
    required this.dateCreate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      categoryName: json['categoryName'],
      categoryID: json['categoryID'],
      dateCreate: json['dateCreate'],
    );
  }
}
