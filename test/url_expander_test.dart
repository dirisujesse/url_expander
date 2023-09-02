import 'package:test/test.dart';
import 'package:url_expander/url_expander.dart';

const isString = TypeMatcher<String>();

void main() {
  const String littlyBaseUrl = "https://littlely.eduworks.com.au";
  const String littlyShortUrl = "https://shorturl.at/lS678";
  const String littlyLongUrl =
      "https://littlely.eduworks.com.au/parent-community-hub/links-to-community-services/";
  const String tauBaseUrl = "https://www.moj-posao.net";
  const String tauShortUrl = "https://shorturl.at/qtCFW";
  const String tauLongUrl = "https://www.moj-posao.net/Poslodavci/";

  late UrlExpander service;

  setUp(() async {
    service = UrlExpander();
  });

  test("SHOULD RETURN STRING OBJECT", () async {
    final fullUrl = await service.getFullUrl(
      tauShortUrl,
      expandedBaseUrl: tauBaseUrl,
    );

    expect(fullUrl, isString);
  });

  test("SHOULD THROW ERROR FOR INVALID URL INPUT", () async {
    getFullUrl() async {
      await service.getFullUrl(
        "xdiwow",
        expandedBaseUrl: tauBaseUrl,
      );
    }

    expect(getFullUrl(), throwsException);
  });

  test(
      "SHOULD THROW ERROR FOR MISMATCH OF EXPECTED `expandedBaseUrl` AND RETURNED FULL URL BASE URL",
      () async {
    getFullUrl() async {
      await service.getFullUrl(
        tauShortUrl,
        expandedBaseUrl: littlyBaseUrl,
      );
    }

    expect(getFullUrl(), throwsException);
  });

  group("LITTLY URL TESTS", () {
    test("SHOULD RETURN $littlyLongUrl FROM $littlyShortUrl INPUT", () async {
      final fullUrl = await service.getFullUrl(
        littlyShortUrl,
        expandedBaseUrl: littlyBaseUrl,
      );

      expect(fullUrl, equals(littlyLongUrl));
    });
    test("SHOULD RETURN $littlyLongUrl FROM $littlyLongUrl INPUT", () async {
      final fullUrl = await service.getFullUrl(
        littlyLongUrl,
        expandedBaseUrl: littlyBaseUrl,
      );

      expect(fullUrl, equals(littlyLongUrl));
    });
  });

  group("TAU URL TESTS", () {
    test("SHOULD RETURN $tauLongUrl FROM $tauShortUrl INPUT", () async {
      final fullUrl = await service.getFullUrl(
        tauShortUrl,
        expandedBaseUrl: tauBaseUrl,
      );

      expect(fullUrl, equals(tauLongUrl));
    });
    test("SHOULD RETURN $tauLongUrl FROM $tauLongUrl INPUT", () async {
      final fullUrl = await service.getFullUrl(
        tauLongUrl,
        expandedBaseUrl: tauBaseUrl,
      );

      expect(fullUrl, equals(tauLongUrl));
    });
  });
}
