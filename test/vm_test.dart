import 'package:test/test.dart';

import 'package:smips/chunk.dart';
import 'package:smips/scanner.dart';
import 'package:smips/vm.dart';

void main() {
  group('OpCode Tests', () {
    test('Abs', () {
      /*
      * abs r0 2
      * abs r1 -3
      */

      Chunk c = Chunk();
      int pos = c.addConstant(2);
      c
        ..writeCode(OpCode.opAbs, 0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(pos);
      pos = c.addConstant(-3);
      c
        ..writeCode(OpCode.opAbs, 1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(pos);

      var vm = Vm();
      vm.interpret(c);

      expect(vm.registers[0], equals(2));
      expect(vm.registers[1], equals(3));
    });
    test('Move', () {
      /*
       * move r0 1.2 # Constant
       * move r1 r0  # Register
       */
      Chunk c = Chunk();
      int pos = c.addConstant(1.2);
      c
        ..writeCode(OpCode.opMove, 0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(pos);
      c
        ..writeCode(OpCode.opMove, 1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(1)
        ..writeCode(OpCode.opRegister, 1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(0);

      var vm = Vm();
      vm.interpret(c);

      expect(vm.registers[0], equals(1.2));
      expect(vm.registers[1], equals(1.2));
      expect(vm.registers[2], equals(0));
    });
    test('Add operation', () {
      Chunk c = Chunk();
      /*
       * move r0 1
       * move r1 2
       * add r0 r0 r1
       */
      c
        ..writeCode(OpCode.opMove, 0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(1);
      c
        ..writeCode(OpCode.opMove, 1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(2);
      c
        ..writeCode(OpCode.opAdd, 2)
        ..writeCode(OpCode.opConstant, 2)
        ..write(0)
        ..writeCode(OpCode.opRegister, 2)
        ..writeCode(OpCode.opConstant, 2)
        ..write(0)
        ..writeCode(OpCode.opRegister, 2)
        ..writeCode(OpCode.opConstant, 2)
        ..write(1);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[1], equals(2));
      expect(vm.registers[0], equals(3));
    });

    test('Subtract Operation', () {
      /*
      * sub r0 2 1
      */

      var c = Chunk();
      c
        ..writeCode(OpCode.opSubtract, 0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(2);
      c
        ..writeCode(OpCode.opConstant, 0)
        ..write(1);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[0], equals(1));
    });
    test('Multiply Operation', () {
      /*
      * mul r0 8 4
      */

      var c = Chunk();
      c
        ..writeCode(OpCode.opMultiply, 0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(8);
      c
        ..writeCode(OpCode.opConstant, 0)
        ..write(4);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[0], equals(32));
    });
    test('Divide Operation', () {
      /*
      * div r0 8 4
      */

      var c = Chunk();
      c
        ..writeCode(OpCode.opDivide, 0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(8)
        ..writeCode(OpCode.opConstant, 0)
        ..write(4);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[0], equals(2));
    });

    test('Mod Operation', () {
      /*
      * mod r0 19 12
      * mod r1 19 -12
      */

      var c = Chunk();
      var pos1 = c.addConstant(19);
      c
        ..writeCode(OpCode.opMod, 0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(pos1);
      c
        ..writeCode(OpCode.opConstant, 0)
        ..write(12);
      var pos = c.addConstant(-12);
      c
        ..writeCode(OpCode.opMod, 1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(pos1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(pos);

      var vm = Vm();
      vm.interpret(c);

      expect(vm.registers[0], equals(7));
      expect(vm.registers[1], equals(-5));
    });
    test('Store Equals', () {
      /*
      * seq r0 8 4
      * seq r1 r0 0
      */

      var c = Chunk();
      c
        ..writeCode(OpCode.opStoreEq, 0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(8)
        ..writeCode(OpCode.opConstant, 0)
        ..write(4);
      c
        ..writeCode(OpCode.opStoreEq, 1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(1)
        ..writeCode(OpCode.opRegister, 1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(0)
        ..writeCode(OpCode.opConstant, 1)
        ..write(0);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[0], equals(0));
      expect(vm.registers[1], equals(1));
    });
    test('Store Not Equals', () {
      /*
      * sne r0 8 4
      * sne r1 r0 0
      */

      var c = Chunk();
      c
        ..writeCode(OpCode.opStoreNotEq, 0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(8)
        ..writeCode(OpCode.opConstant, 0)
        ..write(4);
      c
        ..writeCode(OpCode.opStoreNotEq, 1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(1)
        ..writeCode(OpCode.opRegister, 1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(0)
        ..writeCode(OpCode.opConstant, 1)
        ..write(0);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[0], equals(1));
      expect(vm.registers[1], equals(1));
    });
    test('Store Not Equals Zero', () {
      /*
      * snez r0 8
      * snez r1 r0
      */

      var c = Chunk();
      c
        ..writeCode(OpCode.opStoreNotEq, 0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(0)
        ..writeCode(OpCode.opConstant, 0)
        ..write(8)
        ..writeCode(OpCode.opConstant, 0)
        ..write(0);
      c
        ..writeCode(OpCode.opStoreNotEq, 1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(1)
        ..writeCode(OpCode.opRegister, 1)
        ..writeCode(OpCode.opConstant, 1)
        ..write(0)
        ..writeCode(OpCode.opConstant, 1)
        ..write(0);

      var vm = Vm();
      vm.interpret(c);
      expect(vm.registers[0], equals(1));
      expect(vm.registers[1], equals(1));
    });
  });

  group('Scanner-Based tests', () {
    test('Register redirection', () {});

    test('Define value', () {
      var input = 'define Test 1000\nmove r0 Test';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(1000));
    });

    test('Add Test', () {
      var input = r'add r0 1 2';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(3));
    });

    test('Set Alias Register', () {
      var input = r'alias test r15';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.aliases[0][0], equals(OpCode.opRegister.index));
      expect(vm.aliases[0][1], equals(OpCode.opConstant.index));
      expect(vm.aliases[0][2], equals(15));
    });

    test('Move', () {
      var input = r'move r15 500';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[15], equals(500));
    });

    test('Move to alias', () {
      var input = 'alias Test r15\nmove Test 500';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[15], equals(500));
    });

    test('Random Number', () {
      var input = 'rand r0';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], allOf(greaterThanOrEqualTo(0), lessThan(1)));
    });

    test('Not bitwise', () {
      var input = 'not r0 4';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(-5));
    });

    test('Truncate value', () {
      var input = 'trunc r0 34.238';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(34));
    });

    test('Store Greater Than', () {
      var input = 'move r0 5\nsgt r1 r0 10\nsgt r2 r0 1';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], 5);
      expect(vm.registers[1], 0);
      expect(vm.registers[2], 1);
    });

    test('Store Less Than', () {
      var input = 'move r0 5\nslt r1 r0 10\nslt r2 r0 1';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], 5);
      expect(vm.registers[1], 1);
      expect(vm.registers[2], 0);
    });

    test('And bitwise', () {
      var input = 'and r0 1 2\nand r1 1 3';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(0));
      expect(vm.registers[1], equals(1));
    });

    test('Absolute value', () {
      var input = 'abs r0 10\nabs r1 -10';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(10));
      expect(vm.registers[1], equals(10));
    });

    test('Ceiling value', () {
      var input = 'ceil r0 10.2\nceil r1 -10.2';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(11));
      expect(vm.registers[1], equals(-10));
    });

    test('Floor value', () {
      var input = 'floor r0 10.2\nfloor r1 -10.2';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(10));
      expect(vm.registers[1], equals(-11));
    });

    test('Max value', () {
      var input = 'max r0 1 2\nmax r1 -1 -2';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(2));
      expect(vm.registers[1], equals(-1));
    });

    test('Min value', () {
      var input = 'min r0 1 2\nmin r1 -1 -2';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(1));
      expect(vm.registers[1], equals(-2));
    });

    test('Nor bitwise', () {
      var input = 'nor r0 5 3';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(-8)); // FIXME: Check for unsigned results
    });

    test('Or bitwise', () {
      var input = 'or r0 1 2';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(3));
    });

    test('Xor value', () {
      var input = 'xor r0 5 3';
      var scanner = Scanner(input);

      scanner.compile();
      var vm = Vm();
      vm.interpret(scanner.chunk);

      expect(vm.registers[0], equals(6));
    });
  });
}
