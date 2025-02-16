import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vakinha_burguer_mobile/app/core/ui/formatter_helper.dart';
import 'package:vakinha_burguer_mobile/app/core/ui/widgets/plus_minus_box.dart';
import 'package:vakinha_burguer_mobile/app/core/ui/widgets/vakinha_button.dart';
import 'package:validatorless/validatorless.dart';
import './shopping_card_controller.dart';

class ShoppingCardPage extends GetView<ShoppingCardController> {
  final formKey = GlobalKey<FormState>();

  ShoppingCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constrains) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constrains.maxHeight,
                minWidth: constrains.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Form(
                    key: formKey,
                    child: Visibility(
                      visible: controller.products.isNotEmpty,
                      replacement: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                              child: Text(
                                'Carrinho',
                                style: context.textTheme.headline6?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.theme.primaryColorDark,
                                ),
                              ),
                            ),
                            /* const SizedBox(
                              height: 10,
                            ), */
                            const Center(
                              child: Text(
                                  'O seu carrinho está vazio!\n     Adicione um Produto.'),
                            ),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Carrinho',
                                  style: context.textTheme.headline6?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.theme.primaryColorDark,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => controller.clear(),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Obx(() {
                            return Column(
                              children: controller.products
                                  .map(
                                    (p) => Container(
                                      margin: const EdgeInsets.all(10),
                                      child: PlusMinusBox(
                                        label: p.product.name,
                                        calculateTotal: true,
                                        elevated: true,
                                        backgroundColor: Colors.grey[100]!,
                                        quantity: p.quantity,
                                        price: p.product.price,
                                        minusCallback: () => controller
                                            .subtractQuantityInProduct(p),
                                        plusCallback: () =>
                                            controller.addQuantityInProduct(p),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          }),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total do pedido',
                                  style: context.textTheme.bodyText1
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Obx(() {
                                  return Text(
                                    FormatterHelper.formatCurrency(
                                        controller.totalValue),
                                    style: context.textTheme.bodyText1
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  );
                                })
                              ],
                            ),
                          ),
                          const Divider(),
                          const AdressField(),
                          const Divider(),
                          const CpfField(),
                          const Divider(),
                          const Spacer(),
                          Center(
                            child: SizedBox(
                              width: context.widthTransformer(reducedBy: 10),
                              child: VakinhaButton(
                                label: 'FINALIZAR',
                                onPressed: () {
                                  final formValid =
                                      formKey.currentState?.validate() ?? false;
                                  if (formValid) {
                                    controller.createOrder();
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AdressField extends GetView<ShoppingCardController> {
  const AdressField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 35,
            child: Text(
              'Endereço de entrega',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              controller.address = value;
            },
            validator: Validatorless.required('Endereço obrigatório'),
            decoration: const InputDecoration(
              hintText: 'Digite o endereço',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class CpfField extends GetView<ShoppingCardController> {
  const CpfField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 35,
            child: Text(
              'CPF',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              controller.cpf = value;
            },
            validator: Validatorless.multiple(
              [
                Validatorless.required('CPF obrigatório'),
                Validatorless.cpf('CPF inválido'),
              ],
            ),
            decoration: const InputDecoration(
              hintText: 'Digite o CPF',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
