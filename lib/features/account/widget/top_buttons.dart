import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widget/account_button.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatelessWidget {
  TopButtons({super.key});

  final AccountServices accountServices = AccountServices();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: 'Your Order', onTap: () {}),
            AccountButton(text: 'Turn Seller', onTap: () {})
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            AccountButton(
              text: 'Log out',
              onTap: () => accountServices.logOut(context),
            ),
            AccountButton(text: 'Your Wish List', onTap: () {})
          ],
        )
      ],
    );
  }
}
