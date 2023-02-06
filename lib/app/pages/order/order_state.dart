import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

import '../../dto/order_product_dto.dart';
import '../../models/payment_type_model.dart';

part 'order_state.g.dart';

@match
enum OrderStatus {
  initial,
  loading,
  loaded,
  error,
  updateOrder,
  confirmRemoveProduct,
  emptyBag,
  success,
}

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderProductDTO> orderProducts;
  final List<PaymentTypeModel> paymentTypes;
  final String? errorMessage;

  const OrderState(
      {required this.status,
      required this.orderProducts,
      required this.paymentTypes,
      this.errorMessage});

  const OrderState.initial()
      : status = OrderStatus.initial,
        orderProducts = const [],
        paymentTypes = const [],
        errorMessage = null;

  double get totalOrderValue => orderProducts.fold(
      0.0, (previousValue, element) => previousValue + element.totalPrice);

  @override
  List<Object?> get props =>
      [status, orderProducts, paymentTypes, errorMessage];

  OrderState copyWith(
      {OrderStatus? status,
      List<OrderProductDTO>? orderProducts,
      List<PaymentTypeModel>? paymentTypes,
      String? errorMessage}) {
    return OrderState(
      status: status ?? this.status,
      orderProducts: orderProducts ?? this.orderProducts,
      paymentTypes: paymentTypes ?? this.paymentTypes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OrderConfirmDeleteProductState extends OrderState {
  final OrderProductDTO orderProduct;
  final int index;

  const OrderConfirmDeleteProductState({
    required this.orderProduct,
    required this.index,
    required super.status,
    required super.orderProducts,
    required super.paymentTypes,
    super.errorMessage,
  });
}
