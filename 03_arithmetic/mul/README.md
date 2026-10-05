# Multiplication Examples

For unsigned `MUL`, CF and OF are both set if the product's upper half is nonzero; otherwise both are cleared. The other arithmetic flags (SF, ZF, PF, and AF) are undefined after `MUL`, so their values cannot be inferred from the product.

## `mul1.asm`

`25 * 10 = 250 = 0x00FA` in `AX`.

| Flag | Status | Why |
| --- | --- | --- |
| CF | Cleared | The upper half, `AH`, is zero; the product fits in 8 bits. |
| OF | Cleared | The upper half, `AH`, is zero. |
| SF, ZF, PF, AF | Undefined | `MUL` does not define these flags. |

## `mul2.asm`

`3000 * 200 = 600000 = 0x0009:0x27C0` in `DX:AX`.

| Flag | Status | Why |
| --- | --- | --- |
| CF | Set | The upper half, `DX = 0x0009`, is nonzero, so the product does not fit in `AX` alone. |
| OF | Set | The upper half, `DX`, is nonzero. |
| SF, ZF, PF, AF | Undefined | `MUL` does not define these flags. |
