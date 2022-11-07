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

# Uppercase for specific first letter:
echo ${name^d}
# --> Dude
echo ${name^u}
# --> dude

# Exp2 ~ Uppercase any specific character(s) in a string:
declare -x language="python perl java php c#"
echo $language
# --> python perl java php c#
echo ${language^^p)}
# --> Python Perl java PhP c#
echo ${language^^[pj]}
# --> Python Perl Java PhP c#

# Exp3 ~ Reckon `stdin` as the value behind a variable:
read -p "Do you like music? " ans
answer=${ans^}
echo "Your answer is $answer."

# Exp4 ~ `,,` operator is used to convert the values taken from stdin and compare with the variable `$username` and `$password`:
username='admin'
password='pop890'
read -p "Enter username: " u
read -p "Enter password: " p
user=${u,,}
pass=${p,,}
if [ $username == $user ] && [ $password == $pass ]; then
echo "Valid User"
else
echo "Invalid User"
fi

tr [:upper:] [:lower:]
tr a-z A-Z
ls -l | awk '{print $9}' | tr A-Z a-z
```
