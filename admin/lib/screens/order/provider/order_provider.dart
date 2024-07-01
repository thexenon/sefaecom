import 'dart:developer';

import 'package:admin/models/api_response.dart';
import 'package:admin/utility/snack_bar_helper.dart';

import '../../../models/order.dart';
import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';


class OrderProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final orderFormKey = GlobalKey<FormState>();
  TextEditingController trackingUrlCtrl = TextEditingController();
  String selectedOrderStatus = 'pending';
  Order? orderForUpdate;

  OrderProvider(this._dataProvider);

  updateOrder() async {
     try{
      if (orderForUpdate != null){
        Map<String, dynamic> order = {'trackingUrl': trackingUrlCtrl.text, 'orderStatus': selectedOrderStatus};
        final response = await service.updateItem(endpointUrl: 'orders', itemData: order, itemId: orderForUpdate?.sId ?? '');
        if (response.isOk){
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true){
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            _dataProvider.getAllPoster();
            log('poster added');
          } else {
            SnackBarHelper.showErrorSnackBar('Failed to add Poster: ${apiResponse.message}');
          }
        } else {
          SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
        }
      }
      
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      rethrow;
    }
  }

  deleteOrder(Order order) async {
    try{
      final response = await service.deleteItem(endpointUrl: 'orders', itemId: order.sId ?? '');
      if (response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true){
          SnackBarHelper.showSuccessSnackBar('Order Deleted Sucessfully');
          _dataProvider.getAllOrders();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to Delete Order');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      rethrow;
    }
  }


  updateUI() {
    notifyListeners();
  }
}
