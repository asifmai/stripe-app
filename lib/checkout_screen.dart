// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:stripe_checkout/stripe_checkout.dart';
import 'package:http/http.dart' as http;

import 'example_scaffold.dart';

class CheckoutScreenExample extends StatefulWidget {
  const CheckoutScreenExample({
    Key? key,
  }) : super(key: key);

  @override
  _CheckoutScreenExample createState() => _CheckoutScreenExample();
}

class _CheckoutScreenExample extends State<CheckoutScreenExample> {
  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Checkout Page',
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 120),
        Center(
          child: ElevatedButton(
            onPressed: getCheckout,
            child: const Text('Open Checkout'),
          ),
        )
      ],
    );
  }

  Future<void> getCheckout() async {
    final String sessionId = await _createCheckoutSession();
    final result = await redirectToCheckout(
      context: context,
      sessionId: sessionId,
      publishableKey:
          'pk_test_51I5n2FCyIShGH3ntxIqgSoR5G4q7lYVvNHPOdF8AlIYiQu013qslPQi3XyxETxsZ4Ip3Wf6N34q7I1KOZK15uuVW00A72kK48C',
      successUrl: 'https://checkout.stripe.dev/success',
      canceledUrl: 'https://checkout.stripe.dev/cancel',
    );

    if (mounted) {
      final text = result.when(
        success: () => 'Paid succesfully',
        canceled: () => 'Checkout canceled',
        error: (e) => 'Error $e',
        redirected: () => 'Redirected succesfully',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text)),
      );
    }
  }

  Future<String> _createCheckoutSession() async {
    final url = Uri.parse('http://histudio.co:3001/stripe/create-checkout-session');
    final response = await http.post(
      url,
    );
    final Map<String, dynamic> bodyResponse = json.decode(response.body);
    final id = bodyResponse['id'] as String;
    debugPrint('Checkout session id $id');
    return id;
  }
}
