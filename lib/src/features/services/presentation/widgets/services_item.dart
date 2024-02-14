import 'package:flutter/material.dart';

import '../../../../core/util/widgets/custom_card.dart';
import '../../../../core/util/widgets/image_container.dart';

import '../../../services_givers/presentation/pages/service_givers_screen.dart';

class ServicesItem extends StatelessWidget {
  const ServicesItem(this.id, this.name, this.image, {Key? key})
      : super(key: key);

  final String id;
  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      elevation: 5,
      onTap: () {
        Navigator.of(context).pushNamed(
          ServiceGiversScreen.routName,
          arguments: id,
        ); // arguments should be id
      },
      child: GridTile(
        header: ImageContainer(
          image: image,
          imageSource: From.network,
          radius: 60,
          shape: BoxShape.circle,
        ),
        footer: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            //  color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        child: const SizedBox(),
      ),
    );
  }
}
