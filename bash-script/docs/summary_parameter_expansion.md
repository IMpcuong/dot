| Parameter Expansion	| Description |
|:-|:-|
| ${variable:-value} | If the variable is unset or undefined then expand the value. |
| ${variable:=value} | If the variable is unset or undefined then set the value to the variable. |
| ${variable:+value} | If the variable is set or defined then expand the value. |
| ${variable:start:length}	| Substring will retrieve from the start position to length position of the variable. |
| ${variable:start}	| Substring will retrieve from start position to the remaining part of the variable. |
| ${#variable} | Count the length of the variable. |
| ${variable/pattern/string} | Replace the part of the variable with string where the pattern match for the first time. |
| ${variable//pattern/string}	| Replace all occurrences in the variable with string where all pattern matches. |
| ${variable/#pattern/string}	| If the pattern exists at the beginning of the variable, then replace the occurrence with string. |
| ${variable/%pattern/string}	| If the pattern exists at the end of the variable, then replace the occurrence with string. |
| ${variable#pattern}	| Remove the shortest match from the beginning of the variable where the pattern matches. |
| ${variable##pattern} | Remove the longest match from the beginning of the variable where the pattern matches. |
| ${variable%pattern}	| Remove the shortest match from the end of the variable where the pattern matches. |
| ${variable%%pattern} | Remove the longest match from the end of the variable where the pattern matches. |