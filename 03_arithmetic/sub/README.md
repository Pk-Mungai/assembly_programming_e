# Subtraction Examples

The flags below are the values immediately after 'SUB', before the program's exit code runs. A subtraction sets CF when an unsigned borrow is needed; OF indicates signed overflow.

## `sub1.asm`

`AL = 50 - 80 = -30 = 0xE2` (8-bit result).

| Flag | Status | Why |
| --- | --- | --- |
| CF | Set | As unsigned values, 50 is less than 80, so subtraction borrows beyond the 8-bit value. |
| OF | Cleared | As signed values, `50 - 80 = -30`, which is representable in 8 bits. |
| SF | Set | The result's most significant bit in `0xE2` is 1. |
| ZF | Cleared | The result is nonzero. |
| PF | Set | `0xE2` has four set bits, an even number. |
| AF | Cleared | The low nibbles are `2 - 0`; no borrow crosses bit 3. |

## `sub2.asm`

`AX = 1000 - 2000 = -1000 = 0xFC18` (16-bit result).

| Flag | Status | Why |
| --- | --- | --- |
| CF | Set | As unsigned values, 1000 is less than 2000, so the subtraction requires a borrow. |
| OF | Cleared | The signed result, -1000, is within the 16-bit signed range. |
| SF | Set | Bit 15 of `0xFC18` is 1. |
| ZF | Cleared | The result is nonzero. |
| PF | Set | The low byte `0x18` has two set bits, an even number. |
| AF | Cleared | The low nibbles are `8 - 0`; there is no borrow across bit 3. |
