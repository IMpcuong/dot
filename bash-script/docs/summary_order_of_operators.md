| Order of operations | Semantics |
|:-|:-|
| `()`  `[]`  `->`  `.`  `::` | Function call, scope, array/member access |
| `!`  `~`  `-`  `+`  `*`  `&`  `sizeof`  `type`  `cast`  `++`  `--` | (most) unary operators, sizeof and type casts (right to left) |
| `*`  `/`  `%`  `MOD` | Multiplication, division, modulo |
| `+`  `-` | Addition and subtraction |
| `<<`  `>>` | Bitwise shift left and right |
| `<`  `<=`  `>`  `>=` | Comparisons: less-than and greater-than |
| `==`  `!=` | Comparisons: equal and not equal |
| `&`	| Bitwise AND |
| `^`	| Bitwise exclusive OR (XOR) |
| `|`	| Bitwise inclusive (normal) OR |
| `&&` | Logical AND |
| `||` | Logical OR |
| `?`  `:` | Conditional expression (ternary) |
| `=`  `+=`  `-=`  `*=`  `/=`  `%=`  `&=`  `\|=`  `^=`  `<<=`  `>>=` | Assignment operators (right to left) |
| `,`	| Comma operator |