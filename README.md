# Matthew's dotfiles3

Modern Neovim, with Matthew's navigation and editing habits preserved.
Space is the leader. Press Space and pause to discover mappings. Open this guide
any time with `Space help`. Configuration changes take effect when you restart Neovim.

## Start here

- `Space ff`: find files. `?` or `Space fg`: search project text.
- `-`, F5, or `Space 5`: Oil directory editor. Enter opens a file; `-` goes up.
  Edit filenames and save to apply operations; Oil asks for confirmation.
- Left/Right: switch buffers. Up/Down: beginning/end of file.
- `jk`: leave insert mode. Ctrl-S: save. `ww`: save all.
- `q`: close window. `qq`: quit all. `Space qq`: quit with a prompt for unsaved work.
- `Space 0` / `Space fi`: format. Formatting never runs automatically on save.
- `Space r`: save and run the current source file in a terminal pane. Escape twice returns to editing.
- `Space vi`: edit init.lua. The small init.lua loads the modules described below.

The layout uses Gruvbox, relative line numbers, a buffer bar at the top, and a
status line at the bottom. There is no startup dashboard or minimap. Spell checking
is enabled for prose, not code. `Space us` toggles spelling; `Space uw` toggles wrapping.
Most files use four-space indentation; Lua/web/JSON files use two.

## Install and rollback

On macOS with Homebrew:

```sh
git clone https://github.com/vertical-matthew/dotfiles3.git ~/dotfiles3
cd ~/dotfiles3
bash scripts/install.sh --deps
nvim README.md
```

If tools are already installed, run `bash scripts/install.sh`. It requires Neovim
0.12+, Git, ripgrep, fd, a C compiler, make, and tree-sitter-cli. The dependency
option also installs Node, Pyright, Ruff, StyLua, Lua Language Server, and Prettier.
Swift uses Apple's `sourcekit-lsp` when available through the developer tools.
Homebrew may upgrade shared dependencies and dependent applications.

The installer moves the entire previous configuration into a unique directory under
`~/.local/state/dotfiles3-backups/`, records its location in `latest`, then links
`~/.config/nvim` to this repository's `nvim` directory. Existing old plugin folders
and undo files are preserved. Re-running installation keeps the original backup.
Standard XDG environment overrides are honored.

Restore the previous local configuration:

```sh
bash ~/dotfiles3/scripts/install.sh --restore
```

This retains the displaced new configuration as another backup. Restart Neovim.
Re-enable dotfiles3 with `bash ~/dotfiles3/scripts/install.sh`.
This restores configuration, not the Homebrew Neovim version. The old Vimscript
and old plugins can have compatibility issues with current Neovim; dotfiles2's
GitHub snapshot remains unchanged at commit `a89b1b9`.

For a fresh recovery from GitHub, clone
<https://github.com/vertical-matthew/dotfiles2> and follow its README; first preserve
any current `~/.config/nvim` directory. Prefer the local full backup on this Mac,
because it includes the old local plugin installation as well as init.vim.

## Where things live

| Location | Contents |
| --- | --- |
| `~/dotfiles3` | This Git repository |
| `~/.config/nvim` | Symlink to `~/dotfiles3/nvim` |
| `nvim/init.lua` | Loads options, plugins, mappings, autocommands |
| `nvim/lua/core/options.lua` | Editor preferences and state directories |
| `nvim/lua/core/keymaps.lua` | Your mappings and adapted commands |
| `nvim/lua/core/autocmds.lua` | Filetype settings, Treesitter, LSP mappings |
| `nvim/lua/core/lazy.lua` | Plugin manager bootstrap |
| `nvim/lua/plugins/editor.lua` | Navigation, editing, Git, and Org plugins |
| `nvim/lua/plugins/languages.lua` | Completion, LSP, formatting, parsers |
| `nvim/lazy-lock.json` | Exact plugin revisions; commit after intentional updates |
| `~/.local/share/nvim/dotfiles3/lazy` | Downloaded plugins |
| `~/.local/share/nvim/dotfiles3/treesitter` | Compiled parsers and queries |
| `~/.local/state/nvim/dotfiles3` | Undo, backup and swap files |
| `~/.local/state/dotfiles3-backups` | Previous complete configurations |
| `/opt/homebrew/bin` | Tools on this Apple Silicon Mac |
| `~/org` | Your Org files; installation does not modify existing notes |

