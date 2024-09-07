import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addUserDetail(Map<String,dynamic> userInfoMap,String id) async{
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }
  
  updateUserWallet(String id,String amount) async{
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'Wallet':amount});
  }

  addFoodItem(Map<String, dynamic> addItem, String category) async{
    return await FirebaseFirestore.instance
        .collection(category)
        .add(addItem);
  }

  Future<Stream<QuerySnapshot>> getFoodItem(String name) async{
    return  FirebaseFirestore.instance
        .collection(name)
        .snapshots();
  }

  Future addFoodToCart(Map<String,dynamic> userInfoMap,String id) async{
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('cart')
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodCart(String id) async{
    return  FirebaseFirestore.instance
        .collection('users').doc(id).collection('cart')
        .snapshots();
  }
  Future<void> deleteCartItem(String userId, String cartItemId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(cartItemId)
        .delete();
  }
}