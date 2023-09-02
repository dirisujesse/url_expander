import 'dart:developer';
import 'dart:io';

class UrlExpander {
  final HttpClient _client = HttpClient();

  Future<String> getFullUrl(
    String url, {
    required String expandedBaseUrl,
  }) async {
    try {
      if (!_isValidUrl(url)) throw "Invalid URL";
      if (_isValidFullUrl(url, expandedBaseUrl)) return url;

      final uri = Uri.parse(url);

      final request = await _client.headUrl(uri);
      request.followRedirects = false;

      var response = await request.close();

      stdout.write("\x1B[32m========\nHEADERS\n=========${response.headers}\n==========\x1B[0m");

      final location = response.headers.value(HttpHeaders.locationHeader);

      if ((location ?? '').isEmpty) throw "URL not found";

      final isValidUrl = _isValidFullUrl(
        location,
        expandedBaseUrl,
      );

      if (!isValidUrl && response.isRedirect) {
        return await getFullUrl(
          location!,
          expandedBaseUrl: expandedBaseUrl,
        );
      }

      if (!isValidUrl) throw 'Cannot fetch expanded URL';

      return location!;
    } catch (e, t) {
      log('$e', error: e, stackTrace: t);
      throw Exception(e);
    }
  }

  bool _isValidUrl(String? url) {
    if (url != null && Uri.tryParse(url) != null) {
      final RegExp urlRegex = RegExp(
        r"\b[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)\b",
        caseSensitive: false,
      );

      return urlRegex.hasMatch(url);
    }

    return false;
  }

  bool _isValidFullUrl(String? url, String baseUrl) {
    if (url == null) return false;
    return url.startsWith(baseUrl);
  }
}