Neovim also uses its standard cache, ShaDa, and log locations. Check `:echo
stdpath('data')`, `:echo stdpath('state')`, and `:echo stdpath('cache')` for exact
paths on other machines. UI labels and separators use ordinary characters, so no
Nerd Font is required. Twilight uses a fixed context of lines, avoiding parser errors
in terminal panes and files without a syntax parser.

## Mapping guide

Keys below are Normal mode unless noted. `Space Space h` means press Space twice,
then h. Some terminal applications cannot distinguish Shift-Backspace or intercept
Option-key combinations; Ctrl-R and the Space mappings provide alternatives.

| Keys | Action |
| --- | --- |
| `;` | Command line, also in Visual mode |
| `jk` (Insert) | Escape |
| Ctrl-S | Save current file; leaves Insert/Visual mode |
| `ww`, `q`, `qq` | Write all, close window, quit all |
| `Space qq` | Confirm quitting with unsaved files (old force-quit changed) |
| `Space Q` then register | Record a macro; q remains your quit mapping |
| `J` / `K` | Next / previous paragraph; use `gJ` for joining without added spaces |
| `H` / `L` | Older / newer jump |
| Ctrl-J / Ctrl-K | Half-page down / up |
| Ctrl-H / Ctrl-L | First nonblank / end of line |
| Left / Right | Previous / next buffer |
| Up / Down | First / last line |
| Backspace / Shift-Backspace | Undo / redo |
| `Y` | Yank to end of line |
| Enter | Clear search highlighting and advance a line |
| `Space x` | Alternate buffer |
| `Space h/j/k/l`, Alt-h/j/k/l | Focus neighboring window |
| `Space Space h/v` | Vertical / horizontal split (your original bindings) |
| Alt-Shift-arrow | Resize window |
| `Space Left/Right` | Indent current line |
| `Space Up/Down` | Move line up/down |
| `<` / `>` (Visual) | Indent, keeping selection |
| Alt-h/j/k/l (Visual) | Move selection via mini.move |
| `Space Space t` | Terminal; Escape twice returns to Normal mode |
| `Space Space c/o/f` | Close all / open all / toggle fold |
| `Space -` | Delete empty lines, preserving yank register |
| `Space a/w/pat` | Hop to line / word / matching pattern |
| `Space Space /` | Hop to pattern |
| `Space ff/fg/fb/fh` | Find files / grep / buffers / help |
| `//`, `Space fl`, `Space //` | Search within current buffer |
| `?` | Search project; native backward search is overridden as before |
| `-`, F5, `Space 5` | Oil file browser |
| F6, `Space 6` | Undo tree |
| F8, `Space 8` | Document symbols via LSP (replaces Tagbar) |
| `Space 7` | Yank history picker; Enter pastes |
| `Space 1`, `Space Space g` | Zen writing view (replaces Goyo) |
| `Space 2`, `Space Space l` | Dim surrounding code (replaces Limelight) |
| `Space '` / `Space "` | Surround word with quotes; ys/cs/ds remain available |
| `gcc`, `gc` + motion, Alt-C | Native commenting; Alt-C also supports Visual mode |
| `Space s` | Buffer substitution with live preview; type pattern/replacement/flags |
| `Space sp/sw/sf` | Project replace / word replace / current-file replace |
| `Space gg` | Fugitive Git status; Gitsigns shows changed lines |
| `Space us/uw` | Toggle spelling / wrapping |

Project replacement uses grug-far. Enter search/replacement in its labeled fields,
review matches, then use its displayed local mappings to apply changes. It replaces
Spectre; no edits occur merely by opening the search view.

## Completion and language tools

Blink supplies suggestions from LSP, the current buffer, paths and native snippets.
Ctrl-N / Ctrl-P selects; Enter accepts a selected candidate. Nothing is preselected,
so ordinary Enter creates a newline. Ctrl-Space shows completion; Ctrl-E dismisses.
Tab / Shift-Tab moves through snippet fields and otherwise retains normal behavior.

| Keys | Action |
| --- | --- |
| `gd`, `gy`, `gi`, `gr` | Definition, type definition, implementation, references |
| `Space rn` | Rename symbol |
| `Space qf` | Code action |
| `Space lk` | Hover documentation; K is deliberately kept for paragraphs |
| `[g` / `]g` | Previous / next diagnostic |
| `Space ld` | Explain diagnostics on current line |
| `Space 0`, `Space fi` | Format buffer or Visual selection |
| `Space r`, `Space 9`, `Space run` | Save and run the current source file in a terminal pane |

