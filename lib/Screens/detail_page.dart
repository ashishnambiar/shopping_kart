import 'package:flutter/material.dart';
import 'package:shopping_kart/Controller/fruits_controller.dart';
import 'package:shopping_kart/Controller/products_controller.dart';
import 'package:provider/provider.dart';
import 'package:shopping_kart/Models/products_model.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProductsProvider _provider = Provider.of<ProductsProvider>(context);
    ProductsModel _current = _provider.allProducts
        .firstWhere((element) => element.pName == _provider.item);
    String _tag = _current.pName;
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: 'bg$_tag',
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: getFruit(_tag).getColors(),
                ),
              ),
              // child: Cener
            ),
          ),
          Positioned(
            top: 30,
            // left: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Hero(
                    tag: 'image$_tag',
                    child: Image.network(
                      getFruit(_tag).getUrl(),
                      loadingBuilder: (context, child, loadingProgress) {
                        var per = loadingProgress == null
                            ? 0.0
                            : (loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!) *
                                100;
                        return loadingProgress != null
                            ? Column(
                                children: [
                                  const LinearProgressIndicator(),
                                  Text('${per.toInt()}%'),
                                ],
                              )
                            : child;
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 40,
                        );
                      },
                    ),
                  ),
                ),
                // Hero(
                //   tag: 'title${_tag}',
                // child:
                Text(
                  _tag,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // ),
                Text(
                  '₹${_current.pCost}',
                  style: const TextStyle(fontSize: 20),
                ),
                const Divider(),
                const SizedBox(height: 30),
                _current.pCategory == null
                    ? Container()
                    : Text('Catergory: ${_current.pCategory}'),
                const SizedBox(height: 10),
                _current.pDetails == null
                    ? Container()
                    : Text(_current.pDetails!,
                        style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
