import 'package:flutter_burger_restaurant_app/app/models/product_model.dart';

class OrderProductDTO {
  final ProductModel product;
  final int amount;

  OrderProductDTO({
    required this.product,
    required this.amount,
  });

  double get totalPrice => amount * product.price;

  OrderProductDTO copyWith({
    ProductModel? product,
    int? amount,
  }) {
    return OrderProductDTO(
        product: product ?? this.product, amount: amount ?? this.amount);
  }
}
