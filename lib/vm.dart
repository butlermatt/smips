import 'dart:math' as math;

import 'chunk.dart';
import 'src/value.dart';

enum InterpreterResult {
  ok, compileError, runtimeError
}

class Vm {
  Chunk? chunk;
  List<num> registers = List<num>.filled(18, 0);
  List<num> stack = List<num>.filled(512, 0);
  List<List<int>> aliases = [];
  int ip = 0;

  Vm();

  InterpreterResult interpret(Chunk chunk) {
    ip = 0;
    this.chunk = chunk;

    return run();
  }

  OpCode readOpcode() => OpCode.values[_readByte()];

  InterpreterResult run() {
    chunk?.take();

    while (true) {
      var inst = readOpcode();
      switch (inst) {
        // Used to help manage empty lines
        case OpCode.opYield:
        case OpCode.opNop: continue;
        case OpCode.opRand:
          var dest = readDestRegistry();
          registers[dest] = math.Random().nextDouble();
        // Single Operand commands
        case OpCode.opAbs:
        case OpCode.opCeil:
        case OpCode.opFloor:
        case OpCode.opMove:
        case OpCode.opNot:
        case OpCode.opTrunc:
          handleSingleOp(inst);
        // Dual Operand Commands
        case OpCode.opAdd:
        case OpCode.opAnd:
        case OpCode.opSubtract:
        case OpCode.opMultiply:
        case OpCode.opDivide:
        case OpCode.opMod:
        case OpCode.opMax:
        case OpCode.opMin:
        case OpCode.opNor:
        case OpCode.opOr:
        case OpCode.opStoreEq:
        case OpCode.opStoreNotEq:
        case OpCode.opStoreGt:
        case OpCode.opStoreLt:
        case OpCode.opXor:
          handleBinaryOp(inst);
          break;
        case OpCode.opSetAlias:
          setAlias();
          break;
        default:
          return InterpreterResult.compileError;
      }
      if (ip == chunk!.data!.length) {
        break;
      }
    }

    return InterpreterResult.ok;
  }

  int _readByte() => chunk!.data![ip++];

  Value _readConstant() {
    var val = _readByte();
    if (chunk!.values.length < val) {
      throw IndexError.withLength(val, chunk!.values.length);
    }
    return chunk!.values[val];
  }

  Value _readRegister() {
    Value val = _readByte();
    if (val is! int) {
      throw ArgumentError('Register must be integer, got: $val');
    }
    if (val == OpCode.opRegister.index) {
      return registers[_readRegister() as int];
    } else if (val == OpCode.opConstant.index) {
      return registers[_readConstant() as int];
    }

    // return registers[val]; 
    throw StateError('Should not reach');
  }

  int _readAlias() {
    int slot = _readByte();

    if (slot >= aliases.length) {
      throw StateError('Alias slot higher than number of aliases');
    }

    var bytes = aliases[slot];
    return chunk!.values[bytes[2]] as int;
  }

  int readDestRegistry() {
    var inst = readOpcode();
    return switch (inst) {
      OpCode.opConstant => _readConstant() as int,
      OpCode.opRegister => _readRegister() as int,
      OpCode.opGetAlias => _readAlias(),
      _ => throw StateError('Should not reach here'),
    };
  }

  Value readValue() {
    var inst = readOpcode();
    return switch (inst) {
      OpCode.opConstant => _readConstant(),
      OpCode.opRegister => _readRegister(),
      _ => throw StateError('Should not reach here'),
    };
  }

  void handleSingleOp(OpCode opCode) {
    var dest = readDestRegistry();
    var val = readValue();

    registers[dest] = switch(opCode) {
      OpCode.opAbs => val.abs(),
      OpCode.opCeil => val.ceil(),
      OpCode.opFloor => val.floor(),
      OpCode.opMove => val,
      OpCode.opNot => ~(val as int),
      OpCode.opTrunc => val.truncate(),
      _ => throw StateError('Should not reach here')
    };
  }

  void handleBinaryOp(OpCode opCode) {
    var dest = readDestRegistry();
    var val1 = readValue();
    var val2 = readValue();

    registers[dest] = switch(opCode) {
      OpCode.opAdd => val1 + val2,
      OpCode.opAnd => (val1 as int) & (val2 as int),
      OpCode.opSubtract => val1 - val2,
      OpCode.opMultiply => val1 * val2,
      OpCode.opDivide => val1 / val2,
      OpCode.opMax => math.max(val1, val2),
      OpCode.opMin => math.min(val1, val2),
      OpCode.opMod => (val1 - (val2 * (val1 / val2).floor())),
      OpCode.opNor => ~((val1 as int) | (val2 as int)),
      OpCode.opOr => (val1 as int) | (val2 as int),
      OpCode.opStoreEq => val1 == val2 ? 1 : 0,
      OpCode.opStoreNotEq => val1 != val2 ? 1 : 0,
      OpCode.opStoreGt => val1 > val2 ? 1 : 0,
      OpCode.opStoreLt => val1 < val2 ? 1 : 0,
      OpCode.opXor => (val1 as int) ^ (val2 as int),
      _ => throw StateError("Don't get here"),
    };
  }

  void setAlias() {
    var aliasSlot = _readByte();
    OpCode opCode = readOpcode();
    Value value = readValue();

    if (aliasSlot < aliases.length) {
      aliases[aliasSlot] = [opCode.index, OpCode.opConstant.index, value as int];
    }

    if (aliasSlot > aliases.length) {
      throw StateError('Alias slot does not match next slot value: Expected: ${aliases.length}, got $aliasSlot');
    }

    aliases.add([opCode.index, OpCode.opConstant.index, value as int]);
  }
}