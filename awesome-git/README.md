# This is an archive some awesome `git` command I have been collected!

## Feel free to make this archive become even larger and more useful.

1. `git clone`:

- Clone specific branch:

```git
git clone -b BRANCH_NAME --single-branch git@github.com:USERNAME/REPO.git
```

2. `git log/reflog`:

- This is some beautify _log/reflog_ commands. Try it yourself!

```git
git reflog
git log --oneline -10
git log --oneline --graph
git log --oneline --decorate
git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
```

- Some `log` commands I just find out, really cool stuff:

```git
git shortlog -e -s -n HEAD
git log -L <start_line>,<end_line>:FILENAME --full-history --pretty=oneline --date-order --decorate=full --skip=0 --max-count=10
```

NOTE: The second one is really fascinating, it shows the change in the specified 
from start to end lines.

Resource: [https://stephencharlesweiss.com](https://stephencharlesweiss.com/git-rebase-interactive)

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

Note: `HEAD` equal with `@`

6. `git pull/fetch`:

- `git fetch`: update local indexes with the remote repository.

```git
git fetch --prune
```

- `git pull`: pull new branch without checkout in local first.

```git
git pull origin develop:develop
```

7. `git stash`:

- Want to save all the changes and checkout to another branch:

```git
git stash
```

- Want to pop the latest changes from the stack:

```git
git stash pop
```

- Want to pop some specific stash from the stack:

```git
git stash list
git stash pop YOUR_HASH
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
git mergetool
```

An interactive `vi` windows popup. 
Choose the left-hand side branch     : `diffg LO`
Choose the right-hand side branch    : `diffg RE`
Choose none of these above           : `diffg BA`
Quit this prompt and save our choice : `wq`

