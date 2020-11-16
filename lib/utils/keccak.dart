/*
import 'dart:typed_data';
import 'dart:math';

class Keccak {
  static Uint8List hash(Uint8List input) {
    return keccak(input);
  }

  static void keccakf(Uint64List state, [int rounds = 0]) {
    int t;

    Uint64List bc = Uint64List(5);

    for (int round = 0; round < rounds; round++) {
      */
/* Theta *//*

      for (int i = 0; i < 5; i++) {
        bc[i] = state[i] ^
        state[i + 5] ^
        state[i + 10] ^
        state[i + 15] ^
        state[i + 20];
      }

      for (int i = 0; i < 5; i++) {
        t = bc[(i + 4) % 5] ^ rotl64(bc[(i + 1) % 5], 1);

        for (int j = 0; j < 25; j += 5) {
          state[i + j] ^= t;
        }
      }

      */
/* Rho Pi *//*

      t = state[1];

      for (int i = 0; i < 24; i++) {
        int j = keccakfPiln[i];
        bc[0] = state[j];
        state[j] = rotl64(t, (keccakfRotc[i]).toUnsigned(64));
        t = bc[0];
      }

      */
/* Chi *//*

      for (int j = 0; j < 25; j += 5) {
        for (int i = 0; i < 5; i++) {
          bc[i] = state[i + j];
        }

        for (int i = 0; i < 5; i++) {
          state[i + j] ^= (~bc[(i + 1) % 5]) & bc[(i + 2) % 5];
        }
      }

      */
/* Iota *//*

      state[0] ^= keccakfRndc[round];
    }
  }

  */
/* Compute a hash of length outputSize from input *//*

  static Uint8List _keccak(Uint8List input, int outputSize) {
    Uint64List state = Uint64List(25);

    int rsiz = hashDataArea;

    if (outputSize != 200) {
      rsiz = 200 - 2 * outputSize;
    }

    int rsizw = (rsiz ~/ 8).toInt().toSigned(32);

    int inputLength = input.length;

    */
/* Offset of input array *//*

    int offset = 0;

    for (; inputLength >= rsiz; inputLength -= rsiz, offset += rsiz) {
      for (int i = 0; i < rsizw; i++) {
        */
/* Read 8 bytes as a ulong, need to multiply i by 8
                       because we're reading chunks of 8 at once *//*

        state[i] ^= ByteData.view(input.buffer)
            .getUint64(offset + (i * 8), Endian.little);

      }

      keccakf(state);
    }

    Uint8List tmp = Uint8List(144);

    */
/* Copy inputLength bytes from input to tmp at an offset of
               offset from input *//*

    for (int i = 0; i < inputLength; i++) {
      tmp[i] = input[i];
    }

    tmp[inputLength] = 1;
    inputLength++;

    */
/* Zero (rsiz - inputLength) bytes in tmp, at an offset of
               inputLength *//*

    for (int i = inputLength; i < rsiz; i++) {
      tmp[i] = 0;
    }

    tmp[rsiz - 1] |= 0x80;
    tmp[rsiz] = 1;

    for (int i = 0; i < rsizw; i++) {
      */
/* Read 8 bytes as a ulong - need to read at (i * 8) because
                   we're reading chunks of 8 at once, rather than overlapping
                   chunks of 8 *//*

      state[i] ^= ByteData.view(tmp.buffer,i*8, 8).getUint64(0, Endian.host);
    }

    keccakf(state, keccakRounds);

    Uint8List output = state.buffer.asUint8List(0, outputSize);

    return output;
  }

  static int rotl64(int x, int y) {
    x = x.toUnsigned(64);
    y = y.toUnsigned(64);
    return (x << y | x >> ((64 - y))).toUnsigned(64);
  }

  */
/* Hashes the given input with keccak, into an output hash of 200
           bytes. *//*

  static Uint8List keccak1600(Uint8List input) {
    return _keccak(input, 200);
  }

  */
/* Hashes the given input with keccak, into an output hash of 32 bytes.
           Copies outputLength bytes of the output and returns it. Output
           length cannot be larger than 32. *//*

  static Uint8List keccak(Uint8List input, [int outputLength = 32]) {
    if (outputLength > 32) {
      throw ArgumentError("Output length must be 32 bytes or less!");
    }

    Uint8List result = _keccak(input, 32);

    Uint8List output = Uint8List(outputLength);

    */
/* Don't overflow input array *//*

    for (int i = 0; i < min(outputLength, 32); i++) {
      output[i] = result[i];
    }

    return output;
  }
}
*/
