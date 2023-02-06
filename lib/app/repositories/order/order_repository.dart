import 'package:flutter_burger_restaurant_app/app/dto/order_dto.dart';

import '../../models/payment_type_model.dart';

abstract class OrderRepository{
  Future<List<PaymentTypeModel>> getAllPaymentTypes();

  Future<void> saveOrder(OrderDTO order);
}