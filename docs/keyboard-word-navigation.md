# Keyboard Word Navigation (Option+F / Option+B)

Findings from diagnosing why Option+F / Option+B (jump forward/backward a
word) didn't work in Ghostty on macOS, while working fine in iTerm2 and in
native Cocoa apps.

## Two independent layers

Word navigation via Option+F/B depends on two unrelated systems, each of
which must be configured separately:

1. **macOS / Cocoa text fields** (native GUI apps: Notes, Xcode, Finder
   rename, etc.) — controlled by `~/Library/KeyBindings/DefaultKeyBinding.dict`.
   This file remaps the Option key to act as Meta and binds `moveWordForward:`
   / `moveWordBackward:` to it. Tracked in this repo at
   `keybindings/DefaultKeyBinding.dict`, symlinked into place by `setup.sh`.

2. **Terminal / shell** (Ghostty, iTerm2, etc.) — controlled by the
   terminal emulator's own "Option key sends Alt/Meta" setting. The terminal
   must translate Option+F into the byte sequence `ESC f` (and Option+B into
   `ESC b`) before the shell ever sees a keypress. zsh's emacs-mode
   keybindings (`bindkey`: `"^[f" forward-word`, `"^[b" backward-word`,
   `"^["` being ESC) fire on that byte sequence — but only if the terminal
   sends it.

These layers do not interact. Fixing one has no effect on the other.

## Why a zsh-level fix can't solve a terminal-level problem

`select-word-style` (used in `~/.zshrc`) changes what counts as a "word"
boundary for an *already-firing* `forward-word`/`backward-word` keybinding —
e.g. whether `foo_bar` is one word or two. It cannot make a keybinding fire
that isn't firing in the first place. If the terminal never sends `ESC f`,
zsh's `forward-word` binding never triggers, and no amount of
`select-word-style` configuration changes that. The two problems are
frequently conflated because both involve the word "word navigation," but
they sit on opposite sides of the terminal/shell boundary.

## Root cause and fix (this machine)

Ghostty's config file (`~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`)
was empty (0 bytes) — an auto-created placeholder, never edited. With no
config, Ghostty's `macos-option-as-alt` setting sits at its default `false`:
Option is left as macOS's special-character composer, so Ghostty never sends
`ESC f` / `ESC b`, and zsh's keybindings never fire.

Fix: set `macos-option-as-alt = true` in Ghostty's config. Tracked in this
repo at `ghostty/config`, symlinked into place by `setup.sh`.

iTerm2 has the equivalent setting under Profiles → Keys → "Option key sends"
→ Esc+ (or "Left/Right Option Key Acts As: +Esc"), which is why Option+F/B
already worked there.

## Tradeoff

Setting `macos-option-as-alt = true` disables Option-based special-character
composition in Ghostty (e.g. Option+E then a letter for é, Option+N then N
for ñ). This is a real loss for typing accented characters directly in the
terminal.

If this tradeoff matters later, Ghostty supports binding only one Option key
(`macos-option-as-alt = left` or `right`) — keep one Option key for Alt/Meta
and the other for character composition.

## Scope limits

Sandboxed macOS apps (Mail, Notes, and most App Store-distributed apps) run
under an App Sandbox entitlement that does not grant read access to
`~/Library/KeyBindings/`. `DefaultKeyBinding.dict` never reaches these apps,
regardless of its content — this is a platform restriction, not a
configuration gap. Non-sandboxed Cocoa apps (Xcode, most command-line-adjacent
GUI tools) do read it.
