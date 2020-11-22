# send-key-to-app

A simple macOS CLI utility, `send-key-to-app` sends a key stroke to another application.
It assumes to be used with key configuration utility softwares like
[Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements),
to send a key stroke to a background application.

## Usage

```sh
USAGE: send-key-to-app [--pid <pid>] [--app-name <app-name>] [<keys> ...]

ARGUMENTS:
  <keys>                  a key or key with modifiers (eg: a, cmd+a, alt+shift+e)

OPTIONS:
  -p, --pid <pid>         specify target by pid
  -a, --app-name <app-name>
                          specify target by an executable file name (not a path)
  -h, --help              Show help information.
```

Simplly, following command prints `Hello` on your `Terminal` app,
if you have launched `Terminal` app.

```sh
send-key-to-app -a Terminal shift+h e l l o
```

And followings are more practicial examples.

```sh
send-key-to-app -a Kindle left      # let background Kindle to navigate next page
send-key-to-app -a Kindle left left # futher more pages...
send-key-to-app -a Kindle right     # and back to prev page

send-key-to-app -a Twitter cmd+up   # let Twitter scroll up toward the top
```

Once you have configured to bind these commands to some keys,
it works suitable to navigate your reference ePubs durling coding
as keeping focus on your editor or terminal.

## Build and Install

```sh
git clone https://github.com/asa-taka/send-key-to-app
cd send-key-to-app
swift build -c release
cp $(swift build -c release --show-bin-path)/send-key-to-app <YOUR_$PATH>
```
