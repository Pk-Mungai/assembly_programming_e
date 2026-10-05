# Addition Examples

The flags below are the values immediately after `ADD`, before the program's exit code runs. `xor ebx, ebx` in the exit code changes flags, so flags inspected after that instruction are not the `ADD` flags.

## `add1.asm`

`AL = 0x78 + 0x0A = 0x82` (120 + 10 = 130, in 8 bits).

| Flag | Status | Why |
| --- | --- | --- |
| CF | Cleared | The sum is 130, which fits in 8 bits; there is no carry out of bit 7. |
| OF | Set | Two positive signed values (120 and 10) produce `0x82`, a negative signed 8-bit value; the signed result overflows. |
| SF | Set | The result's most significant bit in `0x82` is 1. |
| ZF | Cleared | The result is nonzero. |
| PF | Set | `0x82` has two set bits, an even number. |
| AF | Set | The low-nibble sum `8 + A` carries from bit 3 into bit 4. |

## `add2.asm`

`AX = 32000 + 500 = 32500 = 0x7EF4` (16-bit addition).

| Flag | Status | Why |
| --- | --- | --- |
| CF | Cleared | The sum fits in 16 bits; there is no carry out of bit 15. |
| OF | Cleared | Both signed operands and the signed result (32500) are within the 16-bit signed range. |
| SF | Cleared | Bit 15 of `0x7EF4` is 0. |
| ZF | Cleared | The result is nonzero. |
| PF | Cleared | The low byte `0xF4` has five set bits, an odd number. |
| AF | Cleared | The low-nibble addition `0 + 4` does not carry into bit 4. |
