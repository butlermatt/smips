import 'token.dart';

export 'token.dart' show Token, TokenType;

class Lexer {
  static final List<int> _reserved = '09AF#\$% \t\r\n'.codeUnits;
  static final List<int> _whiteSpace = '\n\r\t '.codeUnits;
  static int get digit0 => _reserved[0];
  static int get digit9 => _reserved[1];
  static int get alphaA => _reserved[2];
  static int get alphaF => _reserved[3];
  static int get charHash => _reserved[4];
  static int get charDollar => _reserved[5];
  static int get charPerc => _reserved[6];
  static int get charNewLine => _whiteSpace[0];

  late final List<int> input;
  int start = 0;
  int current = 0;
  int line = 1;
  int linePos = 1;

  static final RegExp hexNum = RegExp(r'(\d|[A-F])');
  static final RegExp digitNum = RegExp(r'(\d)');

  Lexer(String input)  {
    this.input = input.codeUnits;
  }

  Token scanToken() {
    _consumeWhitespace();
    start = current;

    if (_isAtEnd()) {
      return _makeToken(TokenType.eof);
    }

    var c = _advance();
    switch (c) {
      // case '(':
      //   return _makeToken(TokenType.leftParen);
      // case ')':
      //   return _makeToken(TokenType.rightParent);
      // case '"':
      //   return _hashString();
      case r'$':
        return _hexNumber();
      case r'%':
        return _binNumber(); 
    }

    return _errorToken('Unexpected character');
  }

  int _advance() {
    current++;
    linePos++;
    return input[current - 1];
  }

  int _peek() {
    return input[current];
  }

  void _consumeWhitespace() {
    while (true) {
      var c = _peek();
      switch (c) {
        case ' ':
        case '\r':
        case '\t':
          _advance();
          break;
        case '#':
          while (_peek() != '\n' && !_isAtEnd()) { _advance(); }
          break;
        case '\n':
          linePos = 0;
          line++;
          _advance();
        default:
          return;
      }
    }
  }

  bool _isAtEnd() {
    return current == input.length;
  }

  static bool _isHexDigit(int c) {
    return (c >= digit0 && c <= digit9) || (c >= alphaA && c <= alphaF);
  }

  static bool _isBinDigit(String c) {
    return c == '0' || c == '1';
  }

  static bool _isDigit(String c) {
    return int.tryParse(c) != null;
  }

  Token _makeToken(TokenType type) =>
      Token(type, String.fromCharCodes(input, start, current), line, linePos);
      //Token(type, input[line].substring(start, current), line + 1, start + 1);

  Token _errorToken(String message) =>
      Token(TokenType.error, message, line + 1, start + 1);

  Token _hashString() {
    int c = _peek();
    while (c != '"' && c != '\n' && !_isAtEnd()) {
      _advance();
      c = _peek();
    }

    if (c == '\n' || _isAtEnd()) {
      return _errorToken('Unterminated string');
    }

    _advance();
    return _makeToken(TokenType.hashString);
  }

  Token _hexNumber() {
    var c = _peek();
    while (_isHexDigit(c) && !_isAtEnd()) {
      _advance();
      c = _peek();
    }

    return _makeToken(TokenType.number);
  }

  Token _binNumber() {
    var c = _peek();
    while (_isBinDigit(c) && !_isAtEnd()) {
      _advance();
      c = _peek();
    }

    return _makeToken(TokenType.number);
  }
}
