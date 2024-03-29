1. `xargs`: using `stdout` as `stdin` for command not allowed stream input.

- Exp1: copy all the files with same extension to destination directory.

  - NOTE: `cp -t` specify destination folder for the `copy` command.

  ```bash
  find ~/Downloads/ -name "*.jpg" | xargs cp -t .
  ```

- Exp2: measure each directory from output of the `ls` command.

  - NOTE: `ls -1` list one file per line.

  ```bash
  ls -1 | xargs du -sh
  ```

- Exp3: search through `man` pages.

  ```bash
  man -k <KEYWORD>
  ```

- Exp4: some commands utility (Clear the option by using: `manopt id -G`).

  ```bash
  info coreutils "ls invocation"
  groups
  id -Gn
  ls -gloRF --dired tmp
  ```

2. Learning Linux from scratch (again): `Linux for Beginners` book.

- Prompt: display the common format `username@servername`, and will determine the user is using the system as `normal user ($)` or a `super user (#)`.

- `Superuser` on a Linux system also calles as `root` -> `sudo` ~ `SuperUser Do`: grant specific users root privileges for specific cases.

- `~` := `tilde` is a shorthand way of representing the home directory for the current user.

- `Linux Directory Structure/Layout`:

  - Common Directories: `man hier` ~ description of the file system hierarchy.

    - NOTE: `*` := asterisk means that the directories was mentioned that can be easily skim over.

    | Dir          | Description                                                                                                         |
    | :----------- | :------------------------------------------------------------------------------------------------------------------ |
    | /            | "Root" directory, the starting point of the file system hierarchy. NOTE: not related to the root/superuser account. |
    | /bin         | Binaries and other executable programs.                                                                             |
    | /dev\*       | Device files, typically controlled by the operating system and the system administrator.                            |
    | /etc         | System configuration files.                                                                                         |
    | /home        | Home directories.                                                                                                   |
    | /opt         | Optional or third-party softwares.                                                                                  |
    | /proc\*      | Provides information about running processes.                                                                       |
    | /sbin\*      | System administrator binaries.                                                                                      |
    | /selinux\*   | Used to display information about SELinux.                                                                          |
    | /srv\*       | Contains data which is served by the system.                                                                        |
    | /srv/www\*   | Web server files.                                                                                                   |
    | /srv/ftp\*   | FTP files.                                                                                                          |
    | /sys\*       | Used to display, sometimes configure the devices and buses known to the Linux kernel.                               |
    | /tmp         | Temporary space, typically cleared on reboot.                                                                       |
    | /usr         | User related programs.                                                                                              |
    | /usr/bin\*   | Binaries and executable programs.                                                                                   |
    | /usr/lib\*   | Libraries.                                                                                                          |
    | /usr/local\* | Locally installed software that is not part of the base operating system.                                           |
    | /usr/sbin\*  | System administration binaries.                                                                                     |
    | /var         | Variable data, most notably log files.                                                                              |
    | /var/log\*   | Log files.                                                                                                          |

  - Application Directory Structure: `appname: [/bin, /etc, /lib, /logs]`

- Listing files by Type:

  - A `link`: is sometimes called as a `symlink`, short for symbolic link. A link points to the location of the actual file a directory.
  - `Symbolic links`: can be used to create shortcuts to long directory names. Another common use is to have a symlink to the latest version of installed software.
  - NOTE: you can operate on the link as if it were the actual file or directoy.

    ```bash
    ls -F
    ls -R
    ```

  - `ls` options demystify:

    - `-r`: display list files in reverse datetime order.
    - `-R`: display recursively.
    - `-F`: option will append a character to the file name that reveals what type it is.

    | Symbol | Meaning                                                                    |
    | :----: | :------------------------------------------------------------------------- |
    |   /    | Directory.                                                                 |
    |   @    | Link. The file that follows the `->` symbol is the target of the link.     |
    |   =    | Socket. Stands for Unix Domain Socket file (`find . -maxdepth 1 -type s`). |
    |   \|   | FIFO Named pipe.                                                           |
    |   \*   | Executable program.                                                        |

- Default Permissions and the File Creation Mask:

  - Definition: The file creation mask is what determines the permission attach simultaneously with the new born file. The mask restricts or mask permissions, thus determining the ultimate permission for a file or directory will be given.

  - Syntax:

    ```bash
    umask [-S] [mode] <file/dir>
    umask -S 0027 ~/tmp
    ```

  - Explanation:

    - `-S`: set the mode with the symbolic notation (exp: `u=rwx,g=rx,o=`).
    - `[mode]`: identical with the octal/numeric based permission in `chmod` command.
    - Default mode that will apply to all of the newly created file inside the `~/tmp` directory will be:

    |                     | Dir  | File |
    | :------------------ | :--: | :--: |
    | Base Permission     | 777  | 666  |
    | Minus Umask         | -027 | -027 |
    | Creation Permission | 750  | 640  |

- Special modes:

  - Look at this example: there's an extra leading `0`, last 3 characters represent permissions for `user, group, other`.
  - The first numeric represents for the class of special modes := `{ setuid, setgid, sticky }`. (\[Un\]Set `sticky` mode to a directory)
  - NOTE: (`umask 0022` === `umask 022`) && (`chmod 0644` === `chmod 644`).

  | Special Mode      | Description                                                                                               |
  | :---------------- | :-------------------------------------------------------------------------------------------------------- |
  | setuid permission | Allows a process to run as the owner of the file.                                                         |
  | setgid permission | Allows a process to run with the group of the file, not with the group user use to execute it.            |
  | sticky bit        | Prevents a user from deleting another user's files even if they would normally have permissions to do so. |

  ```bash
  $ umask
  0027

  $ chmod u+t,o-t ~/tmp
  drwxrw-rw- 3 usr usr 4096 Aug 16 17:00 tmp/
  ```

