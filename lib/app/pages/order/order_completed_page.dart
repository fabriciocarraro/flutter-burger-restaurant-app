import 'package:flutter/material.dart';
import 'package:flutter_burger_restaurant_app/app/core/ui/helpers/size_extensions.dart';
import 'package:flutter_burger_restaurant_app/app/core/ui/styles/text_styles.dart';
import 'package:flutter_burger_restaurant_app/app/core/ui/widgets/delivery_button.dart';

class OrderCompletedPage extends StatelessWidget {
  const OrderCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: context.percentHeight(.20),
              ),
              Image.asset('assets/images/logo_rounded.png'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Pedido realizado com sucesso. Em breve, você receberá a confirmação do seu pedido',
                textAlign: TextAlign.center,
                style: context.textStyles.textExtraBold.copyWith(fontSize: 18),
              ),
              SizedBox(
                height: 40,
              ),
              DeliveryButton(
                  width: context.percentWidth(.80),
                  label: 'FECHAR',
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
