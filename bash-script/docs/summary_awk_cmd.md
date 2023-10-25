1. `Patterns`:

- `BEGIN`, `END`: are 2 special kinds of patterns which are not tested/needed against the input (`stdin`).

```
  BEGIN
  END
  BEGINFILE
  ENDFILE
  /regular expression/
  relational expression
  pattern && pattern
  pattern || pattern
  pattern ? pattern : pattern
  (pattern)
  ! pattern
  pattern1, pattern2
```

- Links:
  - [Multiple-stragies/maneuvers to embed shell-vars into awk-env][1]

[1]: https://www.baeldung.com/linux/awk-use-shell-variables
