# helix-file-opener

Helix plugin for remote file opening via TCP. Built on top of helix-server.

## Features

- Open files in running Helix instance remotely
- Session-aware port allocation for Zellij support
- Built on extensible helix-server framework

## Installation

### Manual Setup

Add to your Helix `init.scm`:
```scheme
(require "helix-server/helix-server.scm")
(require "helix-file-opener/helix-file-opener.scm")

;; Register handlers before starting server
(register-handler "open" open-file-handler)

(helix-server-start)
```

## Usage

Send files to open via TCP:
```bash
echo "open:/path/to/file.txt" | nc -w1 127.0.0.1 6666
```

Or use with yazi (in yazi config):
```lua
require("setup").on_key("o", function()
  local file = require("yazi").files()[1]
  if file then
    os.execute('echo "open:' .. file .. '" | nc -w1 127.0.0.1 6666')
  end
end)
```

## Architecture

This plugin registers the "open" handler with helix-server:

```
helix-server (TCP)
    │
    └── "open:/path" → helix-file-opener handler → helix.open
```

## API

- `open-file-handler` - The handler function for "open" action
