// ignore_for_file: use_build_context_synchronously, constant_identifier_names

import 'dart:developer';

import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart' as khalti;

enum KhaltiPaymentStatus {
  Completed,
  Pending,
  Failed,
  Initiated,
  Refunded,
  Expired
}

KhaltiPaymentStatus? getKhaltiStatus({required String status}) {
  switch (status) {
    case "Completed":
      return KhaltiPaymentStatus.Completed;
    case "Pending":
      return KhaltiPaymentStatus.Pending;
    case "Failed":
      return KhaltiPaymentStatus.Failed;
    case "Initiated":
      return KhaltiPaymentStatus.Initiated;
    case "Refunded":
      return KhaltiPaymentStatus.Refunded;
    case "Expired":
      return KhaltiPaymentStatus.Expired;
    default:
      return null;
  }
}

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

  void khaltiPaymentMethod({
    required BuildContext context,
    String? pidx,
    required Function(khalti.PaymentResult paymentResult) onKhaltiSuccess,
  }) async {
    try {
      final payConfig = khalti.KhaltiPayConfig(
          publicKey: "live_public_key_979320ffda734d8e9f7758ac39ec775f",
          pidx: pidx ?? "ZyzCEMLFz2QYFYfERGh8LE",
          environment: khalti.Environment.test);

      khalti.Khalti khaltis = await khalti.Khalti.init(
        enableDebugging: true,
        payConfig: payConfig,
        onPaymentResult: (khalti.PaymentResult paymentResult, khalti) async {
          if (getKhaltiStatus(status: paymentResult.payload?.status ?? '') ==
              KhaltiPaymentStatus.Completed) {
            onKhaltiSuccess(paymentResult);
            showToast(context: context, msg: 'Payment Successful');
            khalti.close(context);
          } else if (getKhaltiStatus(
                  status: paymentResult.payload?.status ?? '') ==
              KhaltiPaymentStatus.Failed) {
            showToast(
              context: context,
              msg: 'payment failure',
              color: Colors.red,
            );
            khalti.close(context);
          } else {
            showToast(
              context: context,
              msg: 'payment cancel',
              color: Colors.red,
            );
            khalti.close(context);
          }
          khalti.close(context);
          log(paymentResult.payload.toString());
        },
        onMessage: (
          khalti, {
          description,
          statusCode,
          event,
          needsPaymentConfirmation,
        }) async {
          log(
            'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
          );
        },
        onReturn: () => log('Successfully redirected to return_url.'),
      );
      khaltis.open(context);
    } on Exception {
    } catch (e) {
      showToast(context: context, msg: 'Error in payment process: $e');
    }
  }
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
