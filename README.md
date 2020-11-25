# send-key-to-app

A simple macOS CLI utility, `send-key-to-app` sends key strokes to another application.
It assumes to be used with key configuration utility softwares like
[Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements),
to send key strokes to a background application.

## Usage

```sh
USAGE: send-key-to-app [--pid <pid>] [--app-name <name>] [--interval <sec>] [<keys> ...]

ARGUMENTS:
  <keys>                  A key or a key with modifiers (eg: a, cmd+a, alt+shift+e).

OPTIONS:
  -p, --pid <pid>         Specify target by pid.
  -a, --app-name <name>   Specify target by an executable file name (not a path).
  -t, --interval <sec>    Time duration(seconds) per each key input.
                          Some application requires appropreate this value to detect keys and action. (default: 0.01)
  -h, --help              Show help information.
```

Simplly, the following command prints `Hello` on your `Terminal` app,
if you have launched `Terminal` app.

```sh
send-key-to-app -a Terminal shift+h e l^2 o
```

And followings are more practicial examples.

```sh
send-key-to-app -a Kindle left      # let background Kindle to navigate next page
send-key-to-app -a Kindle left left # futher more pages
send-key-to-app -a Kindle right     # ...and back to prev page

send-key-to-app -a Safari opt+down  # let Safari to page down
send-key-to-app -a Safari down^5    # ...or a little page down 5 times

send-key-to-app -a Twitter cmd+up   # let Twitter scroll up toward the top
```

Once you have configured to bind these commands to some keys,
it works suitable to navigate your reference ePubs durling coding
as keeping focus on your editor or terminal.

### Syntax

`modifier+modifier+key^n`

sends `modifier+modifier+key` `n` times.

See [keycode.swift](./Sources/send-key-to-app/keycode.swift)
for available key names.

### Available modifier keys

- `command`, `cmd`
- `shift`
- `option`, `opt`, `alt`
- `control`, `ctl`

## Build and Install

```sh
git clone https://github.com/asa-taka/send-key-to-app
cd send-key-to-app
swift build -c release
cp $(swift build -c release --show-bin-path)/send-key-to-app <YOUR_$PATH>
```
