import 'dart:developer';
import 'dart:io';

class UrlExpander {
  final HttpClient _client = HttpClient();

  Future<String> getFullUrl(
    String url, {
    required String expandedBaseUrl,
  }) async {
    try {
      return await _extractFullUrl(url, expandedBaseUrl);
    } catch (e, t) {
      log('$e', error: e, stackTrace: t);
      throw Exception(e);
    }
  }

  _extractFullUrl(
    String url,
    String expandedBaseUrl, [
    int iterationsAllowed = 5,
  ]) async {
    try {
      if (!(iterationsAllowed >= 1)) throw "Max redirect limit reached";
      if (!_isValidUrl(url)) throw "Invalid URL";
      if (_isValidFullUrl(url, expandedBaseUrl)) return url;

      final uri = Uri.parse(url);

      final request = await _client.headUrl(uri);
      request.followRedirects = false;

      final response = await request.close();

      stdout.write(
          "\x1B[32m========\nHEADERS\n=========\n${response.headers}\n==========\x1B[0m\n");

      final fullUrl = response.headers.value(HttpHeaders.locationHeader);

      if ((fullUrl ?? '').isEmpty) throw "URL not found";

      final isValidUrl = _isValidFullUrl(
        fullUrl,
        expandedBaseUrl,
      );

      if (!isValidUrl && response.isRedirect) {
        return await _extractFullUrl(
          fullUrl!,
          expandedBaseUrl,
          --iterationsAllowed,
        );
      }

      if (!isValidUrl) throw 'Cannot fetch expanded URL';

      return fullUrl!;
    } catch (_) {
      rethrow;
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
