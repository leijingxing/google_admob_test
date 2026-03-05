import 'package:closed_off_app/data/models/auth/login_token_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginTokenModel', () {
    test('fromJson 支持容错解析', () {
      final model = LoginTokenModel.fromJson({
        'access_token': 12345,
        'token_type': null,
        'expires_in': '3600',
        'refresh_token': '',
        'scope': 'all',
        'jti': null,
      });

      expect(model.accessToken, '12345');
      expect(model.tokenType, '');
      expect(model.expiresIn, 3600);
      expect(model.refreshToken, isNull);
      expect(model.scope, 'all');
      expect(model.jti, isNull);
    });

    test('toJson 输出协议字段', () {
      const model = LoginTokenModel(
        accessToken: 'a-token',
        tokenType: 'Bearer',
        expiresIn: 7200,
        refreshToken: 'r-token',
        scope: 'user',
        jti: 'id-1',
      );

      final json = model.toJson();

      expect(json['access_token'], 'a-token');
      expect(json['token_type'], 'Bearer');
      expect(json['expires_in'], 7200);
      expect(json['refresh_token'], 'r-token');
      expect(json['scope'], 'user');
      expect(json['jti'], 'id-1');
    });
  });
}

