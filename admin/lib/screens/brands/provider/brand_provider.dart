import 'dart:developer';

import '../../../models/api_response.dart';
import '../../../models/brand.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/sub_category.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';


class BrandProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addBrandFormKey = GlobalKey<FormState>();
  TextEditingController brandNameCtrl = TextEditingController();
  SubCategory? selectedSubCategory;
  Brand? brandForUpdate;




  BrandProvider(this._dataProvider);



  addBrands() async {
    try {
      Map<String, dynamic> brand = {'name': brandNameCtrl.text, 'subcategoryId': selectedSubCategory?.sId};
      final response = await service.addItem(endpointUrl: 'brands', itemData: brand);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllBrands();
          log('Brand added');
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to add Brand: ${apiResponse.message}');
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

  updateBrands() async {
    try {
      if (brandForUpdate != null) {
        Map<String, dynamic> brand = {'name': brandNameCtrl.text, 'subcategoryId': selectedSubCategory?.sId};
        final response = await service.updateItem(endpointUrl: 'brands', itemData: brand, itemId: brandForUpdate?.sId ?? '');
        if (response.isOk){
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true){
            clearFields();
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            _dataProvider.getAllBrands();
            log('Brand added');
          } else {
            SnackBarHelper.showErrorSnackBar('Failed to add Brand: ${apiResponse.message}');
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

  submitBrands() {
    if (brandForUpdate != null){
      updateBrands();
    } else {
      addBrands();
    }
  }

  deleteBrands(Brand brand) async {
    try{
      Response response = await service.deleteItem(endpointUrl: 'brands', itemId: brand.sId ?? '');
      if (response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true){
          SnackBarHelper.showSuccessSnackBar('Brand Deleted Sucessfully');
          _dataProvider.getAllBrands();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to Delete Brand');
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


  //? set data for update on editing
  setDataForUpdateBrand(Brand? brand) {
    if (brand != null) {
      brandForUpdate = brand;
      brandNameCtrl.text = brand.name ?? '';
      selectedSubCategory = _dataProvider.subCategories.firstWhereOrNull((element) => element.sId == brand.subcategoryId?.sId);
    } else {
      clearFields();
    }
  }

  //? to clear text field and images after adding or update brand
  clearFields() {
    brandNameCtrl.clear();
    selectedSubCategory = null;
    brandForUpdate = null;
  }

  updateUI(){
    notifyListeners();
  }

}
