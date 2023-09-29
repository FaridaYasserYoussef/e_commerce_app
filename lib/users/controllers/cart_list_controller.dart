import 'package:clothes_app/users/model/cart.dart';
import 'package:get/get.dart';

class CartListController extends GetxController{

  RxList<Cart> _cartList = <Cart>[].obs;
  RxList<int> _selectedItemsList = <int>[].obs;
  RxBool _isSelectedAll = false.obs;
  RxDouble _total = 0.0.obs;

  List<Cart> get cartList => _cartList.value;
  List<int> get selectedItemsList => _selectedItemsList.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;

  setList(List<Cart> list){
    _cartList.value = list;
  }

  setCartItemQuantity(int cartid, int newQuantity){

    for(Cart cartItem in _cartList){
      if(cartItem.cart_id == cartid){
        cartItem.quantity = newQuantity;
        update();
        break;
      }
    }


  }

  addSelectedItem(int itemSelectedId){
    _selectedItemsList.value.add(itemSelectedId);
    update();
  }

  deleteSelectedItem(int itemSelectedId){
    _selectedItemsList.value.remove(itemSelectedId);
    update();
  }

  deleteSelectedItemsFromCart(){
    var cart;

    print("cart list initial ");
    print(_cartList);

    print("selected items list initial ");
    print(_selectedItemsList);

    if(_cartList.length == _selectedItemsList.length){
      _cartList.clear();
      _selectedItemsList.clear();
      setIsSelectedAll();
      update();
    }else{


      for(int x = 0; x < _selectedItemsList.length ; x++ ){
        _cartList.removeWhere((element) => element.cart_id == _selectedItemsList.elementAt(x));
      }

      _selectedItemsList.clear();

      if(_isSelectedAll.value == true){
        _isSelectedAll.value = false;
      }

      update();


    }


  }

  setIsSelectedAll(){
    _isSelectedAll.value = !_isSelectedAll.value;
  }
  clearAllSelectedItems(){
    _selectedItemsList.value.clear();
    update();
  }

  selectAllItems(){
    for(Cart cartItem in _cartList){
      if(!_selectedItemsList.contains(cartItem.cart_id)){
        addSelectedItem(cartItem.cart_id!);
      }
    }
  }



  setTotal(double total){
    _total.value = total;
  }

}