- Finding files:

  - `find`: an equivalent to a search toolbox in Linux system. Let's jump right into an example to analyze each molecule/atom/iota of this command:

    ```bash
    [Syntax]
    find . -newer <file> - [Finds files that are newer than the given file.]
    find . -newerXY <file> - [Succeeds if timestamp X of the file being considered is newer than timestamp Y of the file reference.]
      # The letters X and Y can be any of the following letters:
      # a   The access time of the file reference
      # B   The birth time of the file reference
      # c   The inode status change time of reference
      # m   The modification time of the file reference
      # t   reference is interpreted directly as a time
    ```

    ```bash
    find . -path "./sr*kg" - [File name matches shell pattern; e.g. this example will print an entry for directory "./src/pkg"]
    find ./github -path "./github*ot"
      # ./github/dot
      # ./github/toy-projects/telebot
      # ./github/toy-projects/telebot/bot

    find . -path "./sr*kg" --prune - [Use "-prune" to ignore checking every file in the directory tree.]
    find ./github -path "./github*ot" -prune
      # ./github/dot
      # ./github/toy-projects/telebot
    ```

    ```bash
    find ./tmp/ -name "*txt" -size -100k -mtime +10 -exec grep -nrH [[:digit:]]* {} \;
                 |            |           |          |
                 |            |           |          +--------------------------------> `-exec <command> {} \;`    := executes this command against all the files that are found.
                 |            |           +-------------------------------------------> `-mtime <num_days>`        := constrains the results by the order of time (+/-: more/less than <num_days> old).
                 |            +-------------------------------------------------------> `-size <num>[c/k/M/G]`     := constrains the results by the file size limitation (+/-: more/less than <num> size).
                 +--------------------------------------------------------------------> `-name/-iname "<pattern>"` := displays file whose name matches the pattern, case-sensitive or insensitive.
    ```

    ```bash
    find . -type d -a -regextype "egrep" -regex ".*tmp.*"
    find . -type f -a -regextype "egrep" -regex ".*tmp.*"
            |       |  |                  |
            |       |  |                  +---------------> `-regex <pattern>` := search for file name that matched the regex pattern, note that this is match on the "whole path", not a partial recognition.
            |       |  +----------------------------------> `-regextype [posix-awk | posix-basic | posix-egrep | posix-extended]` := changes the regex syntax understood by `-regex/-iregex` tests later on.
            |       +-------------------------------------> `-type <OS_supported>` :=  POSIX specifies `b`, `c`, `d`, `l`, `p`, `f`, and `s`.
            +---------------------------------------------> `-a/-o` := Operator join together the other items within the expression `-o ~ logical OR`, `-a ~ logical AND`.
    ```

  - `locate`: find file by name. If you know a file's name or at least part of its name, the main purpose is retrieve the location where it resides.
    The `locate` command can half recognize the pattern and return the list of all absolute paths of files that its name was matched the pattern.

    ```bash
    locate *.sh
    ```

  - [The "/etc/passwd" file](http://www.linfo.org/etc_passwd.html) : a text file that contains the _attributes_ (basic information about) each user/account on a computer running Linux/Unix-like operating system.

    - Each line in `/etc/passwd` represents a single user/account:

    > - The first line: listed `root/administrator` account, which has complete power over every aspect of the system.
    > - The last lines: represents real people who are use the system.

    - Each line contains 7 attributes/fields: `[ name, password, userID, groupID, gecos, home-directory, shell ]`, each field is separated from the adjacent by the colons (`:`) with no spaces. If there is no data for an attribute, there is no space, but, rather, 2 consecutive colons.

    | Attribute/Field | Description                                                                                                                                                                      |
    | :-------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | name            | The user's `login name`, each such name must be an unique string.                                                                                                                |
    | password        | Contains excrypted login passwords, for security reason, the real passwords now storing in `/etc/shadow` that cannot be read by ordinary user.                                   |
    |                 | If the field contains the letter (x) indicates that the system required a password for authenticate this user.                                                                   |
    | userID          | User's unique numeric identification number, which is used by the system for access control.                                                                                     |
    |                 | `Zero` is reserved for `root` account.                                                                                                                                           |
    |                 | `1 -> 99` are reserved for other predefined accounts.                                                                                                                            |
    |                 | `100 -> 999` are available for ordinary users and groups.                                                                                                                        |
    | groupID         | Specifies the user's principal group identification number. This is usually the same as the user ID.                                                                             |
    | gecos           | Acronym for `General Electric Comprehensive Operating System`, contains general information about the user that is not needed by the system, most commonly the user's real name. |
    |                 | Alternatively, it can contain multiple entries, each separated by a comma.                                                                                                       |
    | home-directory  | The full path (i.e., the location relative to the root directory) of the user's home directory.                                                                                  |
    |                 | This is the directory that the user is first in when logging into the system and which contains programs and configuration files specific to that user.                          |
    | shell           | The full path of the default shell for the user.                                                                                                                                 |
    |                 | A shell is a program that provides a text-only user interface and whose main purpose is to execute commands typed in by a user and display the results.                          |
    |                 | The default shell on Linux is bash, whose absolute path is /bin/bash.                                                                                                            |

- Comparing files:

  ```bash
  diff <file1> <file2> - [Compare two files.]
  sdiff <file1> <file2> - [Compare two files side by side.]
  vimdiff <file1> <file2> - [Highlight the differences between two files in the vim editor.]
  ```

- Searching in files:

  - Searching for Text in Ascii files:

    ```bash
    [Syntax]
    grep -v <pattern> <file> - [Invert match, return lines not match the pattern.]
    grep -i <pattern> <file> - [Perform searching pattern ignoring case.]
    grep -c <pattern> <file> - [Count the number of occurences in a file.]
    grep -n <pattern> <file> - [Precede output with numbers of line that contains the pattern.]
    ```

  - Search for Text in Binary files:

    ```bash
    [Syntax]
    strings <file> | grep <pattern> - [`strings`: Display printable strings in binary files.]
    ```

  - Examples:

    ```bash
    man ulimit | grep -E -C 8 "^[[:blank:]]*ulimit"

    # Search for `Input Record Separator`:
    man awk | col -b | grep -iE "\brs\b" -C 1

    cat /etc/passwd | grep user | cut -d: -f1,3,6 | sed -ier 's/:/ /g'
    # `-i`: Edit file with its in-placec content.
    # `-r`: Regex or Extended-regex syntax accepted.
    # `-e`: Add the inherited script to the command to execute. 

    # `OFS` := Output Field Separator.
    ps aux | awk '{ print $2, $11 }' OFS='\t' | grep -i java

    # Retrieves all environment variables currently applied for a process.
    strings /proc/<pid>/environ
    ```

- Pipe:

  - Definition: The pipe (`|`) means take the `standard output` from the `preceding command` and `pass` it as the `standard input` to the `following command`.
  - Canonically, you will notice that 2 commands have been chained together with a vertical bar (`|`).

  - Exp:

    ```bash
    cat /etc/passwd | grep <user> | cut -d: -f1,6,7 | sed 's/:/ /g'
                                         |   |
                                         |   +----------------------> `-f <N>`     := displays the `Nth` field.
                                         +--------------------------> `-d <delim>` := uses delimiter as the field separator.
    ```

- Sorting data: in the simplest form, `sort` sorts lines of text alphabetically.

  ```bash
  [Syntax]
  sort <file> - [Sort text in file.]
  sort -k [F] <file> - [Sort by key. The `F` following `-k` is the field number.]
  sort -r <file> - [Sort in reverse order.]
  sort -u <file> - [Sort text in file, removing duplicate lines.]
  sort -t <file> - [Use SEP/separator instead of non-blank to blank transition.]
  ```

- Creating a Collection of files:

  - Definition: bundle a group of files/directories together in an archive.

    ```bash
    [Syntax]
    tar [-] c|x|t f <tarfile> [pattern] - [Create, extract or list contents of a `tar` archive using pattern, if supplied.]

    c - Create a tar archive.
    x - Extract files from the archive.
    t - Display the table of contents (list) of an archive.
    v - Causes tar to be verbose.
    f <file> - The tar archive file to perform operations against.
    z - Filter archive through compress (ie: gzip).
    ```

  - Exp:

    ```bash
    # Create a new tar archive:
    $ tar zcf something.tgz *.txt

    # Create a new tar archive in verbose mode:
    $ tar zcvf something.tgz *.txt
    a.txt
    bash_grammar.txt
    notes.txt

    # List contents of an archive:
    $ tar ztf something.tgz
    a.txt
    bash_grammar.txt
    notes.txt
    ```

- Compressing files to save space: `gzip`, `gunzip`.

  - Syntax and convention of compressing files process:

    ```bash
    [Syntax]
    gzip file - [Compress file. The resulting compressed file is named file.gz.]
    gunzip file - [Uncompress files.]
    gzcat / zcat - [Concatenates and prints compressed files.]

    Use the command `du` to display how much space is used by a file:
    du - [Estimates file usage.]
    du -k - [Display sizes in Kilobytes.]
    du -h - [Display sizes in human readable format. For example, 1.2M, 3.7G, etc.]
    ```

  - Examples:

    - When run across an older version of `tar` without `gzip` compression built-in -> can use pipes to create compressed archive:

      ```bash
      # `.tar.gz` or `.tgz`: compress `tar` archive to a zipped file.
      tar cf - *.txt | gzip > test.tgz
      ```

- Redirection:

  - Common:

    | I/O Name        | Abbreviation File | Descriptor Number |
    | :-------------- | :---------------- | :---------------: |
    | standard input  | stdin             |         0         |
    | standard output | stdout            |         1         |
    | standard error  | stderr            |         2         |

  - Standard Output Redirection:

    | Operation | Description                                                                                                                         |
    | :-------- | :---------------------------------------------------------------------------------------------------------------------------------- |
    | >         | Redirects standard output to a file, overwriting (truncating) any existing contents of the file. If no file exists, it creates one. |
    | >>        | Redirects standard output to a file and appends to any existing contents. If no file exists, it creates one.                        |
    | <         | Redirects input from a file to the command preceding the less-than sign.                                                            |

  - Standard Error Redirection:

    - `File descriptor 1` is the default file descriptor for output redirection.
    - By using the default file descriptor for output redirection may cause some misbehaviors/miscaptured output generated by a program.
    - If you want to capture both `stdout` and `stderr`, use `2>&1`.
    - If you want to use a file descriptor instead of a file name, use the ampersand `&` symbol.

    - Example:

      ```bash
      ls ./not_exist_file 2>out.err                  := redirect `stderr` to a file.
      ls ./not_exist_file ./exist_dir >out.both 2>&1 := redirect `stderr` to `stdout`. If you omit `&`, `1` will be treated as a file name 1.
                                                     := send the `stdout` of `ls ./not_exist_file ./exist_dir` to `out.both` after appending `stderr` to `stdout`.
      ```

    | Operation   | Description                                                                                  |
    | :---------- | :------------------------------------------------------------------------------------------- |
    | &           | Used with redirection to signal that a file descriptor is being used instead of a file name. |
    | 2>&1        | Combine standard error and standard output.                                                  |
    | 2> \<file\> | Redirect standard error to a file.                                                           |

- Null Device:

  - `>/dev/null` - [Redirect output to nowhere.]
  - Goal: ignore `stdout` and send it to null device, `/dev/null`. The null device is a special file that throws away whatever is fed to it.
  - `/dev/null` null device can be refer as the bit bucket.

  - Examples:

    ```bash
    $ ls ./not_exist_dir ./exist_file 2>/dev/null
    ./exist_file

    $ ls ./not_exist_dir ./exist_file >/dev/null 2>&1
    <return nothing>
    ```

- [Here Document](https://en.wikipedia.org/wiki/Here_document): (here-document, heredoc, here-text, hereis, here-string, and here-script)

  - Definition: is a file literal or input stream literal, it is a section of a source code/normal text file that is treated as if it were separated file.
    Also applied for multiline string literals that use similar syntax, preserving line breaks and whitespace (indentation).

  - Examples:

    ```bash
    $ LANG=C tr a-z A-Z <<DOC
    > one two three
    > DOC
    ONE TWO THREE
    ```

    ```bash
    $ cat <<DOC
    > Current directory: $PWD or `pwd`.
    > DOC
    Current directory: /home/user or /home/user.
    ```

    ```bash
    $ tr a-z A-Z <<-DOC
    > <<-:
    >   tabs are ignored.
    >  spaces are preserved.
    > DOC
    <<-:
    tabs are ignored
     spaces are preserved.
    ```

    ```bash
    $ cat << EOF > ~/test.txt
    > redirect heredoc content to a new file.
    > EOF
    ```

    ```bash
    $ tr a-z A-Z <<< 'this is a herestring.'
    THIS IS A HERESTRING.
    ```

    ```bash
    $ tr a-z A-Z <<< "this is
    > a here string."
    THIS IS
    A HERESTRING
    ```

    ```bash
    $ bc <<< 2^10
    1024
    ```

    ```bash
    $ read -r a b c <<< 'one two three'
    $ printf "%s\n%s\n%s\n" $a $b $c
    one
    two
    three
    ```

  - NOTE:

    - `herestring` versus `heredoc`: `herestring` does not use delimiters such as leading (`^`) and trailing (`$`) newlines.
    - `herestring` is particularly useful for commands that often take short input, such as the calculator command `bc`.
    - `herestring` is particularly useful when last command needs to run in the current process, such as in the case with the builtin command `read`.

- Transfer file between local machine and remote host:

  - `scp`: secure copy (remote file copy program).

    ```bash
    [Syntax]
    [Stand at Remote Host]
    scp -P[portnumber] file_at_remote_host [local_user]@[local_ip_address]:/your/path/

    [Stand at Local]
    scp -P[portnumber] [remote_user]@[remote_ip_address]:/remote/path/file_at_remote_host /your/path/
    ```

  - `sftp`: secure file transfer program. After `sftp` into the remote shell, execute `help` or `?` to get the list of all available commands.

    ```bash
    sftp -P[portnumber] [remote_user]@[remote_ip_address]
    ```

  - Example: transfer file from remote host to local machine when you're standing on the local side.

    ```bash
    scp -P 22 user@10.10.10.10:~/.bashrc ./bashrc_tmp

    sftp -P 22 user@10.10.10.10
    sftp> get /path/to/remote_file # Will download your wishes file to the current local directory.
    ```

    ```batch
    @REM [Similar in Windows]
    scp -P 22 user@10.10.10.10:~/tmp/scripts/* C:\Users\user\tmp
    ```

- Bash Shell manipulation:

  - Customizing the Prompt: by modifying the builtin system variable `$PS1` in Linux.

    | Symbol | Explanation                                                                         |
    | :----- | :---------------------------------------------------------------------------------- |
    | \d     | The date in "Weekday Month Date" format (e.g., "Tue May 26").                       |
    | \h     | The hostname up to the first '.'.                                                   |
    | \H     | The hostname.                                                                       |
    | \n     | Newline.                                                                            |
    | \t     | The current time in 24-hour HH:MM:SS format.                                        |
    | \T     | The current time in 12-hour HH:MM:SS format.                                        |
    | \@     | The current time in 12-hour am/pm format.                                           |
    | \A     | The current time in 24-hour HH:MM format.                                           |
    | \u     | The username of the current user.                                                   |
    | \w     | The current working directory, with $HOME abbreviated with a tilde.                 |
    | \W     | The basename of the current working directory, with $HOME abbreviated with a tilde. |
    | \$     | If the effective UID is `0`, a `#`, otherwise a `$`.                                |

  - `Interactive ~ Login` and `Non-interactive ~ Non-login` Sessions:

    - Distinguish: An `Interactive` session have been started when you had logged on the remote shell environment. A `Non-interactive` session is when you just `ssh` in, to run an exact one command.
    - The content of `.profile` and `.bash_profile` are only executed for interactive sessions.
    - To avoid the hassle when interactive and non-interactive sessions behave divergent/opposed, configure `.bash_profile` to reference `.bashrc` and put all the configurations in `.bashrc`.

    - Example:

      ```bash
      [.bash_profile]

      if [ -f ~/.bashrc ]; do
        source ~/.bashrc |& . ~/.bashrc
      fi
      ```

  - Shell History:

    - History files: `[ ~/.bash_history, ~/.history, ~/.zsh_history ]`.
    - Access to shell history to repeat commands via keystrokes:

      | Command      | Description                                               |
      | :----------- | :-------------------------------------------------------- |
      | `history`    | Display a list of commands in shell history.              |
      | `!N`         | Repeat command `number N`.                                |
      | `!-N`        | Execute the `Nth` previous command.                       |
      | `!!` ~ `!-1` | Repeat the previous command line.                         |
      | `!string`    | Repeat the most recent command start with `string`.       |
      | Ctrl + r     | Reverse search. Search for command in your shell history. |

  - Shell Command Line Editing: shell such as `bash`, `ksh`, `tcsh`, and `zsh` provide 2 command line editing modes. They are `emacs`, which is typically default mode, and `vi`.

    - Emacs: `Ctrl + e` - Move to the end of the line.
    - Vi:

      - `A` ~ Enter insert mode, append text at end of line.
      - `I` ~ Enter insert edit mode, prepend text to start of line.
      - `v` ~ Edit the current command line in the editor defined by the `$EDITOR` environment variable.

    | Shell | Emacs Mode     | Vi Mode      | Default mode |
    | ----- | -------------- | ------------ | ------------ |
    | bash  | `set -o emacs` | `set -o vi`  | emacs        |
    | ksh   | `set -o emacs` | `set -o vi`  | none         |
    | tcsh  | `bindkey -e`   | `bindkey -v` | emacs        |
    | zsh   | `bindkey -e`   | `bindkey -v` | emacs        |
    | zsh   | `set -o emacs` | `set -o vi`  | emacs        |

  - Environment Variables:

    - Common Variables:

      | Variable | Description                                                   |
      | :------- | :------------------------------------------------------------ |
      | EDITOR   | The program to run to perform edits.                          |
      | HOME     | The Home directory of the user.                               |
      | LOGNAME  | The login name of the user.                                   |
      | MAIL     | The location of the user's local inbox.                       |
      | OLDPWD   | The previous working directory.                               |
      | PATH     | A colon separated list of directories to search for commands. |
      | PAGER    | This program may be called to view a file.                    |
      | PS1      | The primary prompt string.                                    |
      | PWD      | The present working directory.                                |
      | USER     | The username of the user.                                     |

    - View Variables:

      ```bash
      $ printenv HOME
      /home/user

      $ printenv
      TERM=xterm-256color
      SHELL=/bin/bash
      USER=user
      PATH=/usr/local/bin:/usr/bin:/bin
      MAIL=/var/mail/user
      PWD=/home/user
      LANG=en_US.UTF-8
      HOME=/home/user
      LOGNAME=user

      $ env
      TERM=xterm-256color
      SHELL=/bin/bash
      USER=user
      PATH=/usr/local/bin:/usr/bin:/bin
      MAIL=/var/mail/user
      PWD=/home/user
      LANG=en_US.UTF-8
      HOME=/home/user
      LOGNAME=user

      $ export PAGER=less
      $ echo $PAGER
      less

      $ unset PAGER
      $ echo $PAGER
      <return nothing>
      ```

- Processes and Job control:

  - Listing Processes and Displaying information:

    - To display the currently running processes we use the `ps` command. If no options are specified, it will displays the processes associated with our current session.
    - Common options and examples :

      ```bash
      [Syntax]
      ps - [Display process status.]

      -e - Everything, all processes. Identical to -A.
      -f - Full format listing.
      -u <username> - Display processes running as username.
      -p <pid> - Display process info rmation for <pid>. A PID is a process ID.
      ```

      ```bash
      [Examples]
      ps -e - [Display all processes.]
      ps -ef - [Display all processes with full format listing.]
      ps -eH - [Display a process tree.]
      ps -e --forest - [Display a process tree.]
      ps -u <username> - [Display processes running by username.]
      ps -fu <username> - [Display processes running by username in full format listing.]
      ```

    - Some other commands that allow user to view running processes:

      ```bash
      pstree - Display running processes in a tree format.
      htop - Interactive process viewer. This command is less common than `top` and may not be available on the system.
      top - Interactive process viewer.
      ```

  - Running Processes in the Foreground and Background:

    - When a command, process or programs is running in the foreground the shell prompt will not be displayed until that process exits.
    - For long duration and stable running program/process it can be convinient to send them to the background.
      Processes that are backgrounded still execute and perform their task without blocking user from entering further commands at the shell prompt.
    - To background a process, place an ampersand `&` at the end of the command: `[%num]` is the job number corresponded to each job in the `jobs` command output.
    - The plus sign (`+`) in the jobs output represents the `current job` while the minus sign (`-`) represents the `previous job`.
    - The `current job` is considered to be the "last job that was stopped while it was in the foreground" or the "last job started in the background".
      The `current job` can be referred to by `%%` or `%+`.
    - If no job information is supplied to the `fg` or `bg` commands, the current job is operated upon.
      The `previous job` can be referred to by `%-`.

    | Command       | Description                              |
    | :------------ | :--------------------------------------- |
    | `<command> &` | Start command in the background.         |
    | Ctrl + c      | Kill the foreground process.             |
    | Ctrl + z      | Pause or suspend the foreground process. |
    | `bg [%num]`   | Background a suspended process.          |
    | `fg [%num]`   | Foreground a background process.         |
    | `kill [%num]` | Kill a process by job number or PID.     |
    | `jobs [%num]` | List jobs.                               |

    ```bash
    [Examples]
    $ ./long-running-program &
    [1] 22686
     |  |-----> Process ID.
     |--------> Job number.

    $ ps -p 22686
      PID TTY       TIME CMD
    22686 pts/1 00:00:00 long-running-pr

    $ jobs
    [1]+ Running ./long-running-program &

    $ fg
    ./long-running-program

    $ ./long-running-program &
    [1] 22703
    $ ./long-running-program &
    [2] 22705
    $ ./long-running-program &
    [3] 22707
    $ ./long-running-program &
    [4] 22709
    $ jobs
    [1]  Done    ./long-running-program
    [2]  Done    ./long-running-program
    [3]- Running ./long-running-program & # ---> Previous job.
    [4]+ Running ./long-running-program & # ---> Current job.

    $ fg %3
    ./long-running-program

    # Foreground current job:
    $ %% # Or: [ %+ || fg || fg %% || fg %+ || fg %4 ].
    ./long-running-program

    # Pause or suspend job, after that start again:
    $ jobs
    [1]  Running   ./long-running-program &
    [2]- Running   ./long-running-program &
    [3]+ Running   ./another-program &
    $ fg %%
    ./another_program
    ^Z # Ctrl + z
    [3]+ Stopped ./another-program
    $ bg %3
    [3]+ ./another-program &
    $ jobs
    [1]  Running   ./long-running-program &
    [2]- Running   ./long-running-program &
    [3]+ Running   ./another-program &

    # Kill a background job:
    $ kill %1
    [1] Terminated ./long-running-program &
    $ jobs
    [2]- Running   ./long-running-program &
    [3]+ Running   ./another-program &
    # Kill a foreground job:
    $ fg %2
    ./long-running-program
    ^C # Ctrl + c
    $ jobs
    [3]+ Running   ./another-program &
    ```

  - [Killing processes](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Builtins.html):

    - The default signal used by `kill` command is termination. This signal referred to as `SIGTERM` or `TERM` for short.
    - Signals have numbers that correspond to their name. The default `TERM` signal is 15, so these 3 commands below are equivalent:

      ```bash
      kill <pid>
      kill -15 <pid>
      kill -TERM <pid>
      ```

    - Some basic cammand and keystroke:

      | Command               | Description                   |
      | :-------------------- | :---------------------------- |
      | Ctrl + c              | Kills the foreground process. |
      | `kill [signal] <pid>` | Send a signal to a process.   |
      | `kill -l`             | List of all signals.          |

    - Examples:

      ```bash
      # KILL/SIGKILL signal is number 9:
      $ ps | grep hard-to-stop
      27398 pts/1 00:00:00 hard-to-stop
      $  kill -9 27398 # Send SIGKILL to process "hard-to-stop".
      $ ps | grep hard-to-stop
      <return nothing>
      ```

- Scheduling Repeated Jobs with [cron](https://crontab.guru/):

  - Definition:

    > - `cron`: A time based job scheduling service. This service typically started when the system boots.
    > - `crontab`: A program to create, read, update, and delete your job shcedules. `Crontab` (`cron` table) is a configuration file that specifies when commands are to be executed by `cron`.
    >   Each line in a `crontab` represents a job and contains 2 pieces of information: 1) when to run and 2) what to run.

  - `Crontab` format:

    ```bash
    # An asterisk (*) which matches any time or date for that field.
    * * * * * <command>
    | | | | |
    | | | | +--> Day of the Week (0-6) (0: Sunday)
    | | | +----> Month of the Year (1-12)
    | | +------> Day of the Month (1-31)
    | +--------> Hour (0-23)
    +----------> Minute (0-59)
    ```

    ```bash
    [Examples]
    # Run every Monday at 07:00.
    0 7 * * 1 /opt/sales/bin/weekly-report

    # Run every 30 minutes.
    0,30 * * * * /opt/acme/bin/half-hour-check
    # Another way to do the same thing.
    */30 * * * * /opt/acme/bin/half-hour-check

    # Run in range 06:00 to 09:00.
    * 6-9 * * * ~/test/six-to-nine-hour-check
    ```

    | Common keywords | Keyword   | Description                                                 | Equivalent    |
    | :-------------- | :-------- | :---------------------------------------------------------- | :------------ |
    |                 | \*        | Any value.                                                  |               |
    |                 | ,         | Value list separator.                                       |               |
    |                 | -         | Range of values.                                            |               |
    |                 | /         | Step values.                                                |               |
    |                 | @yearly   | Once a year at midnight January 1.                          | 0 0 1 1 \*    |
    |                 | @annually | Same as @yearly.                                            | 0 0 1 1 \*    |
    |                 | @monthly  | Run once a month at midnight of the first day of the month. | 0 0 1 \* \*   |
    |                 | @weekly   | Run once a week at midnight in the morning of Sunday.       | 0 0 \* \* 0   |
    |                 | @daily    | Run once a day at midnight.                                 | 0 0 \* \* \*  |
    |                 | @midnight | Same as @daily.                                             | 0 0 \* \* \*  |
    |                 | @daily    | Run once an hour at the beginning of the hour.              | 0 \* \* \* \* |
    |                 | @daily    | Run at startup.                                             | N/A           |

    ```bash
    [Full follow create new `cronjob`]

    $ vi test-cron.sh
    # [test-cron.sh]
    #! /bin/bash
    filename="test-cron-cmd"

    # Exp: single quotes will turn variable into string, with '$filename' -> will create exact: "~/tmp/$filename".
    if [[ ! -f ~/tmp/$filename ]]; then
      touch ~/tmp/$filename
    else
      date >>~/tmp/$filename 2>&1
    fi

    # [test-cron]
    # Run every 1 minute:
    # */1 * * * * ~/tmp/scripts/test-cron >> ~/tmp/test-cron.log 2>&1 ---> Error case.
    */1 * * * * ~/tmp/scripts/test-cron.sh >>~/tmp/test-cron.log 2>&1

    $ crontab test-cron
    $ crontab -l
    # Run every 1 minute:
    # */1 * * * * ~/tmp/scripts/test-cron >> ~/tmp/test-cron.log 2>&1 ---> Error case.
    */1 * * * * ~/tmp/scripts/test-cron.sh >>~/tmp/test-cron.log 2>&1

    $ crontab -e # Edit cronjob.

    # [test-cron-cmd]
    $ cat test-cron-cmd
    Tue Aug 18 19:04:01 +07 2022
    Tue Aug 18 19:05:01 +07 2022
    Tue Aug 18 19:06:02 +07 2022
    Tue Aug 18 19:07:01 +07 2022
    Tue Aug 18 19:08:01 +07 2022
    Tue Aug 18 19:09:01 +07 2022
    Tue Aug 18 19:10:01 +07 2022
    Tue Aug 18 19:11:01 +07 2022
    Tue Aug 18 19:12:01 +07 2022

    # [test-cron.log]
    $ cat test-cron.log
    /home/user/tmp/scripts/test-cron: line 3: */1: No such file or directory

    $ crontab -r # Remove current cronjob.
    ```

- Switching Users and Running Commands as others:

  - `su`: one way to start session as other user on the system us to use the `su` command. Executing naked `su` is the same as executing `su root`.

  ```bash
  [Syntax]
  su [username] - [Change user ID or become superuser.]

  `-` - A hyphen is used to provide an environment similar to what the user would expected as same as when they were logged in directly.
  -c <comamnd> - Specify command to be executed. If the command contains more than onw word length, it needs to be quoted.
  ```

  ```bash
  [Syntax]
  whoami - [Displays the effective username.]
  who - [Show who is logged on with more details.]
  ```

  - `sudo`: Super User Do, another way to switch users or execute commands as others is to use the `sudo` command.
    `sudo` allows you to run programs with the security privileges of another user. Like `su`, if no username is specified it assumes you are trying to run commands as the superuser.
  - It is commonly used to install, start, and stop applications that require superuser privileges.

  ```bash
  [Syntax]
  sudo - [Execute a command as another user, typically the superuser.]

  sudo -l - List available commands.
  sudo command - Run command as the superuser.
  sudo -u root command - Same as sudo command.
  sudo -u user command - Run command as user.
  sudo su - Switch to the superuser account.
  sudo su - - Switch to the superuser account with an environment like you
  would expect to see had you logged in as that user.
  sudo su - username - Switch to the username account with an environment like you would expect to see had you logged in as that user.
  ```

  - `sudo` will not prompt for a password for the commands preceded with `NOPASSWD` from output of the command `sudo -l`.
    This type of configuration may be required to automate jobs via `cron` that require escalated privileges.

- Installing Software:

  - Explanation: Typically, when you install software on Linux system you do so with a package. A package is a collection of files that make up an application.
    Additionally, a package contains data about the application as well as any steps required to install or remove that application.
  - The data, or metadata, that contained within a package can include information such as the description, version, and list of other packages that it depends on.
    In order to install or remove a package you need to use superuser privileges.
  - A `package manager` is used to install, upgrade, and remove packages. Any additional software that is required for a package to function properly is known as a dependency.
  - The package manager uses a package's metadata to automatically install the dependencies.
    Package managers keep track of what files belong to what packages, what packages are installed, and what versions of those packages are installed.

  - Table of common commands for well-known Linux distribution package manager:

    | Distribution           | Package Manager | Commands                         | Description                                                                             |
    | :--------------------- | :-------------: | :------------------------------- | :-------------------------------------------------------------------------------------- |
    | CentOS, Fedora, RedHat |      `yum`      | `yum search <keyword>`           | Search for package name akin with \<keyword\>.                                          |
    |                        |                 | `yum install [-y] <package>`     | Install package. `-y` option equal to automatically answer yes to `yum`'s question.     |
    |                        |                 | `yum remove <package>`           | Remove/uninstall package.                                                               |
    |                        |                 | `yum info [package] `            | Display information about package.                                                      |
    |                        |      `rpm`      | `rpm -qa`                        | List all the installed packages.                                                        |
    |                        |                 | `rpm -qf /path/to/file`          | List the package that contains file.                                                    |
    |                        |                 | `rpm -ivh <package>.rpm`         | Install a package from the file named \<package\>.rpm.                                  |
    |                        |                 | `rpm -ql <package>`              | List all files that belong to \<package\>.                                              |
    | Debian, Ubuntu         |      `apt`      | `apt-cache search <keyword>`     | Search for package name akin with \<keyword\>.                                          |
    |                        |                 | `apt-get install [-y] <package>` | Install package. `-y` option equal to automatically answer yes to `apt-get`'s question. |
    |                        |                 | `apt-get remove <package>`       | Remove/uninstall \<package\>, leaving behind configuration files.                       |
    |                        |                 | `apt-get purge <package>`        | Remove/uninstall \<package\>, deleting configuration files.                             |
    |                        |                 | `apt-cache show <package>`       | Display information about \<package\>.                                                  |
    |                        |     `dpkg`      | `dpkg -l`                        | List all the installed packages.                                                        |
    |                        |                 | `dpkg -S /path/to/file`          | List the package that contains file.                                                    |
    |                        |                 | `dpkg -i <package>.deb`          | Install a package from the file named \<package\>.deb.                                  |
    |                        |                 | `dpkg -L package`                | List all files that belong to \<package\>.                                              |

- More `grep` options to be dived in:

- `grep -o`: -o ~ --only-matching, print only the matched parts of a matching line, with each matched part on a separate output line.
- `grep -A <NUM>`: -A ~ --after-context, print `<NUM>` lines of trailing context after matching lines.
- `grep -B <NUM>`: -B ~ --before-context, print `<NUM>` lines of trailing context before matching lines.
- `grep -C <NUM>`: -C ~ --context, print `<NUM>` lines of output expanded in both up/down direction started from the matched context.

```bash
man ascii | grep -A 20 Tables
```

- Services listing distinguish between `SysV` and `systemd`:

- `SysV` services only (does not include the native `systemd` services):

```bash
chkconfig
```

- `systemd` services:

  + List all services:

  ```bash
  systemctl list-units
  systemctl list-unit-files
  systemctl list-units --type=service --state=active
  ```

  + List all services enabled on particular target: `[target]` can be found in the output of `systemctl list-unit-files`

  ```bash
  systemctl list-dependencies [target]
  systemctl list-dependencies sysinit.target
  ```

  + List of status reportation from a specific sercvice: (`/dev/sda` equivalent with and `dev-sda.device` and so on)

  ```bash
  systemctl status /dev/sda
  systemctl status dev-sda.device

  systemctl status /home
  systemctl status home.mount
  ```

- Some more `systemctl` options utilities:

```bash
systemctl list-jobs --all
systemctl list-sockets --all
systemctl list-timers --all
```

- The function `splitPath` is using only for current user profile, to see all system path, using:

```bash
systemd-path
```

- Retrieving log report from a service in a range of time:

```bash
journalctl --unit=home.mount --no-pager --since "1 week ago" | grep -i error
journalctl --unit=dev-sda.device --no-pager --since "1 week ago" | grep -i error
```

- A curated table of `Escape Sequence` characters:

```
+===================================================================+
| Escape Sequence | Unicode Character | Description                 |
+=================+===================+=============================+
|        \b       |       U+0008      | BS backspace                |
+-----------------+-------------------+-----------------------------+
|        \t       |       U+0009      | HT horizontal tab           |
+-----------------+-------------------+-----------------------------+
|        \n       |       U+000A      | LF line feed                |
+-----------------+-------------------+-----------------------------+
|        \f       |       U+000C      | FF form feed                |
+-----------------+-------------------+-----------------------------+
|        \r       |       U+000D      | CR carriage return          |
+-----------------+-------------------+-----------------------------+
|        \"       |       U+0022      | quotation mark              |
+-----------------+-------------------+-----------------------------+
|        \'       |       U+0027      | apostrophe                  |
+-----------------+-------------------+-----------------------------+
|        \/       |       U+002F      | slash (solidus)             |
+-----------------+-------------------+-----------------------------+
|        \\       |       U+005C      | backslash (reverse          |
|                 |                   | solidus)                    |
+-----------------+-------------------+-----------------------------+
|      \uXXXX     |       U+XXXX      | unicode character           |
+-----------------+-------------------+-----------------------------+
```

- Process management:

- All of these signal process interaction command can be found in:

```bash
$ man 7 signal

Sending a signal
  The following system calls and library functions allow the caller to send a signal:

  raise(3)          Sends a signal to the calling thread.
  kill(2)           Sends a signal to a specified process, to all members of a specified process group, or to all processes on the system.
  killpg(2)         Sends a signal to all of the members of a specified process group.
  pthread_kill(3)   Sends a signal to a specified POSIX thread in the same process as the caller.
  tgkill(2)         Sends a signal to a specified thread within a specific process.  (This is the system call used to implement pthread_kill(3).)
  sigqueue(3)       Sends a real-time signal with accompanying data to a specified process.
```

- `ps` report snapshot of all current processes:

```bash
ps -fax
ps -aux
ps -ax -o %U%p%n%c
```

NOTE: the syntax `%U%p%n%c` corresponded with `USER PID NI COMMAND`.

- `netstat`: `ss` is the new version of `netstat`, lack some features, but exposes more TCP states and slightly faster.

```bash
netstat -tulpn | grep :22
ss -tulpn | grep 443
```

  > + -t - Show TCP ports.
  > + -u - Show UDP ports.
  > + -n - Show numerical addresses instead of resolving hosts.
  > + -l - Show only listening ports.
  > + -p - Show the PID and name of the listener’s process. This information is shown only if you run the command as root or sudo user.

- `lsof`: provides information about files opened by processes.

```bash
lsof -i tcp:8008
lsof -t -i tcp:8080
lsof -nP -iTCP -sTCP:LISTEN
```

  > + `-p`: Do not resolve hostnames, show numerical addresses.
  > + `-iTCP -sTCP:LISTEN`: Show only network files with TCP state LISTEN.
  > + `-i`: Selects the listing of files any pf whose Internet address matched the address specified in `-i`.
  > + `-t`: Specifies that lsof should produce terse output with process identifiers only, without any extra-information.
  > + `-n`: Inhibits/publishes the conversion/parser of network numbers to hostnames for network files.
  > + `-n`: Do not convert port numbers to port names.
  > + `-T[a/f/g/K]: Controls the reporting output of some TCP/IP information, also reported by `netstat`.
  >   + `a`: file access mode.
  >   + `f`: file descriptor.
  >   + `g`: process group ID.
  >   + `K`: task ID.

- Resources: (NOTE: options/values inside square brackets `[`, `]` is optional.)

  - [Permanently export environment variable Linux](https://stackoverflow.com/questions/13046624/how-to-permanently-export-a-variable-in-linux)
