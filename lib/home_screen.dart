import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stripe_checkout/stripe_checkout.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  getCheckout(context);
                },
          child: isLoading ? const CircularProgressIndicator() : const Text('Open Checkout'),
        ),
      ),
    );
  }

  Future<void> getCheckout(BuildContext ctx) async {
    setState(() => isLoading = true);
    final String sessionId = await _createCheckoutSession();
    if (mounted) {
      final result = await redirectToCheckout(
        context: ctx,
        sessionId: sessionId,
        publishableKey:
            'pk_test_51I5n2FCyIShGH3ntxIqgSoR5G4q7lYVvNHPOdF8AlIYiQu013qslPQi3XyxETxsZ4Ip3Wf6N34q7I1KOZK15uuVW00A72kK48C',
        successUrl: 'https://checkout.stripe.dev/success',
        canceledUrl: 'https://checkout.stripe.dev/cancel',
      );
      setState(() => isLoading = false);

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
