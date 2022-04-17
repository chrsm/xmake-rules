# xmake-rules

A few rules for xmake that I have written.

Note that these are written in [yuescript](https://github.com/pigpigyyy/Yuescript),
so the compiled versions are obviously generated and slightly cleaned up manually
for quick copy-paste.

## yuescript

[rule_yue.yue](rule_yue.yue) ([compiled](rule_yue.lua))

Example:

```moonscript
target "build"
do
  set_kind "object"

  add_rules "yue"
  add_files "src/**.yue"
```

## golang

[rule_golang.yue](rule_golang.yue) ([compiled](rule_golang.lua))

Example:

```moonscript
-- assuming go.mod pkg of `coolpkg`

target "coolpkg/cmd/thing"
do
  set_kind "binary"
  add_rules "custgolang"
  add_files "cmd/thing/*.go"
```
