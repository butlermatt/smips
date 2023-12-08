import 'token.dart';

export 'token.dart' show Token, TokenType;

class Lexer {
  static final List<int> _reserved = '019AF#\$%."'.codeUnits;
  static final List<int> _whiteSpace = '\n\r\t '.codeUnits;
  static int get digit0 => _reserved[0];
  static int get digit1 => _reserved[1];
  static int get digit9 => _reserved[2];
  static int get alphaA => _reserved[3];
  static int get alphaF => _reserved[4];
  static int get charHash => _reserved[5];
  static int get charDollar => _reserved[6];
  static int get charPerc => _reserved[7];
  static int get charDot => _reserved[8];
  static int get charQuote => _reserved[9];
  static int get charNewLine => _whiteSpace[0];

  late final List<int> input;
  int start = 0;
  int current = 0;
  int line = 1;
  int linePos = 1;
  int startPos = 1;

  static final RegExp hexNum = RegExp(r'(\d|[A-F])');
  static final RegExp digitNum = RegExp(r'(\d)');

  Lexer(String input) {
    this.input = input.codeUnits;
  }

  Token scanToken() {
    _consumeWhitespace();
    start = current;
    startPos = linePos;

    if (_isAtEnd()) {
      return _makeToken(TokenType.eof);
    }

    var c = _advance();
    if (_isDigit(c)) {
      return _number();
    }

    var cs = String.fromCharCode(c);
    switch (cs) {
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
    if (current >= input.length) return 0;
    return input[current];
  }

  void _consumeWhitespace() {
    while (true) {
      var c = String.fromCharCode(_peek());
      switch (c) {
        case '\n':
          linePos = 1;
          line++;
          _advance();
          break;
        case ' ':
        case '\r':
        case '\t':
          _advance();
          break;
        case '#':
          while (_peek() != charNewLine && !_isAtEnd()) {
            _advance();
          }
          break;
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

  static bool _isBinDigit(int c) {
    return c == digit0 || c == digit1;
  }

  static bool _isDigit(int c) {
    return c >= digit0 && c <= digit9;
  }

  Token _makeToken(TokenType type) =>
      Token(type, String.fromCharCodes(input, start, current), line, startPos);
  //Token(type, input[line].substring(start, current), line + 1, start + 1);

  Token _errorToken(String message) =>
      Token(TokenType.error, message, line + 1, start + 1);

  Token _hashString() {
    int c = _peek();
    while (c != charQuote && c != charNewLine && !_isAtEnd()) {
      _advance();
      c = _peek();
    }

    if (c == charNewLine || _isAtEnd()) {
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

  Token _number() {
    var c = _peek();
    while (_isDigit(c) && !_isAtEnd()) {
      _advance();
      c = _peek();
    }

    if (c == charDot) {
      _advance();
      c = _peek();
      while (_isDigit(c) && !_isAtEnd()) {
        _advance();
        c = _peek();
      }
    }

    return _makeToken(TokenType.number);
  }
}
