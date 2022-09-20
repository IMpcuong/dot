# This is an archive of some awesome `git` command I have been collected!

## Resources:

- [Gist git-bash commands](https://gist.github.com/etoxin/1acb257550b1de60fe99)
- [https://stephencharlesweiss.com](https://stephencharlesweiss.com/git-rebase-interactive)
- [StackOverflow](https://stackoverflow.com/questions/15798862/what-does-git-rev-parse-do)

## Feel free to make this archive become even larger and more useful.

1. `git clone`:

- Clone specific branch:

```git
git clone -b BRANCH_NAME --single-branch git@github.com:USERNAME/REPO.git
```

- NOTE:

> - Eg: you clone only one branch (`dev`) from a remote server.
>
> ```git
> git clone -b dev --single-branch <repo_https_url>
> ```
>
> - In the `.git/config` you will see: that mean you can only interact with `dev` remote branch.
>
> ```.gitconfig
> [remote "origin"]
>   url = <repo_https_url>
>   fetch = +refs/heads/dev:refs/remotes/origin/dev
> ```
>
> -> You can change this to normal behavior with this command:
>
> ```git
> git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
> ```

- Clone project in the specific port: (NOTE: the square bracket is not needing)

```git
git clone ssh://git@mydomain.com:[port]/USERNAME/REPO.git
```

2. `git log/reflog`:

- This is some beautify _log/reflog_ commands. Try it yourself!

```bash
# All activities in historical order:
git reflog

# Logging with maximum output records constraint.
git log --oneline -10

# Logging with decoration formatting:
git log --oneline --graph
git log --oneline --decorate
git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short

# Logging with list of changed filenames per commit only:
git log --oneline --name-only
```

- Some `log` commands I just find out recently, really cool stuff:

```git
git shortlog -e -s -n HEAD
git log -L <start_line>,<end_line>:FILENAME --full-history --pretty=oneline --date-order --decorate=full --skip=0 --max-count=10
```

- Retrieve the latest commit message:

```git
git log --format=%B -n 1 HEAD
```

NOTE: The second one is really fascinating, it shows the changed parts in the specified file
from start to end lines.

- Searching and listing all commits in a interval of time:

```git
git log --after="4 week" --before="0 week" --oneline
git log --after="4 week" --before="0 week" --oneline | Measure-Object
git log --after="4 week" --before="0 week" --oneline | findstr <commit_hash>
```

- Logging the specific file with a given path:

```git
git log --follow --oneline -- <file_path>
```

- Showing the different between two branches: almost have the same effectiveness as the `git diff`.

```bash
git log --oneline --graph --decorate --abbrev-commit <BRANCH_NAME1>..<BRANCH_NAME2>
```

- Showing only datetime created of a commit by using its hash abbreviation:

```bash
# `%cd` := created date.
git show --no-patch --no-notes --pretty="%cd" <commit_hash>

# `%h` := hash summary.
# `%s` := commit's subject message.
git show --no-patch --no-notes --pretty="%h %cd %s" <commit_hash>
```

3. `git add`:

- Add all the changes:

```git
git add -A .
```

- Add all the indexed changes:

```git
git add -u
```

- Add all the indexed changes in interactive mode:

```git
git add -p
git add --patch
```

4. `git commit`:

- Modify latest commit message:

```git
git commit --amend -m YOUR_MESSAGE
```

- Use latest message commit instead of creating a new one:

```git
git commit --amend --no-edit
```

- NOTE:

> - After you `commit --amend --no-edit` -> then you don't want to `push` the update hash of amended commit
>   -> you can using `pull --amend` first -> then you don't have to `push -f` in your next push session.

5. `git push`:

- Using this shortcut instead of forcing to push the latest commit:

From:

```git
git push -f origin main
```

to:

```git
git push origin +@:main
git push origin +HEAD:main
```

- Push/pull within a up-to-date circle with the current upstream branch:

```git
git push --set-upstream origin HEAD
git push -u origin HEAD
```

Note: `HEAD` equal with `@`

6. `git pull/fetch`:

- `git fetch`: update local indexes updated with the remote repository.

```git
git fetch --prune
git -c diff.mnemonicprefix=false -c core.quotepath=false fetch origin
```

- `git pull`: pull new branch without checkout in local first (both have same utility).

```git
git pull origin develop:develop
git checkout origin/BRANCH -b BRANCH
```

- Pull and rebase if the current branch is busy:

```git
git config --global branch.autosetuprebase always
git pull --rebase REMOTE_BRANCH LOCAL_BRANCH
```

- I'm not test this command yet (?) -> tested done, quite useful command:

```git
git pull -s recursive -X origin
```

- NOTE: `pull --rebase`

> - Applied your commit on top of the remote commit (in the top of HEAD).
> - Careful, as your commits will no longer be in choronological order, have rewritten the history.
> - `--global autosetuprebase`: auto setup rebase before pull remote commit.

7. `git stash`:

- Want to save all the changes and checkout to another branch:

```git
git stash
```

- Naming the current stash for easy pop changes later:

```git
git stash save "<text>"
```

- Want to pop the latest changes from the stack:

```git
git stash pop
```

- Want to show stash history from the stack:

```git
git stash show -p
git stash list
```

- And pop or apply the changes you want to rollback:

```git
git stash pop stash@{<STASH_INDEX>}
git stash apply stash@{<STASH_INDEX>}
```

- Or you can apply directly from index number in the stash tree:

```git
git stash apply --index <STASH_INDEX> -q
```

8. `git rebase`:

- Want to change the order of commits history of your current branch:

Step 1: to see the order of `HEAD`

```git
git reflog
```

Step 2: choose the position that you want to rebase from (e.g: `HEAD~8`)

```git
git rebase -i HEAD~8
```

Some options in popup interactive editor:
| Aliases | Full | Description |
|---|---|---|
| p | pick | use commit |
| r | reword | use and edit commit message |
| e | edit | use commit, stop for amending |
| s | squash | use commit, melt into previous commit |
| f | fixup | like 'squash', but discard commit's log |
| x | exec | run command |
| b | break | stop here (continue later with (1))
| d | drop | remove commit |
| l | label | label current HEAD with name |
| t | reset | reset HEAD to a label |

Step 3: changes the commit order or do anything with the options listed above.

After that, if you satisfy with the changes you have made, then:

```git
git rebase --continue (1)
```

or discard and exit the rebase process:

```git
git rebase --abort
```

9. `git ls-files`:

- List files using git instead of `ls` commands in your current shell:

```git
git ls-files
git --git-dir=./.git ls-files -oc --exclude-standard
```

10. `git grep`:

- Using `git grep` instead of `grep` or `rg` inside a `git` directory:

```git
git grep <text>
```

11. `gitk`

- Visualize current branch's history:

```git
gitk
```

12. `git mergetool`:

- This command used to fix the conflict happened between the merge commits
  process:

```git
git mergetool -t opendiff
```

- An interactive `vi` windows popup.
- Choose the left-hand side branch : `diffg LO`
- Choose the right-hand side branch : `diffg RE`
- Choose none of these above : `diffg BA`
- Quit this prompt and save our choice : `wq`

13. `git gc`

- `git gc` clean up unnecessary files and optimize the local repo

```git
git gc
```

14. `git delete` (kind of):

- Delete branch locally:

```git
git checkout ANOTHER_BRANCH
git branch -D BRANCH_NAME
```

- Delete remote branch:

```git
git push --delete origin BRANCH_NAME
```

15. `git branch`:

- Common commands:

```git
git branch -a
git branch -r
git branch -vv
git branch --contains COMMIT_HASH
```

- List all remote branches:

```git
git branch --remote
git ls-remote
```

- Search commit belonged to which source branch or coming from any action:

```bash
git branch -a --contains COMMIT_HASH
git reflog show --all | grep COMMIT_HASH

# NOTE:
git log -g --abbrev-commit --pretty=oneline
# and
git reflog show
# are 100 percent equivalent by semantic, the second one is just the alias for the precedent.
```

16. `git diff`

- List conflicts:

```git
git diff --name-only --diff-filter=U | rg "<<<"
```

- Show changes between 2 branches:

```git
git diff <branch_1> <branch_2>
git diff <branch_1>..<branch_2>
git diff --name-only <branch_name>..origin/<branch_name>
```

- Show list of files have been changed between 2 branches:

```git
git diff --name-status <branch_1>..<branch_2> >> changelog.txt
```

- Show change between 2 commits: (NOTE: `^` := plumbing operator)
- A revision range `A..B` for `git log` or `git diff` into the equivalent arguments
  for the underlying plumbing command as `B ^A`.

```git
git diff HEAD~1..HEAD~0
git diff HEAD~0 ^HEAD~1
```

- Show current modification that is not yet added in blob tree

```git
git diff --cached
```

- Show list filenames of all modified files in a specific commit hash:

```git
git diff-tree --no-commit-id --name-only -r <COMMIT_HASH>
```

17. `git checkout`

- Recover deleted branch:

```git
git checkout -b <BRANCH_NAME> <COMMIT_HASH>
```

- Revert the repo to latest changes has been applied:

```git
git checkout .
```

Have the same idea with the previous checkout command

```git
git restore --staged <FILES>
```

- Revert a file to most recent commit

```git
git checkout <path_to_file>
git checkout HEAD -- <path_to_file>
```

- Checkout to a file from another branch:

```git
git checkout origin/BRANCH_NAME -- <file_name>
```

18. `git reset` (BE CAREFUL WITH `git reset` !!!)

- Sweep the latest commit out of Earth:

```git
git reset --hard HEAD~1
```

- NOTE: recommendation because it's just revert the most recent changed file to un-staged status.

```git
git reset --soft HEAD~1
```

18. `git rev-parse`

- NOTE: `rev` stand for `revision`

- This is an ancillary/support `plumbing` (^) command used for manipulation purpose,
  one of the primary use cases is to print the `SHA1` hashes given a revision specific.

```git
git rev-parse HEAD
git rev-parse --short HEAD
```

Also works for getting the current branch name

```git
git rev-parse --abbrev-ref HEAD
```

- Some options: [--verify, --git-dir, --is-inside-git-dir, --is-inside-work-tree, --branches, --remote]

- If you want to find the latest commit in another branch:

```git
git rev-parse <local-branch-name>
git rev-parse origin/<remote-branch-name>
```

- Retrieve the remote's latest commit-hash:

```git
git rev-parse refs/remotes/origin/main^{commit}
```

19. `git remote`

- `git remote` add new remote repo:

```git
gir remote add origin git@github.com:<USERNAME>/<REPO>.git
```

- `git remote` set default URL to avoid asking username/passwords prompt popping off:

```git
git remote set-url origin git@github.com:<USERNAME>/<REPO>.git
git remote set-url origin https://github.com/<USERNAME>/<REPO>.git
```

20. `git config`:

- Basic commands:

```bash
# [Listing configurations]:
git config -l
git config --system --list
git config --global -l

# [Set/unset configurations]:
git config --global http.sslverify false
git config --global http.proxy <host>:<port>
git config --global https.proxy <host>:<port>
git config --global --unset http.proxy
git config --global --unset https.proxy

# [Alternative method for setting proxy in git]:
git -c "http.proxy=address:port" clone https://github.com/<username>/<repo>
```

- Forget old saved credentials, re-enter username and password as required:

```git
git credential-cache exit
git config --global credential.helper manager
git config --global credential.helper manager-core
```

NOTE: all the saved credentials can be found in here (`Control Panel\User Accounts\Credential Manager`)

- `git credential-manager`:

  - `--system` > `--global` > `--local`: (example belows)

```git
git config --system -e
git config --system credential.helper manger-core/wincred
git config --system --unset-all credential.helper
```

- `git config` set reference to remote URl:

```git
git config remote.origin.url <REMOTE_URL>
```

- We should add our credential informations with pattern like `git:domain` in the `credential-manager` window follow the form below:

```credential
username: <Git-SCM username>
password: <your_access_token>
```

21. `git switch`:

- You are in `detached HEAD` state. You can look around, make experimental
  changes and commit them, and you can discard any commits you make in this
  state without impacting any branches by switching back to a branch.

- If you want to create a new branch to retain commits you create, you may
  do so (now or later) by using `-c` with the switch command. Example:

```git
git switch -c <new-branch-name>
```

Or undo this operation with:

```git
git switch -
```

- Turn off this advice by setting config variable `advice.detachedHead` to `false`.

22. `git clean` and `git rm`:

- Remove untracked files: show files and directories will be deleted (dry run) -> then delete (interactive or forcing through)!

  - `-n` ~ perform a “dry run” and show you what files and directories will be deleted.
  - `-i` ~ delete in interactive mode.
  - `-d` ~ remove untracked directories.
  - `-f` ~ force delete the untracked files and directories.
  - `-x` ~ remove the all ignored and untracked files.
  - `-X` ~ remove only the ignored files and directories.

```bash
git clean -d -n
git clean -d -n src/
git clean -d -f
git clean -d -i
git clean -d -n -x
git clean -d -n -X
```

```bash
git worktree
git rm <tracked_files>
```

23. `git blame`: show what revision and author last modified each line of file.

```bash
# Include additional statistics at the end of blame output:
git blame --show-stats <filename>

# Show blank SHA-1 for boundary commits:
git blame -b <filename>

# Annotate only the line range given by <start>,<end>, or by the function name regex <funcname>:
# * number:
#   If <start> or <end> is a number, it specifies an absolute line number (lines count from 1).
#
# * /regex/:
#   This form will use the first line matching the given POSIX regex.
#   If <start> is a regex, it will search from the end of the previous -L range, if any, otherwise from the start of file.
#   If <start> is ^/regex/, it will search from the start of file. If <end> is a regex, it will search starting at the line given by <start>.
#
# * +offset or -offset
#   This is only valid for <end> and will specify a number of lines before or after the line given by <start>.
git blame -L <start>,<end>
git blame -L <start>,
git blame -L ,<end>
git blame -L :<funcname>
git blame -L ^:<funcname>
```

24. `git for-each-ref`: with the unique target is to order commit by most recent alteration.

- Resource: [Stackoverflow git-branches ordered by most recent commit][1]

[1]: https://stackoverflow.com/questions/5188320/how-can-i-get-a-list-of-git-branches-ordered-by-most-recent-commit

- Sorting by using `commiterdate`:

```bash
# [Local]:
git for-each-ref --sort=-committerdate refs/heads/

# Or using `git branch` (since version 2.7.0):
git branch --sort=-committerdate  # DESC
git branch --sort=committerdate  # ASC

# [Remote]:
git for-each-ref --sort=-committerdate refs/remotes/

# Show both remote and local branches order by timeline of latest commit itself:
git branch -va --sort=-committerdate  # DESC
git branch -va --sort=committerdate  # ASC

# Remote branches only:
git branch --remote --sort=-committerdate  # DESC
git branch --remote --sort=committerdate  # ASC
```

- Advance options for beautify format:

```git
[Local]
git for-each-ref --sort=-committerdate refs/heads/ \
  --format='%(authordate:short) %(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'

[Remote]
git for-each-ref --sort=-committerdate refs/remotes/ \
  --format='%(authordate:short) %(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
```

- Adding into `.gitconfig` or `.bashrc` for invoking command by using alias instead:

```toml
[.gitconfig]
[alias]
# ATTENTION: All aliases prefixed with `!` run in `/bin/sh` make sure you use sh syntax, not `bash/zsh` or whatever
recentb = """
  !r() { \
    refbranch=$1 count=$2; \
    git for-each-ref \
      --sort=-committerdate refs/heads \
      --format='%(refname:short)|%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:blue)%(subject)|%(color:magenta)%(authorname)%(color:reset)' \
      --color=always \
      --count=${count:-20} | \
      while read line; do branch=$(echo \"$line\" | \
        awk 'BEGIN { FS = \"|\" }; { print $1 }' | tr -d '*'); \
        ahead=$(git rev-list --count \"${refbranch:-origin/master}..${branch}\"); \
        behind=$(git rev-list --count \"${branch}..${refbranch:-origin/master}\"); \
        colorline=$(echo \"$line\" | sed 's/^[^|]*|//'); echo \"$ahead|$behind|$colorline\" | \
        awk -F'|' -vOFS='|' '{ $5=substr($5,1,70) }1'; \
      done | \
      ( echo \"ahead|behind||branch|lastcommit|message|author\\n\" && cat ) | \
      column -ts'|'; \
  }; r
"""
```

```bash
#!/bin/bash

alias r = `recentb`

### From: https://stackoverflow.com/questions/5188320/how-can-i-get-a-list-of-git-branches-ordered-by-most-recent-commit

# NOTE:
# - `refbranch` := which branch the ahead or behind columns are calculated against. Default is master.
# - `count` := how many recent branches to show. Default 20.
fucntion recentb() {
  local refbranch=$1 count=$2

  # `echo -e` := enable interpretation of backslash escapes.
  git for-each-ref \
    --sort=-committerdate refs/heads \
    --format='%(refname:short)|%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:blue)%(subject)|%(color:magenta)%(authorname)%(color:reset)' \
    --color=always \
    --count=${count:-20} | \
    while read line; do branch=$(echo "$line" | \
      awk 'BEGIN { FS = "|" }; { print $1 }' | tr -d '*'); \
      ahead=$(git rev-list --count "${refbranch:-origin/master}..${branch}"); \
      behind=$(git rev-list --count "${branch}..${refbranch:-origin/master}"); \
      colorline=$(echo "$line" | sed 's/^[^|]*|//'); \
      echo "$ahead|$behind|$colorline" | awk -F'|' -vOFS='|' '{ $5 = substr($5,1,70) }1'; \
    done | \
    ( echo -ne "ahead|behind||branch|lastcommit|message|author\n" && cat ) | column -ts'|'
}

### End from: https://stackoverflow.com/questions/5188320/how-can-i-get-a-list-of-git-branches-ordered-by-most-recent-commit
```
