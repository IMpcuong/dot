## `Vim` note for dummy (like me):

- Search/move inline:

  - Forward: `f + <first_character_of_word>` -> search next: `;`.
  - Backward: `Shift + f + <first_character_of_word>`.

- Duplicate previous action: remember action between 2 `COMMAND MODE` entries.

  - Exp: `COMMAND MODE` -> `INSERT MODE` delete 4 characters -> `COMMAND MODE` -> press `.` in any position -> reproduce: delete 4 characters.

- `COMMAND MODE` -> `VISUAL MODE` (press `v`) -> obliterate the word you want to delete -> press `c` -> will delete all the chosen characters and return to `INSERT MODE`.

- Replace inline: `VISUAL MODE` -> press `:` -> `:'<,'>s/<word>/<replace>/ic` (`i`: inline, `c`: confirm).

- Copy one (or multiple) line(s) to clipboard: `COMMAND MODE` -> `<start>,<end>y *` -> `p` to paste to wherever as you want to.

- Multi-cursors (concurrently): using edit-block mode to make it happen:

  ```txt
  Selecting a block of text (`VISUAL BLOCK` := `Ctrl + v` wrapping more than 1 line)
    -> `Shift + i`
    -> `EDIT BLOCK MODE` := typing whatever you want
    -> \<ESC\> (x2) (-> \<C-c\>) to apply.

  Selecting a block of text (`VISUAL BLOCK` := `Ctrl + v` wrapping more than 1 line)
    -> `Shift + 4 ($)` - move cursor to last character
    -> `Shift + a (A)` - enter insert mode after the last character
    -> Insert desired text
    -> \<ESC\> (x2) (-> \<C-c\>) to apply.
  ```

  - Checks if you have `+visualextra` enabled in your version of `Vim` using `:ver` in `COMMAND MODE`.

- Autocompletion: `Ctrl + n` for auto-completion suggestion, `Ctrl + p` to select in reverse order (from bottom to top).
- Keyword completion: `Ctrl + p`.

- Auto-indent all lines to the left-most position in the opening document: `gg=G`.

- File explorer: using `:Ex` or `:Explore`

- Substitution commands with some elegant pattern: (NOTE: This is the string substitution in `Ruby`, `Vim` has been written in `Ruby`).

  - Remove trailing white-spaces: `:%s/\s\+$//e`.
  - Substitute reference captured group (regex): `:%s/\(hello\) \(world\)/\1, there/g`. (Out: `hello, there`)
  - Substitute each word's quotes boundary with backticks punctuation: `` :%s/"(\w+)"/`\1`/g ``.
  - NOTE: If you have more than 9 capture groups, you can use `\g<1>`, `\g<2>`, etc. to reference them in the substitution string.

- File-formatting conversion between different platforms (exp: Windows -> MacOS):

  ```vim
  " Forcing DOS file format, Vim will remove CRLF and LF-only line endings, leaving only the text of each line in the buffer.

  " The `:e ++ff=dos` tells Vim to read the file again, and then forcing to the DOS format file-system.
  :e ++ff=dos
  :set ff=unix
  :wq
  ```

- Execute native shell commands inside vim command-mode:

  ```vim
  " Output the command results to a file.
  :r!./shell.sh

  " The opposite of the command above.
  :!./shell.sh

  " If you already have the `shell.sh` line in the file, you can include output with the file with:
  !!sh
  ```

- Set `fileformat=unix` for all opened files in Vim (exp: `zsh-syntax-highlighting`):

  ```vim
  vim */**/*.zsh
  :bufdo set ff=unix | update
  " Or:
  :args *.zsh
  :argdo set ff=unix | update
  ```

- A good line to memorize:

  ```vim
  :set et sts=4 sw=4 ts=4

  " et  = expandtab (spaces instead of tabs).
  " ts  = tabstop (the number of spaces that a tab equates to).
  " sw  = shiftwidth (the number of spaces to use when indenting or de-indenting a line).
  " sts = softtabstop (the number of spaces to use when expanding tabs).
  ```

