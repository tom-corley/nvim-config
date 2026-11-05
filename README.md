# nvim config

My [LazyVim](https://github.com/LazyVim/LazyVim) setup.

## Setup

```sh
brew install neovim git ripgrep fd lazygit
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
git clone https://github.com/tom-corley/nvim-config ~/.config/nvim
nvim --headless "+Lazy! restore" +qa
```

Then open `nvim`. LSP servers install themselves on first launch.

## Optional

- `gh auth login`: Octo PR reviews
- Flutter SDK: Dart support (skipped if missing)
- Ghostty/Kitty + `imagemagick`: inline images
- `NVIM_WORKTREE_BG`: background colour override

## Syncing

After `:Lazy update`, commit and push `lazy-lock.json`. On the other machine: `git pull`, then `:Lazy restore`.
