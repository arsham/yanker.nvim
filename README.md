# Yanker

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/arsham/yanker.nvim)
![License](https://img.shields.io/github/license/arsham/yanker.nvim)

Neovim plugin for quickly create random highlights for matches.

1. [Demo](#demo)
2. [Requirements](#requirements)
3. [Installation](#installation)
   - [Lazy](#lazy)
   - [Packer](#packer)
   - [Config](#config)
   - [Lazy Loading](#lazy-loading)
4. [License](#license)

## Demo

In this demo I am yanking in different modes. I'm also yanking the same item
multiple time; This plugin will de-duplicate them. With `<leader>yh` you can
choose one of the yanked items in the history and paste.

![yanker](https://user-images.githubusercontent.com/428611/148665300-6ecd1e48-e863-40d7-8c17-0cb3c9f7797d.gif)

## Requirements

This library supports [Neovim
v0.7.0](https://github.com/neovim/neovim/releases/tag/v0.7.0) or newer.

This plugin depends are the following libraries. Please make sure to add them
as dependencies in your package manager:

- [arshlib.nvim](https://github.com/arsham/arshlib.nvim)
- [fzf.vim](https://github.com/junegunn/fzf.vim)

## Installation

Use your favourite package manager to install this library.

### Lazy

```lua
{
	"arsham/yanker.nvim",
  dependencies = { "arsham/arshlib.nvim", "junegunn/fzf.vim" },
  config = true,
  -- or to provide configurations
  -- config = { history = "<leader>yh" },
}
```

### Packer

```lua
use({
  "arsham/yanker.nvim",
  config = function()
    require("yanker").config({})
  end,
  requires = { "arsham/arshlib.nvim", "junegunn/fzf.vim" },
})
```

### Config

By default this pluging uses `<leader>yh` for key mapping, However you can
change it to your liking. For example:

```lua
require("yanker").config({
  history = "<leader>yh",
})
```

### Lazy Loading

You can let your package manager to load this plugin when a key-mapping
events is fired or a buffer is opened. Packer example:

```lua
use({
  "arsham/yanker.nvim",
  config = function()
    require("yanker").config({})
  end,
  requires = { "arsham/arshlib.nvim", "junegunn/fzf.vim" },
  event = { "BufRead", "BufNewFile" },
  keys = { "<leader>yh" },
})
```

## License

Licensed under the MIT License. Check the [LICENSE](./LICENSE) file for details.

<!--
vim: foldlevel=1
-->
