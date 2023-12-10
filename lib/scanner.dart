import "package:smips/chunk.dart";

class Scanner {
  static final _digits = '09AF'.codeUnits;
  static final _chars = 'dr'.codeUnits;
  static get digit0 => _digits[0];
  static get digit9 => _digits[1];
  static get digitA => _digits[2];
  static get digitF => _digits[3];
  static get charD => _chars[0];
  static get charR => _chars[1];

  late final List<String> lines;
  final Map<String, int> _defines = <String, int>{};
  int curLine = 0;
  Chunk chunk = Chunk();

  Scanner(String input) {
    lines = input.split('\n');
  }

  void scanInstruction() {
    if (curLine >= lines.length) return;

    String line = lines[curLine++];
    int comment = line.indexOf('#');
    if (comment >= 0) {
      line = line.substring(0, comment).trim();
    }

    if (line.isEmpty) {
      chunk.writeCode(OpCode.opNop, curLine - 1);
    }

    var words = line.split(' ');
    var keyword = words[0].trim();

    switch (keyword) {
      case 'define':
        chunk.writeCode(OpCode.opNop, curLine - 1);
        _parseDefine(words.sublist(1));
        break;
      case 'move':
        chunk.writeCode(OpCode.opMove, curLine - 1);
        _parseRegister(words[1].trim());
        _parseValue(words[2].trim());
      case 'add':
        chunk.writeCode(OpCode.opAdd, curLine - 1);
        _parseRegValueValue(words.sublist(1));
        break;
      case 'sgt':
        chunk.writeCode(OpCode.opStoreGt, curLine - 1);
        _parseRegValueValue(words.sublist(1));
        break;
    }
  }

  void _parseDefine(List<String> args) {
    if (args.length < 2) {
      throw ArgumentError('Expected 2 arguments but got ${args.length}');
    }

    var name = args[0].trim();
    var number = _parseNumber(args[1].trim());
    var ind = chunk.addConstant(number);
    _defines[name] = ind;
  }

  void _parseRegValueValue(List<String> args) {
    if (args.length < 3) {
      throw ArgumentError('Expected 3 arguments, but got ${args.length}');
    }

    _parseRegister(args[0].trim());
    _parseValue(args[1].trim());
    _parseValue(args[2].trim());
  }

  void _parseRegister(String register) {
    var regCU = register.codeUnits;
    if (regCU[0] != charR) {
      //  TODO: Check against aliases before failing
      throw ArgumentError(
          'Expected destination register to start with "r" but it was $register');
    }

    var i = 1;
    while (i < regCU.length && regCU[i] == charR) {
      chunk.writeCode(OpCode.opRegister, curLine - 1);
      i++;
    }

    var value = int.parse(String.fromCharCodes(regCU, i));
    if (value < 0 || value > 17) {
      throw ArgumentError(
          'Register value should be between 0 and 17. Got: $value');
    }
    chunk.writeCode(OpCode.opConstant, curLine - 1);
    chunk.write(value);
  }

  void _parseValue(String value) {
    // TODO: Check for aliases and defines

    if (value.startsWith('r')) {
      chunk.writeCode(OpCode.opRegister, curLine - 1);
      return _parseRegister(value);
    }

    num? number;
    try  {
      number = _parseNumber(value);
    } on FormatException {
      var ind = _defines[value];
      if (ind == null) {
        throw ArgumentError('Invalid value $value');
      }

      chunk..writeCode(OpCode.opConstant, curLine - 1)
        ..write(ind);
        return;
    }

    var pos = chunk.addConstant(number!);
    chunk..writeCode(OpCode.opConstant, curLine - 1)
      ..write(pos);
  }

  num _parseNumber(String value) {
    num number;
    if (value.startsWith('%')) {
      number = int.parse(value.substring(1), radix: 2);
    } else if (value.startsWith(r'$')) {
      number = int.parse(value.substring(1), radix: 16);
    } else {
      number = num.parse(value);
    }

    return number;
  }
}
