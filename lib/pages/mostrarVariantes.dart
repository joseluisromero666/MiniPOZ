import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MostrarVariantes extends StatelessWidget {
  var productVariants;
  var changeView;
  MostrarVariantes({this.productVariants, this.changeView});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: (productVariants.get('variants').length !=0)?
        ListView.builder(
            itemCount: productVariants.get('variants').length,
            itemBuilder: (context, variant) => (Column(
                  children: [
                    Divider(
                      height: 8,
                    ),
                    ListTile(
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              productVariants.get('name'),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  productVariants.get('tax'),
                                ),
                              ],
                            )
                          ]),
                      leading: Image(
                          image: productVariants.get('url') != null
                              ? NetworkImage(productVariants.get('url'))
                              : NetworkImage(
                                  'https://i.ibb.co/0Jmshvb/no-image.png')),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$' +
                              productVariants
                                  .get('variants')[variant]['value']
                                  .toString()),
                          Text(productVariants
                              .get('variants')[variant]['name']
                              .toString())
                        ],
                      ),
                    ),
                  ],
                ))):Center(child: Text('No Existen Variantes',),)
      
    );
  }
}