The runner supports Python, JavaScript, Lua (using a clean Neovim Lua process),
shell scripts, Ruby, Perl, and Swift when their interpreters are installed.
Python uses an active virtual environment, then the nearest `.venv`/`venv`, then
`python3`. Runs start in the file's directory; filenames with spaces are supported.
Unsupported filetypes show a message. Because `Space rn` still renames symbols,
`Space r` waits briefly for a possible continuation before running.

Python uses Pyright for type analysis, Ruff for linting/import organization and
formatting. Lua uses lua-language-server and StyLua. Swift uses SourceKit when
available. Prettier formats web files, JSON and Markdown. Extra LSP servers can be
added in `plugins/languages.lua`. Servers determine project roots from their
standard project markers; search runs from Neovim's current working directory.
Launch `nvim` from your project folder, or change it with `:cd /path/to/project`.

ALE, nvim-lint, Flake8, vim-autoformat, nvim-cmp and vsnip are not installed.
Ruff replaces the old Python lint/format stack, but is not a full replacement for
Mypy's type analysis or every Bandit security rule. Configure project tools in your
project when needed. This setup uses Homebrew as tool manager, without Mason.

## Org and writing

| Keys | Action |
| --- | --- |
| `Space oa/oc` | Agenda / capture |
| `Space od` | Open today's dated Org note, creating ~/org if needed |
| `Space tt`, `Space done` | Cycle Org TODO state |
| `Space ti` | Org timestamp |
| `Space dead/sched` | Deadline / scheduling |
| `Space ts` | Insert plain current timestamp |
| `Space dict/thes` | Dictionary / thesaurus for current word |
| `Space goog` (Visual) | Google selected text |

Task and journal capture templates are preserved. Org structural operations should
be used inside Org files. Native spelling uses `z=` for suggestions, `]s` for the
next spelling issue, and `zg` to add a word.

Old minimap and browser Markdown preview shortcuts (`Space mm/mp/ms`) are omitted.
Markdown has Treesitter highlighting and the Zen writing view. Jupyter integration,
multi-cursor plugins, automatic HTML tag tools and obscure text objects are not
installed by default. mini.ai supplies useful expanded text objects (arguments,
quotes, brackets); vim-surround preserves ys/cs/ds. These are intentional reductions,
not claims that every one of the old 110 plugin features was reproduced.

## Plugins and maintenance

The plugin specs group tools by purpose: lazy.nvim manages and locks plugins;
Telescope/fzf-native and Oil handle finding/browsing; Hop handles jumps; Barbar and
Lualine show buffers/status; Gruvbox/web-devicons style the UI; which-key reveals
mappings; mini.ai/pairs/move/indentscope provide focused editing helpers; Yanky and
Undotree keep edit history; Surround/Repeat/Clever-f preserve familiar Vim editing;
Gitsigns/Fugitive handle Git; Zen/Twilight handle focus; grug-far handles replacement;
Orgmode handles notes; Blink/LSP/Conform/Treesitter provide language features.
Plenary is a shared dependency. Treesitter and the theme load at startup; most other
plugins load on files, commands, Insert mode, or after the first screen.

Use `:Lazy` to inspect plugins and timings, `:checkhealth` for environment checks,
`:ConformInfo` for formatter availability and `:checkhealth vim.lsp` for servers.
The installer runs `scripts/verify.lua` to check commands, mappings, core parsers,
and tools. Run it again with:

```sh
nvim --headless '+lua dofile(vim.fn.expand("~/dotfiles3/scripts/verify.lua"))' +qa
```

For deliberate updates, commit current changes, run `:Lazy update`, run `:TSUpdate`,
restart and verify, then review and commit `lazy-lock.json`. `:Lazy restore` returns
plugins to the committed lockfile. Parser/tool versions have separate lifecycles;
the lockfile pins plugins only. Consult the current upstream docs before major
upgrades: [Neovim LSP](https://neovim.io/doc/user/lsp/),
[Treesitter](https://github.com/nvim-treesitter/nvim-treesitter),
[Blink](https://github.com/saghen/blink.cmp), and
[Conform](https://github.com/stevearc/conform.nvim).
