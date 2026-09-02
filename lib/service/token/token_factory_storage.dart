import 'package:flutter/foundation.dart';
import 'package:truenorthflutterfrontend/service/token/mobile_token_storage.dart';
import 'package:truenorthflutterfrontend/service/token/token_storage.dart';
import 'package:truenorthflutterfrontend/service/token/web_token_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TokenFactoryStorage {
  static TokenStorage? _instance;

  static TokenStorage get instance {
    _instance ??= kIsWeb ? WebTokenStorage.instance : MobileTokenStorage();
    return _instance!;
  }
}
