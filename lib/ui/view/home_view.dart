import 'package:flutter/material.dart';
import 'package:todoapp/core/api_services.dart';
import 'package:todoapp/core/model/product.dart';
import 'package:todoapp/ui/shared/widgets/custom_card.dart';
import 'package:todoapp/ui/view/add_product_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ApiService service = ApiService.getInstance();
  List<Product> productList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        centerTitle: true,
      ),
      floatingActionButton: _fabButton,
      body: FutureBuilder<List<Product>>(
        future: service.getProducts(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                productList = snapshot.data;
                return _listView;
              }
              return Center(
                child: Text("Error"),
              );
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  Widget get _listView => ListView.builder(
      itemBuilder: (context, index) => dismiss(
          CustomCard(
            title: productList[index].productName,
            subtitle: "${productList[index].money}",
            imageURL: productList[index].imageURL,
          ),
          productList[index].key),
      itemCount: productList.length);

  Widget dismiss(Widget child, String key) {
    return Dismissible(
      key: UniqueKey(),
      child: child,
      secondaryBackground: Container(color: Colors.red),
      background: Container(color: Colors.red),
      onDismissed: (dissmissDirection) async {
        await service.removeProducts(key);
      },
    );
  }

  Widget get _fabButton => FloatingActionButton(
        onPressed: fabPressed,
        child: Icon(Icons.add),
      );

  void fabPressed() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        context: context,
        builder: (context) => bottomSheet);
  }

  Widget get bottomSheet => Container(
        height: 100,
        child: Column(
          children: <Widget>[
            Divider(
              color: Colors.grey,
              thickness: 2,
              indent: 100,
              endIndent: 100,
            ),
            RaisedButton(
              child: Text("Add Product"),
              onPressed: () {
                Navigator.pop(context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProductView()));
              },
            ),
          ],
        ),
      );
}