- Unset a command's utility in Vim:

  ```vim
  :set list
  :set list& " Unset the EOL character exposed by the list command.
  ```

- Quote/unquote words in Vim:

  ```vim
  ciw'Ctrl+r"'
  " ciw - Delete the word the cursor is on, and end up in insert mode.
  " ' - Add the first quote.
  " Ctrl+r" - Insert the contents of the " register, aka the last yank/delete.
  " ' - Add the closing quote.
  ```

- Word(s)-replacement using register's content:

  ```vim
  " reg-0 ~ "0: nonsense_text
  ciw -> Ctrl+r -> 0
  ```

- Navigates between any matched pair of brackets (curly, braces):

  ```vim
  v (Visual mode)
  " Relocate the cursor to the first half of the intended pair.
  %
  ```

- Navigates between paragraphs (blank line or ending of a text-block):

  ```vim
  v (Visual mode)
  Shift + { (switch forth to the adjacent paragraph)
  Shift + } (switch back to the previous paragraph)
  ```

- Navigates between the two identical string-sequence: `Shift` + 3 (on Visual Mode).

- Upper/lowercase multiple characters in Visual Mode: `U := upper` | `u := lower` | `tilde (~) := toggle between case`.

- `Shift + k` := jump to the man-page definition if the OS has known about the language's specifications.

- Quick insert-mode keys-binding:

  ```vim
  " Status quo is _VISUAL_ mode.
  Shift + a -> starts editing from EOL.
  Shift + i -> starts editing from BOL.
  Shift + s -> starts editing (on a blank line) at the same position as the line above started.
  ```

- Recording mode in Vim:

  ```vim
  :h recording
  " q{0-9a-zA-Z"}           Record typed characters into register {0-9a-zA-Z"}
  "                         (uppercase to append).  The 'q' command is disabled
  "                         while executing a register, and it doesn't work inside
  "                         a mapping.  {Vi: no recording}

  " q                       Stops recording.  (Implementation note: The 'q' that
  "                         stops recording is not stored in the register, unless
  "                         it was the result of a mapping)  {Vi: no recording}

  "                                                         " *@*
  " @{0-9a-z".=*}           Execute the contents of register {0-9a-z".=*} [count]
  "                         times.  Note that register '%' (name of the current
  "                         file) and '#' (name of the alternate file) cannot be
  "                         used.  For "@=" you are prompted to enter an
  "                         expression.  The result of the expression is then
  "                         executed.  See also |@:|.  {Vi: only named registers}
  ```

