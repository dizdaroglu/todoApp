import 'package:flutter/material.dart';
import 'package:todoapp/core/api_services.dart';
import 'package:todoapp/core/model/product.dart';

class AddProductView extends StatefulWidget {
  @override
  _AddProductViewState createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  GlobalKey<FormState> formKey = GlobalKey(debugLabel: "formKey");
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerImage = TextEditingController();

  String validator(val) {
    if (val.isEmpty) {
      return "Bu alanı boş bırakamazsınız";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        autovalidate: true,
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    controller: controllerName,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Product Name",
                        hasFloatingPlaceholder: true),
                    validator: this.validator),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: controllerPrice,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Price",
                        hasFloatingPlaceholder: true),
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Bu alanı boş bırakamazsınız";
                      } else if (int.tryParse(val) == null) {
                        return "Lütfen sayı giriniz";
                      }
                    }),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: controllerImage,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Image Url",
                        hasFloatingPlaceholder: true),
                    validator: this.validator),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () async {
                    var model = Product(
                      productName: controllerName.text,
                      money: int.parse(controllerPrice.text),
                      imageURL: controllerImage.text,
                    );
                    await ApiService.getInstance().addProducts(model);
                    Navigator.pop(context);
                  },
                  child: Text("Add"),
                  shape: StadiumBorder(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
