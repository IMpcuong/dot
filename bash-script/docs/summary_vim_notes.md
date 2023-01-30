## `Vim` note for dummy (like me):

- Search/move inline:

  - Forward: `f + <first_character_of_word>` -> search next: `;`.
  - Backward: `shift + f + <first_character_of_word>`.

- Duplicate previous action: remember action between 2 `COMMAND MODE` entries.

  - Exp: `COMMAND MODE` -> `INSERT MODE` delete 4 characters -> `COMMAND MODE` -> press `.` in any position -> reproduce: delete 4 characters.

- `COMMAND MODE` -> `VISUAL MODE` (press `v`) -> obliterate the word you want to delete -> press `c` -> will delete all the chosen characters and return to `INSERT MODE`.

- Replace inline: `VISUAL MODE` -> press `:` -> `:'<,'>s/<word>/<replace>/ic` (`i`: inline, `c`: confirm).

- Copy one (or multiple) line(s) to clipboard: `COMMAND MODE` -> `<start>,<end>y *` -> `p` to paste to wherever as you want to.

- Multi-cursors (concurrently): using edit-block mode to make it happen:
  Selecting a block of text (more than 1 line) -> `Shift + i` -> `EDIT BLOCK MODE` -> \<ESC\> (x2) to apply.

  - Checks if you have `+visualextra` enabled in your version of `Vim` using `:ver` in `COMMAND MODE`.

- Autocompletion: using `:e` or `Ctrl + e`.

- File explorer: using `:Ex` or `:Explore`

- Remove trailing white-spaces: `:%s/\s\+$//e`

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

  | Action         | Shortcut           | Description                                                                           |
  | :------------- | :----------------- | :------------------------------------------------------------------------------------ |
  | _[Delete]_     | x                  | Delete a character.                                                                   |
  |                | dw                 | Delete a word.                                                                        |
  |                | d5w                | Delete 5 words.                                                                       |
  |                | dd                 | Delete a line.                                                                        |
  |                | 3dd                | Delete 3 lines                                                                        |
  |                | D                  | Delete from the current position to the end of the line.                              |
  | _[Editing]_    | r                  | Replace current character.                                                            |
  |                | cw                 | Change the current word.                                                              |
  |                | cc                 | Change the current line.                                                              |
  |                | c$                 | Change the text from the current position to the end of the line.                     |
  |                | C                  | Same as `c$`.                                                                         |
  |                | A                  | Append to the end of line (jump to the end -> switch to edit mode.)                   |
  |                | ~                  | Reverse case of the obliteration character.                                           |
  |                | Ctrl + v           | `Visual Block` mode, using redirection character to choose content need to be edited. |
  |                | `:tabe <filepath>` | `tabe/tabedit` to open file in a new tab.                                             |
  |                | `:sp <filepath>`   | `sp/split` split screen in multiple files (horizontally).                             |
  |                | `:vs <filepath>`   | `vs/vsplit` split screen in multiple files (vertically).                              |
  | _[Copy/Paste]_ | yy                 | Yank (copy) the current line.                                                         |
  |                | y\<position\>      | Yank the position. Exp: `yw` := yank a word, `y3w` := yank 3 words.                   |
  |                | p                  | Paste the most recent deleted or yanked text.                                         |
  | _[Undo/Redo]_  | u                  | Undo.                                                                                 |
  |                | Ctrl + r           | Redo.                                                                                 |
  | _[Searching]_  | /\<pattern\>       | Start forward search for the \<pattern\>.                                             |
  |                | ?\<pattern\>       | Start reverse search for the \<pattern\>.                                             |
  | _[Moving]_     | '.                 | Jump to last modification line.                                                       |
  |                | `.                 | Jump to exact spot that was recorded the latest patches.                              |
  |                | Ctrl + o           | Retrace your movements in file in backwards.                                          |
  |                | Ctrl + i           | Retrace your movements in file in forwards.                                           |
  |                | gt                 | Similar to `tabn/tabnext`.                                                            |
  |                | gT                 | Similar to `tabp/tabprevious`.                                                        |
  |                | g\_                | Jump to the last non-blank character on this line.                                    |
  |                | o                  | Jumping to the next line (\\n character) in the `Normal` mode.                        |

- NOTE: Resources reference:

  - [Most productive shortcut on Vim][0]
  - [Indent multiple lines in Vim][1]
  - [Switch between tabs][2]
  - [Select text in Vim][3]
  - [Go back to last cursor position][4]
  - [Copy to clipboard on Vim][5]
  - [Delete a block of text in Vim][6]
  - [Auto-remove trailing whitespace characters][7]

  [0]: https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vimp
  [1]: https://stackoverflow.com/questions/235839/indent-multiple-lines-quickly-in-vi
  [2]: https://superuser.com/questions/410982/in-vim-how-can-i-quickly-switch-between-tabs
  [3]: https://stackoverflow.com/questions/17890904/how-do-you-select-text-in-vim
  [4]: https://www.cyberciti.biz/faq/unix-linux-vim-go-back-to-last-cursor-position/
  [5]: https://stackoverflow.com/questions/3961859/how-to-copy-to-clipboard-in-vim
  [6]: https://stackoverflow.com/questions/16721945/delete-a-block-of-text-in-vim
  [7]: https://vimtricks.com/p/vim-remove-trailing-whitespace/
