- [String comparisons in Linux - Linuxize](https://linuxize.com/post/how-to-compare-strings-in-bash/): each case have it own example.

  ```bash
  [Strings Equal]
  #!/bin/bash

  read -p "Enter first string: " VAR1
  read -p "Enter second string: " VAR2

  # Solution1:
  if [ "$VAR1" = "$VAR2" ]; then
    echo "Strings are equal."
  else
      echo "Strings are not equal."
  fi

  # Solution2:
  if [[ "$VAR1" == "$VAR2" ]]; then
      echo "Strings are equal."
  else
      echo "Strings are not equal."
  fi

  # Solution3:
  [[ "string1" == "string2" ]] && echo "Equal" || echo "Not equal"
  ```

  ```bash
  [String Contains]
  #!/bin/bash

  VAR='GNU/Linux is an operating system'

  # Solution1:
  if [[ $VAR == *"Linux"* ]]; then
    echo "It's there."
  fi

  # Solution2:
  # NOTE: `=~` := The regex operator returns true if the left operand is than the right
  # sorted by lexicographical (alphabetical) order.
  if [[ $VAR =~ .*Linux.* ]]; then
    echo "It's there."
  fi
  ```

  ```bash
  [Null Strings]
  #!/bin/bash

  VAR=''

  # NOTE:
  # + `-z` := True if string length is zero.
  # + `-n` := True if string length is non-zero.
  if [[ -z $VAR ]]; then
    echo "String is empty."
  elif [[ -n $VAR ]]; then
    echo "String is not empty."
  fi
  ```

  ```bash
  [Switch/Case Statement]
  #!/bin/bash

  VAR="Arch Linux"

  case $VAR in

    "Arch Linux")
      echo -n "Linuxize matched"
      ;;

    Fedora | CentOS)
      echo -n "Red Hat"
      ;;
  esac
  ```
