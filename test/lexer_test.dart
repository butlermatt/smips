import 'dart:math';

import 'package:smips/src/lexer.dart';
import 'package:test/test.dart';

void main() {
  group('Lexer Tests', () {
    test('Number Values', () {
      var input = r'$A 10.1 %1010';

      var l = Lexer(input);
      var token = l.scanToken();

      expect(token.type, equals(TokenType.number));
      expect(token.literal, equals(r'$A'));
      expect(token.line, equals(1));
      expect(token.position, equals(1));
      token = l.scanToken();

      expect(token.type, equals(TokenType.number));
      expect(token.literal, equals(r'10.1'));
      expect(token.line, equals(1));
      expect(token.position, equals(4));

      token = l.scanToken();
      expect(token.type, equals(TokenType.number));
      expect(token.literal, equals(r'%1010'));
      expect(token.line, equals(1));
      expect(token.position, equals(9));
    });
  });
}