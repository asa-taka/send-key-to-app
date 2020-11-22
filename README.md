# send-key-to-app

A simple macOS CLI utility, `send-key-to-app` sends a key stroke to another application.
It assumes to be used with key configuration utility softwares like
[Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements),
to send a key stroke to a background application.

## Usage

```sh
send-key-to-app APP_NAME [KEY KEY ...]
```

Simplly, following command prints `Hello` on your `Terminal` app,
if you have already launched the `Terminal` app.

```sh
send-key-to-app Terminal shift+h e l l o
```

And followings are more practicial examples.

```sh
send-key-to-app Kindle left      # let background Kindle to navigate next page
send-key-to-app Kindle left left # futher more pages...
send-key-to-app Kindle right     # and back to prev page
```

Once you have configured to bind these commands to some keys,
it works suitable to navigate your reference ePubs durling coding with your editor or terminal.

## Build and Install

```sh
git clone https://github.com/asa-taka/send-key-to-app
cd send-key-to-app
swift build -c release
cp $(swift build -c release --show-bin-path)/send-key-to-app <YOUR_$PATH>
```