- Use range to manipulate content of a file:

  - Summary: `[range][operation][additional-options]`.

  | Command                     | Explanation                                                                                                       |
  | :-------------------------- | :---------------------------------------------------------------------------------------------------------------- |
  | `:%d`                       | Delete whole content.                                                                                             |
  | `:1,153d`                   | Delete a multiple lines of text.                                                                                  |
  | `:4dd`                      | Delete multi-lines of text (exp: 4 lines), starting at the line the cursor is on.                                 |
  | `:di''`                     | Delete inside `''`.                                                                                               |
  | `:dap`                      | Delete around a paragraph.                                                                                        |
  | `:ci(` or `ci"`             | Editing content inside `()` or `""`.                                                                              |
  | `:%y`                       | Yank (copy) all.                                                                                                  |
  | `''<register-name><cmd>`    | Store all content to the register. Exp: `''ayy` (copy text to register `a`) -> `''ap` (paste text from register). |
  |                             | List available registers: `:registers`.                                                                           |
  | `:.,+10w !tmux load-buffer` | Save (current-line, +10 lines) to `tmux` clipboard.                                                               |
  | `50,$w !bash`               | Run a specific region/block of text as shell-command.                                                             |
  | `:%w !xsel -ib`             | Save whole content to system's clipboard.                                                                         |
  | `:.,+4t`                    | Directly duplicate lines into the adjacent position.                                                              |
  | `:1,+10 move +/-N`          | Directly moving lines to specific line number-N (or plus/minus N lines from this current position).               |
  | `:%s/<expr>/<substitution>` | Substitutes matched text pattern with the new one.                                                                |

  - Register types:

  | Type              | Symbol | Description                                                                                          |
  | :---------------- | :----: | :--------------------------------------------------------------------------------------------------- |
  | Unnamed           |        | Denoted by `""`. Vim stores deleted or copied text in this register.                                 |
  | Named             |        | We can use 26 named registers, from `a-z \|\| A-Z`. By default Vim doesn't uses these registers.     |
  |                   |        | Lowercase register: `contents will be overwritten`.                                                  |
  |                   |        | Uppercase register: `contents will be appended`.                                                     |
  | Numbered          |        | We can use `0-9` named registers. Will fills these registers with text from yank and delete command. |
  |                   |        | Numbered `register 0` contains the text from the most recent yank command.                           |
  |                   |        | Numbered `register 1` contains the text deleted by the most recent delete or change command.         |
  | Default registers |  `%`   | Name of the current file.                                                                            |
  |                   |  `#`   | Name of the alternative file for the current window.                                                 |
  |                   |  `:`   | Most recently executed command.                                                                      |
  |                   |  `.`   | Contains the last inserted text.                                                                     |
  |                   |  `"`   | Last used register.                                                                                  |

  - Register command and content invocation: https://vi.stackexchange.com/questions/25947/execute-the-contents-of-a-register

    - Command: `NORMAL MODE` -> `COMMAND MODE` -> `:@a` (execute the contents of register `"a`).
    - Using registered content on the main page: `NORMAL MODE` -> `""ap` (copy contents from register `"a` and paste it to the current cursor position).

  - Useful special characters when using line addressing:

  | Character  | Explanation                   |
  | :--------- | :---------------------------- |
  | `.`        | Current line.                 |
  | `$`        | Last line.                    |
  | `/<text>/` | Next occurrence of text.      |
  | `?<text>?` | Previous occurrence text.     |
  | `*`        | All text currently on screen. |
  | `%`        | Entire file.                  |
  | `+N`       | Next N lines.                 |
  | `-N`       | Previous N lines.             |

