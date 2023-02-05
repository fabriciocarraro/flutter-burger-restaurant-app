import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter_burger_restaurant_app/app/pages/order/order_state.dart';
import '../../dto/order_product_dto.dart';
import '../../repositories/order/order_repository.dart';

class OrderController extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderController(this._orderRepository) : super(OrderState.initial());

  void load(List<OrderProductDTO> products) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));
      final paymentTypes = await _orderRepository.getAllPaymentTypes();
      emit(state.copyWith(
          orderProducts: products,
          status: OrderStatus.loaded,
          paymentTypes: paymentTypes));
    } catch (e, s) {
      log('Erro ao carregar página', error: e, stackTrace: s);
      emit(state.copyWith(
          status: OrderStatus.error, errorMessage: 'Erro ao carregar página'));
    }
  }
}
