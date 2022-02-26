import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_kart/Controller/products_controller.dart';
import 'package:shopping_kart/Models/products_model.dart';
import 'package:shopping_kart/Widgets/main_scrollview.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  ValueNotifier<double> scroll = ValueNotifier<double>(0);
  double maxScroll = 55;

  @override
  Widget build(BuildContext context) {
    ProductsProvider _provider = Provider.of<ProductsProvider>(context);
    List<String> categories = [];
    scroll.addListener(() {
      if (scroll.value >= maxScroll && _provider.selectedCategory != '') {
        _provider.clearSelectedCatagory();
        scroll.value = maxScroll;
      }
    });
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.white10,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                iconSize: 30,
                onPressed: () {
                  categories.clear();
                  for (var e in _provider.allProducts) {
                    if (e.pCategory != null &&
                        !categories.contains(e.pCategory)) {
                      categories.add(e.pCategory!);
                    }
                  }
                  _provider.getSelectedCategory(categories[0]);
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return CupertinoPicker(
                        itemExtent: 70,
                        onSelectedItemChanged: (i) {
                          _provider.getSelectedCategory(categories[i]);
                        },
                        children: List.generate(
                          categories.length,
                          (index) => Center(
                            child: Text(categories.toList()[index]),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.filter_alt_rounded,
                ),
                color: Theme.of(context).primaryColor,
              ),
              Consumer<ProductsProvider>(builder: (context, provider, child) {
                return Visibility(
                  visible: _provider.selectedCategory != '',
                  child: IconButton(
                      onPressed: () {
                        if (_provider.selectedCategory != '') {
                          _provider.clearSelectedCatagory();
                        }
                      },
                      icon: Icon(
                        Icons.restore,
                        color: Theme.of(context).primaryColor,
                      )),
                );
              }),
              Expanded(
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            List json = jsonDecode(_provider.response);
                            var response =
                                getProductsFromJson(_provider.response);
                            for (var e in response) {
                              var i = response.indexOf(e);
                              json[i].addAll(
                                  {'p_quantity': _provider.quantity[e.pName]});
                            }
                            return Dialog(
                              child: SizedBox(
                                height: 500,
                                child: CustomScrollView(
                                  slivers: [
                                    SliverAppBar(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      floating: true,
                                      leading: Container(),
                                      centerTitle: true,
                                      title: const Text(
                                        'Response',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: const EdgeInsets.all(20),
                                      sliver: SliverToBoxAdapter(
                                        child: Text('$json'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Center(
                      child: Consumer<ProductsProvider>(
                        builder: (context, provider, child) {
                          double total = 0;
                          for (var e in provider.allProducts) {
                            total += double.parse(
                                (e.pCost * provider.quantity[e.pName]!)
                                    .toString());
                          }
                          return Text(
                            "Submit${total != 0 ? '  ₹$total' : ''}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          scroll.value = notification.metrics.extentAfter < maxScroll
              ? notification.metrics.extentAfter
              : maxScroll;
          return true;
        },
        child: Stack(
          children: [
            const MainScrollView(),
            ValueListenableBuilder<double>(
                valueListenable: scroll,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: const CircleBorder(),
                  ),
                  child: Icon(
                    Icons.refresh,
                    color: Colors.grey[100],
                  ),
                ),
                builder: (context, scroll, child) {
                  return Positioned(
                      top: scroll * 2 - 24,
                      right: MediaQuery.of(context).size.width / 2,
                      child:
                          Opacity(opacity: scroll / maxScroll, child: child!));
                }),
          ],
        ),
      ),
    );
  }
}
