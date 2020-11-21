# send-key-to-app

A simple macOS CLI utility, `send-key-to-app` sends a key stroke to another application.
It assumes to be used with key configuration utility softwares like
[Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements),
to send a key stroke to a background application.

## Usage

```sh
send-key-to-app Kindle 124 # let background Kindle to navigate next page
send-key-to-app Kindle 123 # ...and page back
```

## Build and Install

```sh
git clone https://github.com/asa-taka/send-key-to-app
cd send-key-to-app
swift build -c release
cp $(swift build -c release --show-bin-path)/send-key-to-app <YOUR_$PATH>
```
