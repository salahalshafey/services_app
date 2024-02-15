// general-purpose functions will be here

// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app.dart';

import '../../network/network_info.dart';

final _context = navigatorKey.currentContext!;

/// * if link doesn't point to a valid image will return String containing error info
/// * if valid will return a null

Future<String?> validateImageLink(String url) async {
  final urlMatcher = RegExp(
      r"(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})");

  if (!urlMatcher.hasMatch(url)) {
    return AppLocalizations.of(_context)!.linkIsNotvalid;
  }

  if (await MyNetworkInfoImpl().isNotConnected) {
    return AppLocalizations.of(_context)!.youAreCurrentlyOffline;
  }

  try {
    final response = await http.head(Uri.parse(url));
    final contentType = response.headers["content-type"];
    if (contentType == null || !contentType.startsWith("image/")) {
      return AppLocalizations.of(_context)!.linkDoesnotPointToImage;
    }

    return null;
  } catch (error) {
    return AppLocalizations.of(_context)!.linkIsNotvalid;
  }
}

num getRangeRandom({
  required double from,
  required double to,
  RandomType randomType = RandomType.double,
}) {
  final doubleRandom = Random().nextDouble() * (to - from) + from;

  if (randomType == RandomType.double) {
    return doubleRandom;
  }

  return doubleRandom.toInt();
}

enum RandomType {
  int,
  double,
}
