import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ProductModel {
  String? imagename;
  String? imageurl;
  int? price;

  ProductModel(String imagename, String imageurl, int price) {
    this.imagename = imagename;
    this.imageurl = imageurl;
    this.price = price;
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      map['imagename'],
      map['imageurl'],
      map['Price'] ?? 'No Price',
    );
  }
}

class ProductShow extends StatefulWidget {
  const ProductShow({Key? key}) : super(key: key);

  @override
  State<ProductShow> createState() => _ProductShowState();
}

class _ProductShowState extends State<ProductShow> {
  late List<dynamic> listt;
  var catalogdata;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    var data = await rootBundle.loadString("assets/dhairya.json");
    setState(() {
      catalogdata = jsonDecode(data);
      print(data);
      listt = catalogdata;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (catalogdata == null) {
      // Return a loading indicator or another widget while data is loading.
      return CircularProgressIndicator();
    }

    List<ProductModel> list =
        listt.map((e) => ProductModel.fromMap(e)).toList();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        crossAxisCount: 2,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        ProductModel productModel = list[index];
        return Container(
          height: 80,
          width: 80,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(productModel),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.black, width: 1.0),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: productModel.imageurl!,
                      height: 80,
                      width: 80,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      productModel.imagename!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  ProductModel? model;
  ProductDetailsPage(ProductModel model) {
    this.model = model;
  }

  Future<void> payment() async {
    // print("price${price}");
    int? p = (model!.price)! * 100;
    var options = {
      'key': 'rzp_test_q8aqi03ndE5uPF',
      'amount': p,
      'name': '${model!.imagename}',
      'prefill': {'contact': '8799302070', 'email': 'dhairyagohil8@gmail.com'}
    };
    Razorpay razorpay = new Razorpay();
    razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              height: 300,
              width: 300,
              imageUrl: model!.imageurl.toString(),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Price: ${model!.price ?? 'No Price'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await payment();
              },
              child: Text("${model!.price}"),
              clipBehavior: Clip.antiAlias,
            )
          ],
        ),
      ),
    );
  }
}
