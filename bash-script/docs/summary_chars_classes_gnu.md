1. List of all special characters available in the current version of `GNU-lib`:

- A character class is only valid in a regular expression inside the brackets of a character list.
- Character classes consist of `[:, a keyword denoting the class, and :]`.
- The character classes defined by the POSIX standard are:

```
  [:alnum:]   Alphanumeric characters
  [:alpha:]   Alphabetic characters
  [:blank:]   Space or tab characters
  [:cntrl:]   Control characters
  [:digit:]   Numeric characters
  [:graph:]   Characters that are both printable and visible.  (A space is printable, but not visible, while an a is both.
  [:lower:]   Lowercase alphabetic characters
  [:print:]   Printable characters (characters that are not control characters.
  [:punct:]   Punctuation characters (characters that are not letter, digits, control characters, or space characters)
  [:space:]   Space characters (such as space, tab, and formfeed, to name a few)
  [:upper:]   Uppercase alphabetic characters
  [:xdigit:]  Characters that are hexadecimal digits
```

2. [Special characters resource](https://tldp.org/LDP/abs/html/special-chars.html)

- `$IFS`, the special variable separating fields of input to certain commands. It defaults to whitespace.
- Field definition:

```
A discrete chunk of data expressed as a string of consecutive characters.
Separate each field from adjacent/next fields is either whitespace or some designated character (field ~ record).
```