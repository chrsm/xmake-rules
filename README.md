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

# Using

This is where things get tricky. xmake doesn't support a top-level require.
The easiest route is to copy-paste the code directly into your xmake.lua script.

If you're cool:TM: and using yue, you can use macros to make your xmake.yue 
nice and clean while having everything pushed into xmake.lua as a result.

For example, given this project setup:

```
repo/
    xmake.yue
    src/
        main.go
        { bunch of files }
    scripts/
        macros.yue
        rule_golang.yue
```

You can create some helpful macros inside `scripts/macros.yue`:
```moonscript
-- macros.yue

export macro raw = (code) ->
  { :code, type: "lua" }

export macro import = (file) ->
  fp, err = io.open file
  if err != nil
    error err

  fd = fp\read "*a"
  fd
```

Then, `xmake.yue` can import script macros:

```moonscript
-- xmake.yue
import "scripts.macros" as { $ }

-- project def: rules must be specified AFTER
set_project "something"
add_rules "mode.debug", "mode.release"

$import scripts/rule_golang.yue
```

In `rule_golang.yue`, you can subsequently use the `raw` macro without copying
it by importing the same `scripts.macros` as you would in `xmake.yue`, eg:

```moonscript
import "scripts.macros" as { $ }

rule "custgolang"
do
  set_extensions ".go"
  on_link () -> nil
  on_build_file (target, files, opt) ->
    $raw[[
      import("core.project.depend")
      import("utils.progress")
    ]]
    os.mkdir target\targetdir!

    relp = path.join target\targetdir!, (path.basename target\name!)
    if target\is_plat "windows"
      relp ..= ".exe"

    depend.on_changed (() ->
      os.vrunv "go", { "build", "-v", "-o", relp, target\name! }
    ), { dependfile: (target\dependfile relp), files: files, always_changed: false }

```

This allows you to nicely separate out parts of your xmake setup without
compromise. It is important to remember this is not a substitute for per-target
configs (ie having `xmake.lua`/`xmake.yue` under other targets), just a helper
for sharing code in any config.