- Table of some common motions/actions:

  | Action         | Shortcut                               | Description                                                                                   |
  | :------------- | :------------------------------------- | :-------------------------------------------------------------------------------------------- |
  | _[Delete]_     | x                                      | Delete a character.                                                                           |
  |                | dw                                     | Delete a word.                                                                                |
  |                | d5w                                    | Delete 5 words.                                                                               |
  |                | dd                                     | Delete a line.                                                                                |
  |                | 3dd                                    | Delete 3 lines                                                                                |
  |                | C                                      | Delete the whole line and switch to the `INSERT MODE`.                                        |
  |                | D                                      | Delete from the current position to the end of the line.                                      |
  | _[Editing]_    | r                                      | Replace current character.                                                                    |
  |                | cw                                     | Change the current word.                                                                      |
  |                | ciw                                    | Replace all blank spaces from the beginning of an line until reached first non-nil character. |
  |                | diw                                    |                                                                                               |
  |                | viw                                    |                                                                                               |
  |                | cc                                     | Change the current line.                                                                      |
  |                | c$                                     | Change the text from the current position to the end of the line.                             |
  |                | C                                      | Same as `c$`.                                                                                 |
  |                | A                                      | Append to the end of line (jump to the end -> switch to edit mode.)                           |
  |                | ~                                      | Reverse case of the obliteration character.                                                   |
  |                | Ctrl + v                               | `Visual Block` mode, using redirection character to choose content need to be edited.         |
  |                | `:tabe <filepath>`                     | `tabe/tabedit` to open file in a new tab.                                                     |
  |                | `:sp <filepath>`                       | `sp/split` split screen in multiple files (horizontally).                                     |
  |                | `:vs <filepath>`                       | `vs/vsplit` split screen in multiple files (vertically).                                      |
  | _[Copy/Paste]_ | yy                                     | Yank (copy) the current line.                                                                 |
  |                | y\<position\>                          | Yank the position. Exp: `yw` := yank a word, `y3w` := yank 3 words.                           |
  |                | p                                      | Paste the most recent deleted or yanked text.                                                 |
  | _[Undo/Redo]_  | u                                      | Undo.                                                                                         |
  |                | Ctrl + r                               | Redo.                                                                                         |
  | _[Searching]_  | /\<pattern\>                           | Start forward search for the \<pattern\>.                                                     |
  |                | ?\<pattern\>                           | Start reverse search for the \<pattern\>.                                                     |
  |                | `:Ex[plore]`                           | Open local directory browser on the current file's directory (or on \[dir\] if specified).    |
  |                | `:Sex`                                 | Split the explorer browser windows.                                                           |
  |                | `:Vex`                                 | Vertical directional split tab-panes.                                                         |
  |                | `:Tex`                                 | Open Directory's browser on a totally new tab (similar with `tabe %`).                        |
  |                | `:e %:h`                               | Netrw Directory Listing.                                                                      |
  | _[Moving]_     | '.                                     | Jump to last modification line.                                                               |
  |                | `.                                     | Jump to exact spot that was recorded the latest patches.                                      |
  |                | Ctrl + o                               | Retrace your movements in file in backwards.                                                  |
  |                | Ctrl + i                               | Retrace your movements in file in forwards.                                                   |
  |                | gt                                     | Similar to `tabn/tabnext`.                                                                    |
  |                | gT                                     | Similar to `tabp/tabprevious`.                                                                |
  |                | g\_                                    | Jump to the last non-blank character on this line.                                            |
  |                | o                                      | Jumping to the next line (\\n character) in the `Normal` mode.                                |
  |                | %                                      | Moving between current code block's parentheses/brackets.                                     |
  |                | `<ctrl / command> + w + w\|h\|j\|k\|l` | Navigate between floating panes on the current opening window.                                |

- NOTE: Resources reference:

  - [Most productive shortcut on Vim][0]
  - [Indent multiple lines in Vim][1]
  - [Switch between tabs][2]
  - [Select text in Vim][3]
  - [Go back to last cursor position][4]
  - [Copy to clipboard on Vim][5]
  - [Delete a block of text in Vim][6]
  - [Auto-remove trailing whitespace characters][7]
  - [Windows Explorer in Vim][8]
  - [Get rid of carriage returns on Windows][9]
  - [Execute Shell commands in Vim][10]
  - [Converting file format in Vim][11]
  - [Learn Vim-script the hard way][12]
  - [Recording mode in Vim][13]
  - [Moving to the matching braces][14]
  - [Built-in auto-completion in Vim][15]

  [0]: https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vimp
  [1]: https://stackoverflow.com/questions/235839/indent-multiple-lines-quickly-in-vi
  [2]: https://superuser.com/questions/410982/in-vim-how-can-i-quickly-switch-between-tabs
  [3]: https://stackoverflow.com/questions/17890904/how-do-you-select-text-in-vim
  [4]: https://www.cyberciti.biz/faq/unix-linux-vim-go-back-to-last-cursor-position/
  [5]: https://stackoverflow.com/questions/3961859/how-to-copy-to-clipboard-in-vim
  [6]: https://stackoverflow.com/questions/16721945/delete-a-block-of-text-in-vim
  [7]: https://vimtricks.com/p/vim-remove-trailing-whitespace/
  [8]: https://superuser.com/questions/31677/how-do-i-open-the-directory-of-the-current-open-file
  [9]: https://unix.stackexchange.com/questions/32001/what-is-m-and-how-do-i-get-rid-of-it
  [10]: https://stackoverflow.com/questions/23097842/how-to-execute-command-inside-vim
  [11]: https://vim.fandom.com/wiki/File_format
  [12]: https://learnvimscriptthehardway.stevelosh.com/
  [13]: https://stackoverflow.com/questions/1527784/what-is-vim-recording-and-how-can-it-be-disabled
  [14]: https://vim.fandom.com/wiki/Moving_to_matching_braces
  [15]: https://linuxhandbook.com/vim-auto-complete/
