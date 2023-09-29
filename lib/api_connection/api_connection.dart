class API{
  // connection to api service
  static const hostConnect = "http://192.168.1.8/api_clothes_store";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";
  static const hostConnectItems = "$hostConnect/items";
  static const hostConnectClothes = "$hostConnect/clothes";
  static const hostConnectCart = "$hostConnect/cart";
  static const hostConnectOrder = "$hostConnect/order";

  static const hostImages = "$hostConnect/transactions_proof_images/";



  static const addItems = "$hostConnectItems/add_item.php";
  static const searchItem = "$hostConnectItems/search.php";
  static const addOrder = "$hostConnectOrder/add_order.php";
  static const getAllOrders = "$hostConnectOrder/get_orders.php";
  static const updateOrderStatus = "$hostConnectOrder/update_status.php";
  static const getOrdersHistory = "$hostConnectOrder/get_history.php";


  static const validateEmail = "$hostConnectUser/validate_email.php";
  static const getTrending = "$hostConnectClothes/trending.php";
  static const getAll = "$hostConnectClothes/all.php";
  static const addToCart = "$hostConnectCart/add_to_cart.php";
  static const getFromCart = "$hostConnectCart/get_cart_item.php";
  static const deleteFromCart = "$hostConnectCart/delete_from_cart.php";
  static const updateQuantity = "$hostConnectCart/update_quantity.php";
  static const addItemToFavorite = "$hostConnectItems/add_item_to_favorite.php";
  static const deleteItemFromFavorite = "$hostConnectItems/delete_item_from_favorite.php";
  static const getItemFromFavorite = "$hostConnectItems/get_item_from_favorites.php";
  static const getAllFavoriteItems = "$hostConnectItems/get_all_favorite_items.php";






  static const signup = "$hostConnectUser/signup.php";
  static const login = "$hostConnectUser/login.php";
  static const adminLogin = "$hostConnectAdmin/login.php";
  static const admingetAllOrders = "$hostConnectAdmin/get_orders.php";





}