import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../service/database.dart';
import '../service/shared_perference.dart';
import '../widgets/widget_support.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? id, wallet;
  int total = 0, amount2 = 0;
  bool isSelecting = false; // Track if user is in selection mode
  Set<String> selectedItems = {}; // Set to hold selected cart item IDs

  void startTimer() {
    Timer(Duration(seconds: 2), () {
      amount2 = total;
      setState(() {});
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getFoodCart(id!);
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    startTimer();
    super.initState();
  }

  Stream? foodStream;

  Future<void> deleteCartItem(String cartItemId) async {
    try {
      await DatabaseMethods().deleteCartItem(id!, cartItemId);
      // Optionally, you can update the state or show a message upon successful deletion
      setState(() {
        // Perform any state update after deletion if needed
      });
    } catch (e) {
      print("Error deleting cart item: $e");
      // Handle errors or show error message to the user
    }
  }

  Future<void> deleteSelectedItems() async {
    try {
      for (String itemId in selectedItems) {
        await DatabaseMethods().deleteCartItem(id!, itemId);
      }
      setState(() {
        isSelecting = false;
        selectedItems.clear();
      });
    } catch (e) {
      print("Error deleting items: $e");
      // Handle errors or show error message to the user
    }
  }

  Widget buildFoodCartItem(DocumentSnapshot ds) {
    String cartItemId = ds.id;

    return GestureDetector(
      onTap: () {
        if (isSelecting) {
          toggleItemSelection(cartItemId);
        } else {
          // Handle tap action when not in selection mode (e.g., navigate to detail screen)
        }
      },
      onLongPress: () {
        if (!isSelecting) {
          toggleSelection();
          toggleItemSelection(cartItemId);
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: Material(
          elevation: 5.0, // Always show elevation
          shadowColor: isSelecting ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            child: isSelecting ?
            Row(
              children: [
                Row(
                  children: [
                    if (isSelecting)
                      IconButton(
                        onPressed: () {
                          toggleItemSelection(cartItemId);
                        },
                        icon: Icon(
                          selectedItems.contains(cartItemId)
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: selectedItems.contains(cartItemId)
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    SizedBox(width: 10.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        ds["Image"],
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20.0),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          ds["Name"],
                          style: AppWidget.semiBoldTextFieldStyle(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "\$" + ds["Total"],
                        style: AppWidget.semiBoldTextFieldStyle(),
                      ),
                    ],
                  ),
                ),
                if (isSelecting && selectedItems.contains(cartItemId))
                  IconButton(
                    onPressed: () {
                      deleteCartItem(cartItemId);
                    },
                    icon: Icon(Icons.delete),
                  ),
              ],
            ):Container(
             // margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        height: 90,
                        width: 40,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(child: Text(ds["Quantity"])),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            ds["Image"],
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          )),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                ds["Name"],
                                style: AppWidget.semiBoldTextFieldStyle(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "\$"+ ds["Total"],
                              style: AppWidget.semiBoldTextFieldStyle(),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ),
        ),
      ),
    );
  }



  void toggleSelection() {
    setState(() {
      isSelecting = !isSelecting;
      if (!isSelecting) {
        selectedItems.clear(); // Clear selected items when exiting selection mode
      }
    });
  }

  void toggleItemSelection(String itemId) {
    setState(() {
      if (selectedItems.contains(itemId)) {
        selectedItems.remove(itemId);
      } else {
        selectedItems.add(itemId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              color: isSelecting ? Colors.green.withOpacity(0.1) : Colors.transparent,
              padding: EdgeInsets.only(bottom: 10.0),
              child: isSelecting
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      toggleSelection();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text(
                    '${selectedItems.length} Selected',
                    style: AppWidget.headLineTextFieldStyle(),
                  ),
                  IconButton(
                    onPressed: () {
                      deleteSelectedItems();
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              )
                  : Material(
                  elevation: 2.0,
                  child: Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Center(
                          child: Text(
                            "Food Cart",
                            style: AppWidget.headLineTextFieldStyle(),
                          )))),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder(
                stream: foodStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    total = 0; // Reset total before recalculating
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        total = total + int.parse(ds["Total"]);
                        return buildFoodCartItem(ds);
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
           // Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                  Text(
                    "\$"+ total.toString(),
                    style: AppWidget.semiBoldTextFieldStyle(),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () async {
                if (int.parse(wallet!) == 0) {
                  // Wallet balance is zero, show message
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Cannot Checkout"),
                      content: Text("Your wallet balance is zero. Please add money to checkout."),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  // Wallet balance is greater than zero, proceed with checkout
                  int amount = int.parse(wallet!) - amount2;
                  await DatabaseMethods().updateUserWallet(id!, amount.toString());
                  await SharedPreferenceHelper().saveUserWallet(amount.toString());

                  // Show success message
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Checkout Successful"),
                      content: Text("You have successfully checked out.\nRemaining Amount: \$${amount.toString()}\nChecked Out Amount: \$${amount2.toString()}"),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                ),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                  child: Text(
                    "CheckOut",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}