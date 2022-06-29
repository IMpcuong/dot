> - REM ~ REMARK, Print all of the stdout of all the commands with `@echo on`.
>
> - `@echo` == `ECHO`, the similarity of semantic with `set +x` in `bash`.
>
> - REM Always set this first three/four lines to any batch scripts ever after.
>
> - REM `SETLOCAL` := make a variables local to the scope of this script
>
> - :: `SETLOCAL` := ensures to not overwrite/clobber any existing variables inside script.
>
> - :: `ENABLEEXTENSIONS` := argument turns on a very helpful feature called command processor extensions.
>
> - :: `ENABLEDELAYEXPANSION` := enable variable using syntax `!var!`
>
> - :: `me` := as the name of the script itself -> invoke it with `%me%`
>
> - :: `parent` := parent path to the script -> invoke it with `%parent%`
>
> - :: NOTE: the first `%` in `%%i` is used to escape the % after it. Summary:
>
> - :: Use `%%` when in a batch file.
>
> - :: Use `%` when outside a batch file (on a command line).
