import 'package:smips/chunk.dart';
import 'package:smips/scanner.dart';
import 'package:test/test.dart';

void main() {
  group('Scanner Tests', () {
    test('Comment Line first', () {
      var input = '# This is a comment\nadd r0 0 1';

      var s = Scanner(input);
      s.scanInstruction();
      s.scanInstruction();

      s.chunk.take();
      expect(s.chunk.data!.length, equals(8));
      expect(s.chunk.data![0], equals(OpCode.opNop.index));
      expect(s.chunk.data![1], equals(OpCode.opAdd.index));
      expect(s.chunk.data![2], equals(OpCode.opConstant.index));
      expect(s.chunk.data![3], equals(0));
      expect(s.chunk.data![4], equals(OpCode.opConstant.index));
      expect(s.chunk.data![5], equals(0));
      expect(s.chunk.data![6], equals(OpCode.opConstant.index));
      expect(s.chunk.data![7], equals(1));
    });

    test('Hex Values', () {
      var input = r'add r0 $0 $F';

      var s = Scanner(input);
      s.scanInstruction();

      s.chunk.take();
      expect(s.chunk.data!.length, equals(7));
      expect(s.chunk.data![0], equals(OpCode.opAdd.index));
      expect(s.chunk.data![1], equals(OpCode.opConstant.index));
      expect(s.chunk.data![2], equals(0));
      expect(s.chunk.data![3], equals(OpCode.opConstant.index));
      expect(s.chunk.data![4], equals(0));
      expect(s.chunk.data![5], equals(OpCode.opConstant.index));
      expect(s.chunk.data![6], equals(15));
    });

    test('Binary Value', () {
      var input = r'add r0 %0 %1111';

      var s = Scanner(input);
      s.scanInstruction();

      s.chunk.take();
      expect(s.chunk.data!.length, equals(7));
      expect(s.chunk.data![0], equals(OpCode.opAdd.index));
      expect(s.chunk.data![1], equals(OpCode.opConstant.index));
      expect(s.chunk.data![2], equals(0));
      expect(s.chunk.data![3], equals(OpCode.opConstant.index));
      expect(s.chunk.data![4], equals(0));
      expect(s.chunk.data![5], equals(OpCode.opConstant.index));
      expect(s.chunk.data![6], equals(15));
    });

    test('Defines', () {
      var input ='define TEST 100\nmove r0 TEST';
      
      var s = Scanner(input);

      s.scanInstruction();
      s.scanInstruction();
      s.chunk.take();

      expect(s.chunk.data!.length, equals(6));
      expect(s.chunk.data![0], equals(OpCode.opNop.index));
      expect(s.chunk.data![1], equals(OpCode.opMove.index));
      expect(s.chunk.data![2], equals(OpCode.opConstant.index));
      expect(s.chunk.data![3], equals(0));
      expect(s.chunk.data![4], equals(OpCode.opConstant.index));
      expect(s.chunk.data![5], equals(18));
    });

    test('Set Alias', () {
      var input = 'alias test r1';

      var s = Scanner(input);
      s.scanInstruction();

      s.chunk.take();

      expect(s.chunk.aliases.length, equals(1));
      expect(s.chunk.aliases[0], equals('test'));
      expect(s.chunk.data![0], equals(OpCode.opSetAlias.index));
      expect(s.chunk.data![1], equals(0));
      expect(s.chunk.data![2], equals(OpCode.opRegister.index));
      expect(s.chunk.data![3], equals(OpCode.opConstant.index));
      expect(s.chunk.data![4], equals(1));
    });

    test('Get Alias', () {
      var input = 'alias Test r15\nmove Test 500';

      var s = Scanner(input);
      s.scanInstruction();
      s.scanInstruction();

      s.chunk.take();

      expect(s.chunk.aliases.length, equals(1));
      expect(s.chunk.aliases[0], equals('Test'));
      expect(s.chunk.data![0], equals(OpCode.opSetAlias.index));
      expect(s.chunk.data![1], equals(0));
      expect(s.chunk.data![2], equals(OpCode.opRegister.index));
      expect(s.chunk.data![3], equals(OpCode.opConstant.index));
      expect(s.chunk.data![4], equals(15));
      expect(s.chunk.data![5], equals(OpCode.opMove.index));
      expect(s.chunk.data![6], equals(OpCode.opGetAlias.index));
      expect(s.chunk.data![7], equals(0));
      expect(s.chunk.data![8], equals(OpCode.opConstant.index));
      expect(s.chunk.data![9], equals(18));
    });

    test('Move', () {
      var input =  'move r0 1\nmove r1 r0';

      var s = Scanner(input);
      s.scanInstruction();
      s.scanInstruction();
      s.chunk.take();

      expect(s.chunk.data!.length, equals(11));
      expect(s.chunk.data![0], equals(OpCode.opMove.index));
      expect(s.chunk.data![1], equals(OpCode.opConstant.index));
      expect(s.chunk.data![2], equals(0));
      expect(s.chunk.data![3], equals(OpCode.opConstant.index));
      expect(s.chunk.data![4], equals(1));
      expect(s.chunk.data![5], equals(OpCode.opMove.index));
      expect(s.chunk.data![6], equals(OpCode.opConstant.index));
      expect(s.chunk.data![7], equals(1));
      expect(s.chunk.data![8], equals(OpCode.opRegister.index));
      expect(s.chunk.data![9], equals(OpCode.opConstant.index));
      expect(s.chunk.data![10], equals(0));
    });

    test('Invalid Registry throws', (){
      var input = 'add r18 r0 1';

      var s = Scanner(input);
      expect(() => s.scanInstruction(), throwsArgumentError);
    });

    test('Add Instruction register value', () {
      var input = 'add r0 r0 1';
      
      var s = Scanner(input);
      s.scanInstruction();

      s.chunk.take();
      expect(s.chunk.data!.length, equals(8));
      expect(s.chunk.data![0], equals(OpCode.opAdd.index));
      expect(s.chunk.data![1], equals(OpCode.opConstant.index));
      expect(s.chunk.data![2], equals(0));
      expect(s.chunk.data![3], equals(OpCode.opRegister.index));
      expect(s.chunk.data![4], equals(OpCode.opConstant.index));
      expect(s.chunk.data![5], equals(0));
      expect(s.chunk.data![6], equals(OpCode.opConstant.index));
      expect(s.chunk.data![7], equals(1));
    });
    
    test('Add Instruction', () {
      var input = 'add r0 0 1';

      var s = Scanner(input);
      s.scanInstruction();

      s.chunk.take();
      expect(s.chunk.data!.length, equals(7));
      expect(s.chunk.data![0], equals(OpCode.opAdd.index));
      expect(s.chunk.data![1], equals(OpCode.opConstant.index));
      expect(s.chunk.data![2], equals(0));
      expect(s.chunk.data![3], equals(OpCode.opConstant.index));
      expect(s.chunk.data![4], equals(0));
      expect(s.chunk.data![5], equals(OpCode.opConstant.index));
      expect(s.chunk.data![6], equals(1));
    });

    test('Store Greater Than', () {
      var input = 'sgt r0 r0 1';
      
      var s = Scanner(input);
      s.scanInstruction();

      s.chunk.take();
      expect(s.chunk.data!.length, equals(8));
      expect(s.chunk.data![0], equals(OpCode.opStoreGt.index));
      expect(s.chunk.data![1], equals(OpCode.opConstant.index));
      expect(s.chunk.data![2], equals(0));
      expect(s.chunk.data![3], equals(OpCode.opRegister.index));
      expect(s.chunk.data![4], equals(OpCode.opConstant.index));
      expect(s.chunk.data![5], equals(0));
      expect(s.chunk.data![6], equals(OpCode.opConstant.index));
      expect(s.chunk.data![7], equals(1));
    });

    test('Store Less Than', () {
      var input = 'move r0 5\nslt r1 r0 10';
      var expected = [OpCode.opMove.index, OpCode.opConstant.index, 0, OpCode.opConstant.index, 5,
              OpCode.opStoreLt.index, OpCode.opConstant.index, 1, OpCode.opRegister.index, OpCode.opConstant.index, 0,
              OpCode.opConstant.index, 10];

      var s = Scanner(input);
      s.compile();
      s.chunk.take();

      expect(s.chunk.data!.length, equals(expected.length));
      expect(s.chunk.data, equals(expected));
    });

    test('Or bitwise', () {
      var input = 'or r0 1 2';
      var expected = [OpCode.opOr.index, OpCode.opConstant.index, 0, OpCode.opConstant.index, 1, OpCode.opConstant.index, 2];

      var s = Scanner(input);
      s.compile();
      s.chunk.take();

      expect(s.chunk.data!.length, equals(expected.length));
      expect(s.chunk.data, equals(expected));
    });

    test('And bitwise', () {
      var input = 'and r0 1 2';
      var expected = [OpCode.opAnd.index, OpCode.opConstant.index, 0, OpCode.opConstant.index, 1, OpCode.opConstant.index, 2];

      var s = Scanner(input);
      s.compile();
      s.chunk.take();

      expect(s.chunk.data!.length, equals(expected.length));
      expect(s.chunk.data, equals(expected));
    });

    test('Absolute value', () {
      var input = 'abs r0 10\nabs r1 -10';
      var expected = [OpCode.opAbs.index, OpCode.opConstant.index, 0, OpCode.opConstant.index, 10,
      OpCode.opAbs.index, OpCode.opConstant.index, 1, OpCode.opConstant.index, 18];

      var s = Scanner(input);
      s.compile();
      s.chunk.take();

      expect(s.chunk.data, equals(expected));
    });

    test('Ceiling value', () {
      var input = 'ceil r0 10.2';
      var expected = [OpCode.opCeil.index, OpCode.opConstant.index, 0, OpCode.opConstant.index, 18];

      var s = Scanner(input);
      s.compile();
      s.chunk.take();

      expect(s.chunk.data, equals(expected));
    });

    test('Floor value', () {
      var input = 'floor r0 10.2';
      var expected = [OpCode.opFloor.index, OpCode.opConstant.index, 0, OpCode.opConstant.index, 18];

      var s = Scanner(input);
      s.compile();
      s.chunk.take();

      expect(s.chunk.data, equals(expected));
    });

    test('Min value',  () {
      var input = 'min r0 1 2';
      var expected = [OpCode.opMin.index, OpCode.opConstant.index, 0, OpCode.opConstant.index, 1, OpCode.opConstant.index, 2];

      var s = Scanner(input);
      s.compile();
      s.chunk.take();

      expect(s.chunk.data, equals(expected));
    });

    test('Max value',  () {
      var input = 'max r0 1 2';
      var expected = [OpCode.opMax.index, OpCode.opConstant.index, 0, OpCode.opConstant.index, 1, OpCode.opConstant.index, 2];

      var s = Scanner(input);
      s.compile();
      s.chunk.take();

      expect(s.chunk.data, equals(expected));
    });
  });
}