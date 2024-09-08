

import 'package:eMarket/core/models/user_models/user_authenticate_model.dart';
import 'package:eMarket/core/utilities/base_logic_viewmodel.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticationViewModel extends BaseLogicViewModel {
  TextEditingController phoneController = TextEditingController();
  TextEditingController code = TextEditingController();

  String validateNumber(String phone) {
    var regEx = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (!regEx.hasMatch(phone)) {
      return 'شماره موبایل خود را صحیح وارد کنید.';
    } else
      return null;
  }

  void sendOtp(BuildContext context) async {
    if (phoneController.text.trim().length <= 9) {
      showError('لطفا شماره موبایل خود را وارد کنید.');
      return;
    }

    setBusy(true);
    String phone = phoneController.text.trim();
    var sendOtpModel =
        DigitsRequestModel.set(mobileNo: phone, type: 'register');
    var result = await userService.sendOtp(sendOtpModel);
    if (result.isSuccess == false) {
      showError(result.message);
      print(result.message);
      setBusy(false);
      notifyListeners();
      return;
    }

    if (result.result.code == -1 &&
        result.result.message == 'Mobile Number already in use!') {
      sendOtpModel.type = 'login';
      result = await userService.sendOtp(sendOtpModel);
    }

    await firebaseMethod(context, phone, sendOtpModel.type);

    notifyListeners();
  }

  Future<void> firebaseMethod(
      BuildContext context, String phone, String type) async {
    auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

    await _auth.verifyPhoneNumber(
      phoneNumber: '+93' + phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (auth.AuthCredential credential) {},
      verificationFailed: (auth.FirebaseAuthException exception) {},
      codeSent: (String verificationId, [int forceResendingToken]) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("کد تایید را وارد کنید"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: code,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textInputAction: TextInputAction.done,
                      onSubmitted: (val) async {
                        await verifyLogin(
                            context, verificationId, _auth, phone, type);
                      },
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("تایید"),
                    textColor: Colors.white,
                    color: ThemeColors.Orange,
                    onPressed: () async {
                      await verifyLogin(
                          context, verificationId, _auth, phone, type);
                    },
                  )
                ],
              );
            });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future verifyLogin(BuildContext context, String verificationId,
      auth.FirebaseAuth _auth, String phone, String type) async {
    Navigator.pop(context);
    final _code = code.text.trim();
    auth.AuthCredential credential = auth.PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: _code);

    var authResult = await _auth.signInWithCredential(credential);

    var firebaseUser = authResult.user;

    if (firebaseUser != null) {
      var ftoken = await firebaseUser.getIdToken();
      var verifyOtpModel = DigitsRequestModel.set(
        mobileNo: phone,
        otp: _code,
        type: type,
        ftoken: ftoken,
      );
      var verifyResult = await userService.verifyOtp(verifyOtpModel);

      if (verifyResult.result.code == 1) {
        var oneClickModel = DigitsRequestModel.set(
          mobileNo: phone,
          otp: _code,
          ftoken: ftoken,
        );
        var loginResult = await userService.oneClick(oneClickModel);
        if (loginResult.result.success) {
          navigationService.pushNamedAndRemoveUntil('home');
          setBusy(false);
        }
      }
    } else {
      print("Error");
    }
  }
}
