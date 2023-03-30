#!/bin/bash

# NOTE: https://fabianlee.org/2021/01/09/bash-grep-with-lookbehind-and-lookahead-to-isolate-desired-text/

declare -x html_path="$HOME/tmp/index.html"

if [ -f "${html_path}" ]; then
  printf "%s\n" "[INFO] Let do it!"

  # NOTE: `grep` supports Perl compatible regular expressions (PCRE) by using the -P flag.
  printf "%s\n" "[INFO] Exp1:"
  grep -oP "(?<=p\>)\w+[^<]+" "${html_path}" # NOTE: LookBehind.

  # NOTE: LookBehind; use \K to reset capture group for variable with variant length.
  printf "%s\n" "[INFO] Exp2:"
  grep -oP "(p|h\d?)\>\K[^<]+" "${html_path}"

  # NOTE: LookAhead also allows you to remove part of the matching text from a capture group
  #     by specifying a “?=” in front of the capture group.
  printf "%s\n" "[INFO] Exp3:"
  grep -oP "(p|h\d?)\>\K[^<]+(?=[Rr]ows?)" ${html_path}
fi

# Input:
#
# <!DOCTYPE html>
# <html>
# <body>
# <h2>HTML Tables</h2>
# <p>HTML tables start with a table tag.</p>
# <p>Table rows start with a tr tag.</p>
# <p>Table data start with a td tag.</p>
# <hr>
# <h2>1 Column:</h2>
# <table>
# <tr>
# <td>100</td>
# </tr>
# </table>
# <hr>
# <h2>1 Row and 3 Columns:</h2>
# <table>
# <tr>
# <td>100</td>
# <td>200</td>
# <td>300</td>
# </tr>
# </table>
# <hr>
# <h2>3 Rows and 3 Columns:</h2>
# <table>
# <tr>
# <td>100</td>
# <td>200</td>
# <td>300</td>
# </tr>
# <tr>
# <td>400</td>
# <td>500</td>
# <td>600</td>
# </tr>
# <tr>
# <td>700</td>
# <td>800</td>
# <td>900</td>
# </tr>
# </table>
# <hr>
# </body>
# </html>

# Output:
#
# [INFO] Let do it!
# [INFO] Exp1:
# HTML tables start with a table tag.
# Table rows start with a tr tag.
# Table data start with a td tag.
# [INFO] Exp2:
# HTML Tables
# HTML tables start with a table tag.
# Table rows start with a tr tag.
# Table data start with a td tag.
# 1 Column:
# 1 Row and 3 Columns:
# 3 Rows and 3 Columns:
# [INFO] Exp3:
# Table
# 1
# 3
