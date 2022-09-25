import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/widgets/build_rating.dart';
import '../../../../core/util/widgets/image_container.dart';
import '../providers/account.dart';

class AccountScreen extends StatelessWidget {
  static const routName = '/account-screen';

  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Account>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ImageContainer(
            image: profile.image,
            radius: 100,
            imageSource: From.asset,
            imageTitle: profile.name,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200, width: 2.0),
            showHighlight: true,
            showImageScreen: true,
          ),
          const SizedBox(height: 20),
          BuildRating(profile.rating),
          const SizedBox(height: 20),
          Text(
            profile.email,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            profile.phoneNumber,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
