import 'dart:io';
import 'dart:developer';

import 'package:url_expander/url_expander.dart';

void main(List<String> arguments) async {
  final urlExpander = UrlExpander();

  try {
    stdout.write('Enter short url:');
    final url = stdin.readLineSync();
    if (url == null || url.isEmpty) {
      throw 'Please enter a URL';
    }

    stdout.write('Enter base URL for expanded URL:');
    final baseUrl = stdin.readLineSync();
    if (baseUrl == null || baseUrl.isEmpty) {
      throw ('Please enter a valid base URL');
    }

    final fullUrl = await urlExpander.getFullUrl(
      url,
      expandedBaseUrl: baseUrl,
    );

    stdout.write("\x1B[33m========\nFULL URL\n=========$fullUrl\n==========\x1B[0m");
    stdout.close();
  } on SocketException catch (e, t) {
    log('$e', stackTrace: t, error: e);
  }
}
