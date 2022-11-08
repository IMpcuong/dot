1. `Bash` lowercase and uppercase strings using native parameter expansions:

- Resources:

  - [`tr` command](https://linuxhint.com/bash_tr_command/)
  - [Strings upper/lowercase](https://linuxhint.com/bash_lowercase_uppercase_strings/)

- Examples of each strings conversion syntax:

```bash
# Exp1 ~ Uppercase:
declare -x name="dude"
echo $name
# --> dude
echo ${name^}
# --> Dude
echo ${name^^}
# --> DUDE

# Exp2 ~ Uppercase for specific first letter:
echo ${name^d}
# --> Dude
echo ${name^u}
# --> dude

# Exp3 ~ Uppercase any specific character(s) in a string:
declare -x language="python perl java php c#"
echo $language
# --> python perl java php c#
echo ${language^^p)}
# --> Python Perl java PhP c#
echo ${language^^[pj]}
# --> Python Perl Java PhP c#

# Exp4 ~ Reckon `stdin` as the value behind a variable:
read -p "Do you like music? " ans
answer=${ans^}
echo "Your answer is $answer."

# Exp5 ~ `,,` operator is used to convert the values taken from stdin and compare with the variable `$username` and `$password`:
declare -x username='admin'
declare -x password='admin'
read -p "Enter username: " u
read -p "Enter password: " p
declare -x user=${u,,}
declare -x pass=${p,,}
if [ $username == $user ] && [ $password == $pass ]; then
  echo "Valid User!"
else
  echo "Invalid User!"
fi

# Exp6 ~ Using `tr` command: translate, squeeze, and/or delete characters from stdin, writing to stdout.
tr [:upper:] [:lower:]
tr a-z A-Z
ls -l | awk '{print $9}' | tr A-Z a-z

# Exp7 ~ Rename multiple directories' name to lowercase with the maximum depth equivalent with 2.
declare -a dirs=(`find . -maxdepth 2 -type d -a -regextype "egrep" -regex "^.*(\/.+){2,}.*"`)
for dir in ${dirs[@]}; do
  declare -x new_dir=$(echo $dir | tr [[:upper:]] [[:lower:]])
  mv $dir $new_dir
done
```
