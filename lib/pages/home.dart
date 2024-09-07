import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fooddeliveryapp/pages/details.dart';
import 'package:fooddeliveryapp/pages/order.dart';
import 'package:fooddeliveryapp/service/database.dart';
import 'package:fooddeliveryapp/widgets/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool iceCream = false, pizza = false, salad = false, burger = false;
  Stream? foodItemStream;

  onTheLoad() async{
    foodItemStream = await DatabaseMethods().getFoodItem('Ice-cream');
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    onTheLoad();
    super.initState();
  }

  Widget allItems() {
    return StreamBuilder(
        stream: foodItemStream,
        builder: (context,AsyncSnapshot snapshot){
          return snapshot.hasData
              ? ListView.builder(
            padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                return   InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        Details(
                          detail: documentSnapshot['Detail'],
                          image: documentSnapshot['Image'],
                          name: documentSnapshot['Name'],
                          price: documentSnapshot['Price'],
                        )
                    ));
                  },
                  child: Container(
                    margin:EdgeInsets.all(2),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          //crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  documentSnapshot['Image'],
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  documentSnapshot['Name'],
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  'Fresh and Healthy',
                                  style: AppWidget.lightTextFieldStyle(),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  '\$'+documentSnapshot['Price'],
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );

              }
          ):Center(child: CircularProgressIndicator());
        }
    );
  }
  Widget allItemsVertically() {
    return Expanded(
      child: StreamBuilder(
          stream: foodItemStream,
          builder: (context,AsyncSnapshot snapshot){
            return snapshot.hasData
                ? ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context,index){
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  return  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(
                        detail: documentSnapshot['Detail'],
                        image: documentSnapshot['Image'],
                        name: documentSnapshot['Name'],
                        price: documentSnapshot['Price'],
                      )
                      )
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20,right: 2),
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      documentSnapshot['Image'],
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(height: 5,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/2,
                                        child: Text(
                                          documentSnapshot['Name'],
                                          style: AppWidget.semiBoldTextFieldStyle(),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/2,
                                        child: Text(
                                          'Honey goot cheese',
                                          style: AppWidget.lightTextFieldStyle(),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/2,
                                        child: Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          '\$'+documentSnapshot['Price'],
                                          style: AppWidget.semiBoldTextFieldStyle(),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                }
            ):Center(child: CircularProgressIndicator());
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50,left: 20,right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello Arbab,',
                  style: AppWidget.boldTextFieldStyle(),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderScreen()
                    )
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Delicious Food',
              style: AppWidget.headLineTextFieldStyle(),
            ),
            Text(
              'Discover and Get Great Food',
              style: AppWidget.lightTextFieldStyle(),
            ),
            SizedBox(
              height: 20,
            ),
           showItem(),
            SizedBox(
              height: 30,
            ),
           SizedBox(
               height: 270,
               child: allItems()),
            SizedBox(height: 30,),
            allItemsVertically(),
          ],
        ),
      ),
    );
  }
  Widget showItem(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async{
            iceCream=true;
            pizza=false;
            salad=false;
            burger=false;

            foodItemStream= await DatabaseMethods().getFoodItem('Ice-cream');

            setState(() {

            });
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: iceCream?Colors.black:Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                'lib/images/ice-cream.png',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: iceCream?Colors.white:Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            iceCream=false;
            pizza=true;
            salad=false;
            burger=false;
            foodItemStream= await DatabaseMethods().getFoodItem('Pizza');

            setState(() {

            });
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: pizza?Colors.black:Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                'lib/images/pizza.png',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: pizza?Colors.white:Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            iceCream=false;
            pizza=false;
            salad=true;
            burger=false;
            foodItemStream= await DatabaseMethods().getFoodItem('Salad');

            setState(() {

            });
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: salad?Colors.black:Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                'lib/images/salad.png',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: salad?Colors.white:Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            iceCream=false;
            pizza=false;
            salad=false;
            burger=true;
            foodItemStream= await DatabaseMethods().getFoodItem('Burger');

            setState(() {

            });
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: burger?Colors.black:Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                'lib/images/burger.png',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: burger?Colors.white:Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
