import 'package:equatable/equatable.dart';
import 'package:flutter_burger_restaurant_app/app/dto/order_product_dto.dart';
import 'package:match/match.dart';
import '../../models/product_model.dart';
part 'home_state.g.dart';

@match
enum HomeStateStatus {
  initial, //inicial
  loading, //enquanto está indo buscar os produtos para exibi-los
  loaded, //depois de terminar o carregamento
  error,
}

class HomeState extends Equatable {
  final HomeStateStatus status;
  final List<ProductModel> products;
  final String? errorMessage;
  final List<OrderProductDTO> shoppingBag;

  const HomeState({
    required this.status,
    required this.products,
    this.errorMessage,
    required this.shoppingBag,
  });

  const HomeState.initial()
      : status = HomeStateStatus.initial,
        products = const [],
        errorMessage = null,
        shoppingBag = const [];

  @override
  List<Object?> get props => [status, products, errorMessage, shoppingBag];

  HomeState copyWith({
    HomeStateStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
    List<OrderProductDTO>? shoppingBag,
  }) {
    return HomeState(
        status: status ?? this.status,
        products: products ?? this.products,
        errorMessage: errorMessage ?? this.errorMessage,
        shoppingBag: shoppingBag ?? this.shoppingBag);
  }
}
