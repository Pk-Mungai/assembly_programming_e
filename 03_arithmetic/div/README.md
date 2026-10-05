# Division Examples

`DIV` stores the quotient and remainder in registers, but leaves the arithmetic flags undefined. Therefore CF, OF, SF, ZF, PF, and AF have no meaningful set/cleared status to report after the division. The quotient or remainder does not determine these flags.

## `div1.asm`

`AX = 100`, divided by `BL = 7`, gives quotient `AL = 14` and remainder `AH = 2`. All six arithmetic flags listed above are **undefined** after `DIV`.

## `div2.asm`

`DX:AX = 0:50000`, divided by `BX = 300`, gives quotient `AX = 166` and remainder `DX = 200`. All six arithmetic flags listed above are **undefined** after `DIV`.
