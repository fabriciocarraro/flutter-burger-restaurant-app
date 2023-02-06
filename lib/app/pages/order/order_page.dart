import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_burger_restaurant_app/app/core/extensions/formatter_extension.dart';
import 'package:flutter_burger_restaurant_app/app/core/ui/styles/text_styles.dart';
import 'package:flutter_burger_restaurant_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:flutter_burger_restaurant_app/app/core/ui/widgets/delivery_button.dart';
import 'package:flutter_burger_restaurant_app/app/dto/order_dto.dart';
import 'package:flutter_burger_restaurant_app/app/dto/order_product_dto.dart';
import 'package:flutter_burger_restaurant_app/app/pages/order/order_controller.dart';
import 'package:flutter_burger_restaurant_app/app/pages/order/order_state.dart';
import 'package:flutter_burger_restaurant_app/app/pages/order/widget/order_field.dart';
import 'package:flutter_burger_restaurant_app/app/pages/order/widget/order_product_tile.dart';
import 'package:flutter_burger_restaurant_app/app/pages/order/widget/payments_type_field.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/ui/base_state/base_state.dart';
import '../../models/payment_type_model.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final formKey = GlobalKey<FormState>();
  final addressEC = TextEditingController();
  final documentEC = TextEditingController();
  int? paymentTypeId;
  final paymentTypeValid = ValueNotifier<bool>(true);

  @override
  void onReady() {
    final products =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDTO>;
    controller.load(products);
  }

  void _showConfirmProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
              "Deseja excluir o produto ${state.orderProduct.product.name}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.cancelDeleteProcess();
              },
              child: Text(
                "Cancelar",
                style: context.textStyles.textBold.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.decrementProduct(state.index);
              },
              child: Text(
                "Confirmar",
                style: context.textStyles.textBold,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          loading: () => showLoader(),
          error: () {
            hideLoader();
            showError(state.errorMessage ?? 'Erro não informado');
          },
          confirmRemoveProduct: () {
            hideLoader();
            if (state is OrderConfirmDeleteProductState) {
              _showConfirmProductDialog(state);
            }
          },
          emptyBag: () {
            showInfo(
                'Sua sacola está vazia. Por favor, selecione um produto para realizar seu pedido.');
            Navigator.pop(context, <OrderProductDTO>[]);
          },
          success: () {
            hideLoader();
            Navigator.of(context).popAndPushNamed('/order/completed',
                result: <OrderProductDTO>[]);
          },
        );
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(controller.state.orderProducts);
          return false;
        },
        child: Scaffold(
          appBar: DeliveryAppBar(),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Row(children: [
                      Text(
                        'Carrinho',
                        style: context.textStyles.textTitle,
                      ),
                      IconButton(
                        onPressed: () => controller.emptyBag(),
                        icon: Image.asset('assets/images/trashRegular.png'),
                      ),
                    ]),
                  ),
                ),
                BlocSelector<OrderController, OrderState,
                        List<OrderProductDTO>>(
                    selector: (state) => state.orderProducts,
                    builder: (context, orderProducts) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: orderProducts.length,
                          (context, index) {
                            final orderProduct = orderProducts[index];
                            return Column(
                              children: [
                                OrderProductTile(
                                  index: index,
                                  orderProduct: orderProduct,
                                ),
                                const Divider(
                                  color: Colors.grey,
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total do pedido',
                              style: context.textStyles.textExtraBold
                                  .copyWith(fontSize: 16),
                            ),
                            BlocSelector<OrderController, OrderState, double>(
                              selector: (state) => state.totalOrderValue,
                              builder: (context, totalOrderValue) {
                                return Text(
                                  totalOrderValue.currencyPTBR,
                                  style: context.textStyles.textExtraBold
                                      .copyWith(fontSize: 16),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: 'Endereço de entrega',
                        controller: addressEC,
                        validator:
                            Validatorless.required('Endereço obrigatório'),
                        hintText: 'Digite um endereço',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: 'CPF',
                        controller: documentEC,
                        validator: Validatorless.required('CPF obrigatório'),
                        hintText: 'Digite o CPF',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocSelector<OrderController, OrderState,
                          List<PaymentTypeModel>>(
                        selector: (state) => state.paymentTypes,
                        builder: (context, paymentTypes) {
                          return ValueListenableBuilder(
                            valueListenable: paymentTypeValid,
                            builder: (_, paymentTypeValidValue, child) {
                              return PaymentTypesField(
                                paymentTypes: paymentTypes,
                                valueChanged: (value) {
                                  paymentTypeId = value;
                                },
                                valid: paymentTypeValidValue,
                                valueSelected: paymentTypeId.toString(),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DeliveryButton(
                          width: double.infinity,
                          height: 48,
                          label: 'FINALIZAR',
                          onPressed: () {
                            final valid =
                                formKey.currentState?.validate() ?? false;
                            final paymentTypeSelected = paymentTypeId != null;
                            paymentTypeValid.value = paymentTypeSelected;

                            if (valid && paymentTypeSelected) {
                              controller.saveOrder(
                                  address: addressEC.text,
                                  document: documentEC.text,
                                  paymentMethodId: paymentTypeId!);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
