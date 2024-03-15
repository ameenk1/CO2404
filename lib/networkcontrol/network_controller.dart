import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
   _connectivity.onConnectivityChanged.listen(_updateConnectionStatus) ;
   print('Connection check onit' );


  }

  void _updateConnectionStatus(ConnectivityResult result) {
    print('CResult $result');
    if (result == ConnectivityResult.none) {
      Get.rawSnackbar(
        title: 'No Internet Connection',
        message: 'Please connect to the internet to continue.',
        duration: Duration(days: 1),
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}