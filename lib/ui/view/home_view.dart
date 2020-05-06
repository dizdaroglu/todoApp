import 'package:flutter/material.dart';
import 'package:todoapp/core/api_services.dart';
import 'package:todoapp/core/model/product.dart';
import 'package:todoapp/ui/shared/widgets/custom_card.dart';

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
      itemBuilder: (context, index) => CustomCard(
            title: productList[index].productName,
            subtitle: "${productList[index].money}",
            imageURL: productList[index].imageURL,
          ),
      itemCount: productList.length);

  Widget get _fabButton => FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      );
}
