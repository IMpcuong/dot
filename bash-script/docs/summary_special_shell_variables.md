1. [Reference Cards](https://tldp.org/LDP/abs/html/refcards.html#AEN22728): useful summary of certain scripting concepts.

- Special Shell variables:

| Variable | Meaning                                             |
| :------- | :-------------------------------------------------- |
| $0       | Filename of script                                  |
| $1       | Positional parameter #1                             |
| $2 - $9  | Positional parameters #2 - #9                       |
| ${10}    | Positional parameter #10                            |
| $#       | Number of positional parameters                     |
| "$\*"    | All the positional parameters (as a single word) \* |
| "$@"     | All the positional parameters (as separate strings) |
| ${#\*}   | Number of positional parameters                     |
| ${#@}    | Number of positional parameters                     |
| $?       | Return value                                        |
| $$       | Process ID (PID) of script                          |
| $-       | Flags passed to script (using set)                  |
| $\_      | Last argument of previous command                   |
| $!       | Process ID (PID) of last job run in background      |

- Distinct between `$@` and `$*`:

  - The `$*` and `$@` variables hold all positional parameters/arguments passed to the function:

    - When double-quoted, "$\*" expands to a single string separated by space (the first character of IFS) - `"$1 $2 $n"`.
    - When double-quoted, "$@" expands to separate strings - `"$1" "$2" "$n"`.
    - When not double-quoted, `$*` and `$@` are the same.

NOTE:

- `*`: Must be quoted, otherwise it defaults to `$@` (in the `Meaning` column).
