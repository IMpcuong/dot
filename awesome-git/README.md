# This is an archive of some awesome `git` commands that I have been collected!

## Resources:

- [Gist git-bash commands](https://gist.github.com/etoxin/1acb257550b1de60fe99)
- [https://stephencharlesweiss.com](https://stephencharlesweiss.com/git-rebase-interactive)
- [StackOverflow](https://stackoverflow.com/questions/15798862/what-does-git-rev-parse-do)
- [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [Git blobs](https://docs.github.com/en/rest/git/blobs?apiVersion=2022-11-28)

## Feel free to make this archive even larger and more useful.

## Important notes:

- `refs/heads` clarification/elucidation: `@` stands for `HEAD`.
- `Git blobs`: stands for `Git binary large object` is the object type used to store the contents of each file in a repository.
  The file's SHA-1 hash is computed and stored in the blob object.
  These endpoints allow you to read and write blob objects to your Git database on Github. Blobs leverage these custom media types.

1. `git init/clone`:

- `git init` with specified default branch name:

```bash
git init --initial-branch=BRANCH_NAME
```

Or:

```bash
git config init.defaultBranch BRANCH_NAME
```

- Clone specific branch:

```bash
git clone -b BRANCH_NAME --single-branch git@github.com:USERNAME/REPO.git
git clone --bare https://<usrname>:<passwd>@gitlab.com/REPO.git
```

- NOTE:

> - Eg: you only want to clone a specific branch (eg: `dev`) from the remote server.
>
> ```bash
> git clone -b dev --single-branch <repo_https_url>
> ```
>
> - The `.git/config` file's content can be found as below: which's mean that you can only interact with the remote `dev` branch.
>
> ```.gitconfig
> [remote "origin"]
>   url = <repo_https_url>
>   fetch = +refs/heads/dev:refs/remotes/origin/dev
> ```
>
> -> You can revert to normal behavior (accept all remote branches) with this command:
>
> ```bash
> git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
> ```

- Cloning a project using one specific port: (NOTE: the square bracket is no needed at all!)

```bash
git clone ssh://git@mydomain.com:[port]/USERNAME/REPO.git
```

2. `git log/reflog/show`:

- This is some beautify _log/reflog_ commands. Try it yourself!

```bash
# All activities listed in historical order:
git reflog
# Remove all refs' log history:
git reflog expire --expire=now --all

# Logging with maximum output's records constraint:
git log --oneline -10

# Logging with decoration formatting:
git log --oneline --graph
git log --oneline --decorate
git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short

# Logging only with list of changed filenames per commit:
git log --oneline --name-only
```

- Some `git log` commands I have just found out recently, really cool stuffs:

```bash
git shortlog -e -s -n HEAD
git log -L <start_line>,<end_line>:FILENAME --full-history --pretty=oneline --date-order --decorate=full --skip=0 --max-count=10
```

NOTE: The second one is really fascinating, it shows all of the changed parts in one specified file, with a range of lines as your wish.

- Retrieve the latest commit message:

```bash
git log --format=%B -n 1 HEAD
```

- Searching and listing all commits from a interval of time:

```bash
git log --after="4 week" --before="0 week" --oneline
git log --after="4 week" --before="0 week" --oneline | Measure-Object
git log --after="4 week" --before="0 week" --oneline | findstr <commit_hash>
```

- Logging a specific file's statistic with a path itself:

```bash
git log --follow --oneline -- <file_path>
git log --stat --follow --oneline -- <file_path>
```

- Showing the different between two branches: almost have the same effectiveness as the `git diff` command.

```bash
git log --oneline --graph --decorate --abbrev-commit <BRANCH_NAME1>..<BRANCH_NAME2>
```

- Showing only datetime creation of a commit by using its hash abbreviation:

```bash
# `%cd` := created date.
git show --no-patch --no-notes --pretty="%cd" <commit_hash>

# `%h` := hash summary.
# `%s` := commit's subject message.
git show --no-patch --no-notes --pretty="%h %cd %s" <commit_hash>

git -c log.showsignature=false show -s --format=%H:%ct
```

- `git show` raw content of a file:

```bash
git show --textconv :main.go
git show <branch_name>:<path/to/filename>
```

- `git show` in multiple ways, with the same semantics:

```bash
# View the file content in the previous commit of the most recent one:
git show HEAD@{1}
git show HEAD~1
git show @{1}

# View the file content in the previous commit of a specific file:
git show HEAD@{1}:./main.go
git show HEAD~1:./main.go
git show @{1}:./main.go

# Show the original author from a specific commit:
git show --format="%aN <%aE>" HEAD
```

3. `git add/status`:

- Add all the changes:

```bash
git add -A .
```

- Add all the indexed/upstreamed changes:

```bash
git add -u
```

- Add all the indexed changes in interactive mode:

```bash
git add -p
git add --patch
```

- `git status` shows the current state of all file in this directory:

```bash
git status -z -u<mode>
git status -z -uall
```

4. `git commit`:

- Modify latest commit message:

```bash
git commit --amend -m YOUR_MESSAGE
```

- Use latest message commit instead of creating a new one:

```bash
git commit --amend --no-edit
```

- NOTE:

> - After you `commit --amend --no-edit`
>   -> Then you don't want to `push` the updated hash from a amend commit
>   -> You can easily using `pull --amend` first
>   -> Then you don't have to `push -f` in your next push session.

- Manipulate `git` to update indexes with only one chosen file:

```bash
git commit --only main.go
git commit --include main.go
```

- Amending to reset commit's author:

```bash
git config -e # `user.name / user.email`
git commit --amend --reset-author
```

5. `git push`:

- Using this shortcut instead of forcing to push the latest commit:

From:

```bash
git push -f origin main
```

to:

```bash
git push origin +@:main
git push origin +HEAD:main

# Or any current branch that HEAD (~pointer) was pointed to:
git push origin +@:local_branch
git push origin +HEAD:local_branch
```

- Push/pull within a up-to-date circle with the current upstream branch:

```bash
git push --set-upstream origin main
git push --set-upstream origin HEAD
git push -u origin HEAD
```

Note: `HEAD` is equal with `@`.

6. `git pull/fetch`:

- `git fetch`: renew the local indexes tree to be updated with the remote repository.

```bash
git fetch --prune
git -c diff.mnemonicprefix=false -c core.quotepath=false fetch origin
```

- `git pull`: pull new branch without checkout in local first (both have same utility).

```bash
git pull origin develop:develop
git checkout origin/BRANCH -b BRANCH
```

- Pull and rebase if the current branch is busy (have the different history-tree with the remote repository):

```bash
git config --global branch.autosetuprebase always
git pull --rebase REMOTE_BRANCH LOCAL_BRANCH
```

- I'm not test this command yet (?) -> _tested done_, quite useful command:

```bash
git pull -s recursive -X origin
```

- Pull all tags that binding to a given branch:

```bash
git pull --tags origin main
```

- NOTE: `pull --rebase`

> - Applied your commit on top of the remote commit (in the top of HEAD).
> - Careful, as your commits will no longer be in choronological order, have rewritten the history.
> - `--global autosetuprebase`: auto setup rebase before pull remote commit.

7. `git stash`:

- Want to save all the changes before checkout to another branch:

```bash
git stash
```

- Naming the current stash session for an easy pop-out later:

```bash
git stash save "<text>"
```

- Want to pop only the latest changes from the stack:

```bash
git stash pop
```

- Want to show the history of all stashes, extracting from the stack:

```bash
git stash show -p
git stash list
```

- And pop or apply the changes you want to rollback:

```bash
git stash pop stash@{<STASH_INDEX>}
git stash apply stash@{<STASH_INDEX>}
```

- Or you can apply directly using the index number from the stash tree:

```bash
git stash apply --index <STASH_INDEX> -q
```

- Simple git-flow for rebasing and applying the contents of a stash tree starting at a specific index number:

```bash
git stash push -p run.sh # `stash@{1}`.
git stash push -p test.c # `stash@{0}`.

git rebase -i @~3 # Need to update `run.sh`.
git stash pop stash@{1}
git commit --amend --no-edit; git rebase --continue

git stash pop stash@{0} # On HEAD.
git commit -m "etc"
```

8. `git rebase`:

- Want to change the order of all commits' history from the current branch:

Step 1: To retrieve all of the history's activities from the current `HEAD`:

```bash
git reflog
```

Step 2: Choosing the commit's index/position that you want to rebase from (e.g: `HEAD~8`):

```bash
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

Step 3: Changes the commit-tree's order or doing any action with the list of options as above:

After that, if you satisfy with the changes you have made, then:

```bash
git rebase --continue (1)
```

or discard and exit the rebase process:

```bash
git rebase --abort
```

9. `git ls-files`:

- List files using git instead of `ls` commands in your native shell:

```bash
git ls-files
git --git-dir=./.git ls-files -oc --exclude-standard
```

- Checks all files that had been staged already:

```bash
git ls-files --stage -- .
```

10. `git grep`:

- Using `git grep` instead of `grep` or `rg` inside a `git` directory:

```bash
git grep <text>
```

11. `gitk`

- Visualize current branch's history:

```bash
gitk
```

12. `git mergetool`:

- This command used to fix the conflict happened between the merge commits
  process:

```bash
git mergetool -t opendiff
```

- An interactive `vi` windows popup.
- Choose the left-hand side branch : `diffg LO`
- Choose the right-hand side branch : `diffg RE`
- Choose none of these above : `diffg BA`
- Quit this prompt and save our choice : `wq`

13. `git gc`

- `git gc` clean up unnecessary files and optimize the local repository:

```bash
git gc
git gc --prune=now --aggressive
```

14. `git delete` (kind of):

- Delete branch locally:

```bash
git checkout ANOTHER_BRANCH
git branch -D BRANCH_NAME
```

- Delete remote branch:

```bash
git push --delete origin BRANCH_NAME
```

15. `git branch`:

- Common commands:

```bash
git branch -a
git branch -r
git branch -vv
git branch --contains COMMIT_HASH
```

- List all remote branches:

```bash
git branch --remote
git ls-remote
```

- Searching for commit that was belonged to which source branch or coming from any action:

```bash
git branch -a --contains COMMIT_HASH
git reflog show --all | grep COMMIT_HASH

# NOTE:
git log -g --abbrev-commit --pretty=oneline
# and
git reflog show
# are 100 percent equivalent by semantic, the second one is just the alias for the precedent.
```

- Set upstream branch:

```bash
git branch --set-upstream-to=origin/main main
```

- Rename any local or current branch (with the new one):

```bash
git branch -m [<oldbranch>] <newbranch>
git branch -M [<oldbranch>] <newbranch>
```

16. `git diff`

- List conflicts:

```bash
git diff --name-only --diff-filter=U | rg "<<<"
git diff --name-only --diff-filter=U | xargs grep "<<<"
```

- Show changes between 2 branches:

```bash
git diff <branch_1> <branch_2>
git diff <branch_1>..<branch_2>
git diff --name-only <branch_name>..origin/<branch_name>
```

- Show list of files have been changed between 2 branches:

```bash
git diff --name-status <branch_1>..<branch_2> >> changelog.txt
```

- Show change between 2 commits: (NOTE: `^` := plumbing operator)
- A revision range `A..B` for `git log` or `git diff` into the equivalent arguments
  for the underlying plumbing command as `B ^A`.

```bash
git diff HEAD~1..HEAD~0
git diff HEAD~0 ^HEAD~1
git diff --stat $(git symbolic-ref --short HEAD)^..master
```

- Show current modification that is not yet added in blob tree:

```bash
git diff --cached
```

- Show list filenames of all modified files in a specific commit hash:

```bash
git diff-tree --no-commit-id --name-only -r <COMMIT_HASH>
```

- Review all the changes that were applied (between 2 commits) to a specific file:

```bash
git diff --stat HEAD~0 HEAD~2 -- /path/to/file
```

17. `git checkout`

- Recover deleted branch:

```bash
git checkout -b <BRANCH_NAME> <COMMIT_HASH>
```

- Revert (clean any changes that have not been indexed) the current directory to latest commit has been applied:

```bash
git checkout .
```

- Restore all the patches that were indexed using `git add`:

```bash
git restore --staged <FILES>
```

- Revert a file to most recent commit:

```bash
git checkout <path_to_file>
git checkout HEAD -- <path_to_file>
```

- Checkout a file back to the latest commit version that was recognized by the remote branch:

```bash
git checkout origin/BRANCH_NAME -- <file_name>
```

- Accept all incoming changes or hold still our branch:

```bash
# Incomming:
git checkout --theirs .

# Current changes:
git checkout --ours .
```

- Checkout a specific file to the previous commit of the latest one:

```bash
git checkout @{1} -- main.go
```

- Revert a specific range of lines from the un-staged changes state:

```bash
git checkout -p
git checkout --patch
```

- Checkout by date using `rev-parse` or `rev-list`:
  https://stackoverflow.com/questions/6990484/how-to-checkout-in-git-by-date#6990682

```bash
git checkout 'main@{1979-02-26 18:30:00}' # `rev-parse` version.
git checkout $(git rev-list -n 1 --first-parent --before="2012-07-22 11:11" main) # `rev-list` version.
```

18. `git reset` (_BE CAREFUL WITH_ `git reset` !!!)

- Sweep the latest commit out of Earth:

```bash
git reset --hard HEAD~1
```

- NOTE: recommendation because it's just revert the most recent changed file to un-staged status.

```bash
git reset --soft HEAD~1
```

18. `git rev-parse`

- NOTE: `rev` stand for `revision`

- This is an ancillary/support `plumbing` (^) command used for manipulation purpose,
  one of the primary use cases is to print the `SHA1` hashes given a revision specific.

```bash
git rev-parse HEAD
git rev-parse --short HEAD
```

Also works for getting the current branch name

```bash
git rev-parse --abbrev-ref HEAD
git rev-parse --abbrev-ref @
```

- Some options: [--verify, --git-dir, --is-inside-git-dir, --is-inside-work-tree, --branches, --remote]

- If you want to find the latest commit in another branch:

```bash
git rev-parse <local-branch-name>
git rev-parse origin/<remote-branch-name>
```

- Retrieve the remote's latest commit-hash:

```bash
git rev-parse refs/remotes/origin/main^{commit}
```

19. `git remote`:

- Shows remote URL that was binded with our local repository:

```bash
git remote --verbose
```

- `git remote` add new remote repo:

```bash
gir remote add origin git@github.com:<USERNAME>/<REPO>.git
```

- `git remote` set default URL to avoid asking username/passwords prompt popping off:

```bash
# NOTE: Only works with `https`, `ssh` method sometimes requires passphrase as well.
git remote set-url origin git@github.com:<USERNAME>/<REPO>.git
git remote set-url origin https://github.com/<USERNAME>/<REPO>.git

# NOTE: Allow user to push to both the original origin (github + gitlab).
git remote set-url --add origin git@gitlab.com:<USERNAME>/<REPO>.git
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

```bash
git credential-cache exit
git config --global credential.helper manager
git config --global credential.helper manager-core
```

NOTE: all the saved credentials can be found in here (`Control Panel\User Accounts\Credential Manager`)

- `git credential-manager`:

  - `--system` > `--global` > `--local`: (example belows)

```bash
git config --system -e
git config --system credential.helper manger-core/wincred
git config --system --unset-all credential.helper
```

- `git config` set reference to remote URl:

```bash
git config remote.origin.url <REMOTE_URL>
```

- We should add our credential informations with pattern like `git:domain` in the `credential-manager` window follow the form below:

```credential
username: <Git-SCM username>
password: <your_access_token>
```

- Shows commit's template that has already been attached in our local configuration:

```bash
git config --get commit.template
```

- Git proxy bypass (overwritten per-remote basis):

```bash
git config --add remote.origin.proxy ""
```

21. `git switch`:

- You are in `detached HEAD` state. You can look around, make experimental
  changes and commit them, and you can discard any commits you make in this
  state without impacting any branches by switching back to a branch.

- If you want to create a new branch to retain commits you create, you may
  do so (now or later) by using `-c` with the switch command. Example:

```bash
git switch -c <new-branch-name>
git switch --create <new-branch-name>
```

Or undo this operation with:

```bash
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

# Remove untracked files from git-indexed: after `git add -A .`
git rm --cached test.txt # Index deletion.
git rm --cached -r .
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

```bash
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

25. `git update-ref`: safely update the object's name stored in the `ref`.

- `ref` demystification:

  - `ref` or `reference` is a name that begins with `refs/` (e.g. `refs/heads/master`) that points to an object name or another `ref` (the latter is called a symbolic ref). For convenience, a ref can sometimes be abbreviated when used as an argument to a Git command. `Refs` are stored in the repository.

  - The `ref` namespace is hierarchical. Different subhierarchies are used for different purposes (e.g. the `refs/heads/` hierarchy is used to represent local branches).

  - There are a few special-purpose `refs` that do not begin with `refs/`. The most notable example is HEAD.

- Revert the merge process in between a merge-commit (if you want to start merging all over):

```bash
git update-ref -d MERGE_HEAD
```

26. `git symbolic-ref`:

```bash
git symbolic-ref --short HEAD
```

27. `git cat-file`: provide content/type/size information for repository objetcs.

- Findout the object size, example with a commit size:

```bash
git cat-file -s <COMMIT_HASH>
```

28. `git bundle`: move objects and refs by archive.

```bash
git bundle create ../project.bundle <default-branch-name>
```

29. `git count-objects`: count unpacked number of objects and their disk consumption.

```bash
git count-objects -v
```

30. `git show-ref`: retrieve all hash-references from both local and remote repos.

```bash
git show-ref # All ref.
git show-ref HEAD # Only from current indexed branch.
```

31. `git work-tree`: manipulate several working directory at once.

```out
$ ls -d */
worktree-1//  worktree-2//

$ git worktree add worktree-1 -b w1
Preparing worktree (new branch 'w1')
HEAD is now at 88049b6 test

$ git worktree add worktree-2 -b w2
Preparing worktree (new branch 'w2')
HEAD is now at 88049b6 test

$ git worktree list -v
~/tmp/test-git-update-idx             88049b6 [main]
~/tmp/test-git-update-idx/worktree-1  88049b6 [w1]
~/tmp/test-git-update-idx/worktree-2  88049b6 [w2]
```
