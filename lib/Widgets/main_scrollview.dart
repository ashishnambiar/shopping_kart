import 'package:flutter/material.dart';
import 'package:shopping_kart/Controller/fruits_controller.dart';
import 'package:shopping_kart/Controller/products_controller.dart';
import 'package:shopping_kart/Models/products_model.dart';
import 'package:shopping_kart/Screens/detail_page.dart';
import 'package:shopping_kart/Widgets/slant_clipper.dart';
import 'package:provider/provider.dart';

class MainScrollView extends StatelessWidget {
  const MainScrollView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        SliverAppBar(
          floating: true,
          title:
              Consumer<ProductsProvider>(builder: (context, provider, child) {
            return Text(provider.selectedCategory == ''
                ? 'Shopping Kart'
                : provider.selectedCategory);
          }),
          centerTitle: true,
        ),
        Consumer<ProductsProvider>(
          builder: (context, provider, child) {
            List<ProductsModel> selectedProducts =
                provider.selectedCategory != ''
                    ? provider.allProducts
                        .where((element) =>
                            element.pCategory == provider.selectedCategory)
                        .toList()
                    : provider.allProducts;
            return selectedProducts.isEmpty
                ? SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        ProductsModel data = selectedProducts[index];
                        Fruits fruit = getFruit(data.pName);
                        return InkWell(
                          onTap: () {
                            provider.tappedItem = data.pName;
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const DetailPage(),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ClipPath(
                                  clipper: SlantClipper(),
                                  child: Hero(
                                    tag: 'bg${data.pName}',
                                    child: Container(
                                      height: 100,
                                      // color: Colors.grey,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: fruit.getColors(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: Hero(
                                          tag: 'image${data.pName}',
                                          child: Image.network(
                                            fruit.getUrl(),
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              var per = loadingProgress == null
                                                  ? 0.0
                                                  : (loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!) *
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
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.error,
                                                color: Colors.red,
                                                size: 40,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Hero(
                                              //   tag: 'title${data.pName}',
                                              //   child:
                                              Text(
                                                data.pName,
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              // ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text('₹${data.pCost}',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black54,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${provider.quantity[data.pName]}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    provider.add(data.pName);
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(Icons.add),
                                                  )),
                                              InkWell(
                                                  onTap: () {
                                                    provider.remove(data.pName);
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(Icons.remove),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: selectedProducts.length,
                    ),
                  );
          },
        ),
      ],
    );
  }
}
