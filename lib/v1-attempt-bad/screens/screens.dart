import 'package:flutter/material.dart';
import 'package:navigation2/v1-attempt-bad/models/offer.dart';

import '../navigation/route_information_parser.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  const LoginScreen({Key? key, required this.onLogin}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  MaterialPage page() {
    return MaterialPage(
      name: Paths.login,
        key: const ValueKey(Paths.login),
        child: LoginScreen(onLogin: onLogin),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Login Button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: widget.onLogin, child: const Text("CLIENT")),
            ElevatedButton(
                onPressed: widget.onLogin, child: const Text("EMPLOYEE")),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                  context,
                  "register");
            },
            child: const Text("Register")),
        ElevatedButton(
            onPressed: () {}, child: const Text("Forgotten password")),
      ],
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Text("This is registration page!"),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Go back"))
      ],
    ));
  }
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("This is forgot password page!"));
  }
}

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("This is requests page!"));
  }
}

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("This is offers page!"));
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("This is history page!"));
  }
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("This is accounts page!"));
  }
}

class OrderDetails extends StatelessWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("This is orders page!"));
  }
}

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("This is requests page!"));
  }
}

class Error404Screen extends StatefulWidget {
  const Error404Screen({Key? key}) : super(key: key);

  @override
  State<Error404Screen> createState() => _Error404ScreenState();
}

class _Error404ScreenState extends State<Error404Screen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("ERROR 404"),
    );
  }
}


class OfferDetailsScreen extends StatefulWidget {
  OfferDetails data;
  OfferDetailsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.data.tag),
        Text(widget.data.date),
        
        for(var service in widget.data.servicesIncluded)
          Text(service),

        Text(widget.data.price.toString()),
      ],
    );
  }
}
