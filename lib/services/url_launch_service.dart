import 'package:url_launcher/url_launcher.dart';

class UrlService {
  void call(String number) async {
    await canLaunch("tel:$number").then((value) => launch("tel:$number"));
  }

  void message(String number) async {
    await canLaunch("sms:$number").then((value) => launch("sms:$number"));
  }

  void mail(String email) async {
    await canLaunch("mailto:$email").then((value) => launch("mailto:$email"));
  }
}
