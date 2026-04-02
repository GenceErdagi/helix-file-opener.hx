# helix-file-opener.hx

Helix plugin for opening files remotely via TCP. Integrates with [helix-server.hx](https://github.com/<you>/helix-server.hx) to receive file paths from external tools like file managers, terminals, or scripts.

[![Steel](https://img.shields.io/badge/steel-plugin-blue)](https://github.com/mattwparas/steel)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

## Features

- **Remote file opening** — open files in a running Helix instance from anywhere
- **Session-aware** — works seamlessly inside Zellij with per-session port allocation
- **Error notifications** — failed file opens surface as [notify.hx](https://github.com/chuwy/notify.hx) error popups

## Installation

### Prerequisites

- [helix-server.hx](https://github.com/<you>/helix-server.hx) — required dependency
- [notify.hx](https://github.com/chuwy/notify.hx) — for error notifications

### Via Forge

```
forge pkg install --git https://github.com/<you>/helix-file-opener.hx.git
```

### Manual Setup

Add to your Helix `init.scm`:

```scheme
(require "helix-server/helix-server.scm")
(require "helix-file-opener/helix-file-opener.scm")

;; Register the open handler with helix-server
(register-handler "open" open-file-handler)

;; Server starts automatically
```

## Usage

### CLI

Send a file path to open via TCP:

```bash
# Using the included nushell script
nu open_in_hx.nu /path/to/file.txt

# Or manually with python3
echo "open:/path/to/file.txt" | python3 -c "import sys,socket;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(('127.0.0.1',6666));s.sendall(sys.stdin.read().encode());s.close()"
```

### From Yazi

Add to your Yazi keymap (`~/.config/yazi/keymap.toml`):

```toml
[[manager.prepend_keymap]]
on   = [ "o" ]
run  = '''
  shell 'echo "open:$1" | python3 -c "import sys,socket;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"127.0.0.1\",6666));s.sendall(sys.stdin.read().encode());s.close()" _ "$@"'
'''
```

### From a Script

Use the included `open_in_hx.nu` nushell script:

```bash
nu open_in_hx.nu file1.rs file2.toml
```

It automatically detects the correct port from your Zellij session.

## API

| Function | Description |
|---|---|
| `(open-file-handler path)` | Opens the given file path in Helix. Use via `register-handler`. |

## Error Handling

| Scenario | Severity | Title |
|---|---|---|
| File open throws an exception | `error` | `helix-file-opener` |

## Architecture

```
External Tool ──TCP──► helix-server
                          │
                          └── "open:/path" → open-file-handler
                                                │
                                                └── hx-typable.open
                                                └── notify.hx (on error)
```

## Dependencies

- `helix` — Steel plugin bindings for Helix
- `helix-server` — TCP server framework
- `notify` — [notify.hx](https://github.com/chuwy/notify.hx) for error popups

## Acknowledgments

- [@mattwparas](https://github.com/mattwparas/) for [Steel](https://github.com/mattwparas/steel) and the Helix plugin system
- [@chuwy](https://github.com/chuwy/) for [notify.hx](https://github.com/chuwy/notify.hx) which powers error and warning notifications

## License

MIT
