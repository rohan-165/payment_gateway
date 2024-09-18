import 'dart:developer';

import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';

mixin PaymentMx {
  void eSewaPayment({
    required BuildContext context,
    required EsewaPayment esewaPayment,
  }) {
    log('product id: ${esewaPayment.productId}');
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
          secretId: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
        ),
        esewaPayment: esewaPayment,
        onPaymentSuccess: (EsewaPaymentSuccessResult data) {
          log('payment success: ${data.toJson()}');
          showToast(context: context, msg: 'Payment Successful');
        },
        onPaymentFailure: (data) {
          log('payment failure: ${data.toJson()}');
          showToast(
            context: context,
            msg: 'payment failure',
            color: Colors.red,
          );
        },
        onPaymentCancellation: (data) {
          log('payment cancel: ${data.toJson()}');
          showToast(
            context: context,
            msg: 'payment cancel',
            color: Colors.red,
          );
        },
      );
    } on Exception {
      showToast(
        context: context,
        msg: 'Error in payment process',
        color: Colors.red,
      );
    } catch (e) {
      log('Error in payment process: $e');
      showToast(
        context: context,
        msg: 'Error in payment process',
        color: Colors.red,
      );
    }
  }

  // void khaltiPaymentMethod({
  //   required BuildContext context,
  //   required PaymentGateways paymentGateway,
  //   required String pidx,
  //   required Function(
  //           PaymentGateways paymentGateway, PaymentResult paymentResult)
  //       onKhaltiSuccess,
  // }) async {
  //   try {
  //     final payConfig = khalti.KhaltiPayConfig(
  //         publicKey: EnvironmentConfig.isProd
  //             ? paymentGateway.appCredentials!.khaltiPublicKey!
  //             : paymentGateway.appCredentials!
  //                 .khaltiPublicKey!, // "live_public_key_979320ffda734d8e9f7758ac39ec775f",
  //         pidx: EnvironmentConfig.isProd
  //             ? pidx
  //             : pidx, // "ZyzCEMLFz2QYFYfERGh8LE",
  //         environment: EnvironmentConfig.isProd
  //             ? khalti.Environment.prod
  //             : khalti.Environment.test);

  //     khalti.Khalti khaltis = await khalti.Khalti.init(
  //       enableDebugging: true,
  //       payConfig: payConfig,
  //       onPaymentResult: (PaymentResult paymentResult, khalti) async {
  //         log(paymentResult.toString());
  //         var url = "https://khalti.com/api/payment/verify_service_use/";
  //         print(url);
  //         var body = {
  //           "token": paymentResult.payload?.transactionId,
  //           "amount": paymentResult.payload?.totalAmount.toString(),
  //           "service_slug": "government_payment"
  //         };
  //         http.Response? response = await http.post(Uri.parse(url),
  //             headers: {
  //               "Authorization":
  //                   "Key live_secret_key_177aa7de5d1e489592b619556c477bc5"
  //             },
  //             body: body);
  //         print("StatusCode ${response.statusCode}");
  //         if (response.statusCode == 200) {
  //           onKhaltiSuccess(paymentGateway, paymentResult);
  //         }
  //       },
  //       onMessage: (
  //         khalti, {
  //         description,
  //         statusCode,
  //         event,
  //         needsPaymentConfirmation,
  //       }) async {
  //         log(
  //           'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
  //         );
  //       },
  //       onReturn: () => log('Successfully redirected to return_url.'),
  //     );
  //     khaltis.open(context);
  //   } on Exception {
  //   } catch (e) {
  //     showErrorToast(msg: 'Error in payment process: $e');
  //   }
  // }
}

showToast({
  required BuildContext context,
  required String msg,
  Color? color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      padding: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      backgroundColor: color ?? Colors.green,
    ),
  );
}
