# karabiner

macOS keyboard layout, replacing kanata on this machine. Linux still runs
`kanata/kanata.kbd` through `hypr/kanata.service`; the two keymaps are now
independent files, so a mapping change has to be made in both.

## Why karabiner and not kanata

kanata's macOS backend is a root grabber (`kanata --cfg ... --macos-dev-vhkd`)
that talks to the Karabiner VirtualHIDDevice daemon. That daemon ships inside
Karabiner-Elements: kanata needs driver protocol 5 (driver v6.2.0), the daemon
installed by Karabiner-Elements 16.3.0 is driver v8.5.0 and rejects it. Running
both is not possible, and pinning the old driver means pinning an old
Karabiner-Elements too. Karabiner-Elements does the same job natively.

## Install / migrate from kanata

1. Stop and remove the kanata LaunchDaemon first - it grabs the keyboard and
   its driver no longer matches the daemon Karabiner-Elements installs:

   ```sh
   sudo launchctl bootout system /Library/LaunchDaemons/dev.kanata.kanata.plist
   sudo rm /Library/LaunchDaemons/dev.kanata.kanata.plist
   ```

2. `brew install --cask karabiner-elements` (16.3.0, macOS 13+). Not
   `pkgs.karabiner-elements`: nixpkgs pins 15.7.0, and a store-path app bundle
   changes path on every switch, invalidating the TCC grant and the DriverKit
   system extension.

3. Launch it once and finish the two approvals:
   - allow the background item, then grant Accessibility to Karabiner-Elements;
   - `Login Items & Extensions > Driver Extensions`: allow
     `org.pqrs.Karabiner-DriverKit-VirtualHIDDevice`.

   Verify the extension:

   ```sh
   systemextensionsctl list | grep -i pqrs
   # ... [activated enabled]   (version 8.5.0, not the old kanata 6.2.0)
   ```

   The 8.5.0 extension replaces kanata's 6.2.0 in place; if the list still
   shows 6.2.0 after the approval, reboot once.

4. `hms` (links `~/.config/karabiner` to this directory). If a settings change
   made in the GUI is not picked up after the first link:

   ```sh
   launchctl kickstart -k gui/$(id -u)/org.pqrs.service.agent.Karabiner-Console-User-Server
   ```

Going back to kanata needs the plist from git history *and* a driver
downgrade (6.2.0); Karabiner-Elements 16.3.0 installs 8.5.0 and there is no
supported way to keep both.

## Layout of this directory

`~/.config/karabiner` is a symlink to this directory
(`config/darwin.nix`, `mkOutOfStoreSymlink`), so Karabiner-Elements' writes land
in the repo. It rewrites `karabiner.json` on every settings change, so GUI edits
show up in `git status`, and any comment added to the JSON is lost on save -
this README is the place for prose.

`assets/` and `automatic_backups/` are Karabiner-Elements runtime directories,
git-ignored.

## Profiles

Two profiles, `selected` decides which one is live at load:

| profile | contents | use |
| --- | --- | --- |
| `kanata` | the keymap below, parameters 175/175/500 | normal use, `selected: true` |
| `Default` | no simple modifications, no rules, default parameters | plain keyboard, for A/B a misbehaving rule |

Switch at runtime from the menu bar (Karabiner-Elements > Preferences >
Profiles) or via the CLI, which writes back into this same file:

```sh
/Applications/Karabiner-Elements.app/Contents/MacOS/karabiner_cli --select-profile kanata
/Applications/Karabiner-Elements.app/Contents/MacOS/karabiner_cli --show-current-profile-name
```

`Default` intentionally has no `basic.to_if_*` overrides, so it uses
Karabiner-Elements' own defaults; the keymap profile inherits nothing from it.

## Mapping

Global parameters: `to_if_alone` 175 ms, `to_if_held_down` threshold 175 ms
(the kanata `tap-time` / `hold-time`), delayed-action delay 500 ms.

| key | tap | hold |
| --- | --- | --- |
| `a s d f j k l` | letter | `cmd opt shift ctrl ctrl shift opt` |
| `left command` | `esc` | `left` layer |
| `right command` | `tab` | `right` layer |
| `left option` | | sends `left command` |
| `right option` | | sends `right command` |
| `;` | | `return` |
| `/` | | `backspace` |

The two keys next to space carry the layers because on a Mac keyboard that is
`command`, not `option`. To keep `command` usable, `option` and `command` swap
identities: the `option` keys send `command` (`from left_option`/`right_option`
-> `to left_command`/`right_command` in "Base remaps"), so `cmd+c` is typed as
`option`+`c` or as home-row `a` hold + `c`. `option` as a modifier is on the
home row (`s`, `l`).

Where each modifier comes from, in full:

| modifier | instant | 175 ms hold |
| --- | --- | --- |
| `command` left | `left option` | `a` |
| `command` right | `right option` | - |
| `control` left | physical `ctrl` | `f` |
| `control` right | physical `ctrl` | `j` |
| `option` left | - | `s` |
| `option` right | - | `l` |
| `shift` | physical `shift` | `d` (left), `k` (right) |

Holds stack (`f` then `a` -> `ctrl`+`command`). `caps_lock`, both physical
`ctrl` keys and both `shift` keys have no rule, so they keep their normal
meaning; only `command` (taken by the layers) and `option` (turned into
`command`) change identity.

`right` layer (hold right command): `q..p` -> `1..0`, `a` -> forward delete,
`h j k l` -> arrows, `left command` -> `esc`.

`left` layer (hold left command): shifted digits on `q..i` (`shift`+`1..8`),
`o`/`p` -> backtick/tilde, `a` -> `"`, `s`/`d` -> `[`/`{`, `f` -> `(`, `h` ->
`/`, `j` -> `-`, `k` -> `=`, `l` -> `:`, `;` -> `;`, `z` -> `'`, `x`/`c` ->
`]`/`}`, `v` -> `)`, `n` -> `\`, `m` -> `_`, `,` -> `+`, `.` -> `|`, `/` ->
`?`. Every rule matches with modifiers held (`optional: ["any"]`), so a base
letter still works under a real modifier - `cmd`+tap `a` sends `cmd`+`a`, and
holding `a` past 175 ms with `cmd` down commits `left_command` (already down) and
types nothing.

Kanata's `mid` layer was commented out in its keymap and is not carried over.

## Differences from kanata

- **Rolling on the home row.** Karabiner-Elements cannot hold a key back while a
  dual-role key is undecided; it has to decide on the spot. The recipe here is
  Karabiner's own advanced `to_if_held_down` example: `to_if_alone` (halt) sends
  the letter when the key is tapped alone, `to_if_held_down` (halt) sends the
  modifier at 175 ms, and `to_delayed_action.to_if_canceled` sends the letter
  when another key is pressed first. So a fast roll still types both letters in
  order, but a chord that starts inside 175 ms is typed as letters instead of
  receiving the modifier. Hold the home-row key for 175 ms before the chord key.
  (kanata buffered the chord key and applied the modifier retroactively.)
- **Layer timing.** The layer keys set their variable from `to`, so a layer is
  armed at key-down (Karabiner's documented virtual-modifier pattern); kanata
  armed at 175 ms. A key pressed inside those 175 ms is therefore mapped through
  the layer (kanata sent the base key), and a tap that overlaps another key
  sends no `esc`/`tab` (`to_if_alone` needs a release with no other key; kanata
  sent it). The closest alternative, arming from `to_if_held_down`, is worse:
  Karabiner cancels that timer on *any* key-down before it even matches `from`
  (`basic.hpp`, the home-row roll handling), so one fast key would leave the
  layer dead for the rest of the hold. A plain tap is still `esc`/`tab`, and a
  hold past 175 ms released without another key is silent, as in kanata.
- **Layer key identity.** kanata's `lalt`/`ralt` were Alt, the key next to space
  on a PC layout; on a Mac keyboard that key is `command`, so the layers moved
  to `command` and `option`/`command` swapped identities (`option` sends
  `command`). The physical `command` keys therefore never send `command` -
  `command` comes from either `option` key or from a home-row `a` hold
  (`left_command`); `j` is `right_control`, not `command`.
- **Both layers held.** Karabiner-Elements uses plain boolean variables, so one
  order is fixed in the file: the `right` layer rules come first and win.
  kanata used the most recently pressed layer.
- **`process-unmapped-keys yes`** has no equivalent and is not needed: keys with
  no rule pass through unchanged.
- **Caps lock LED / `set_caps_lock_led`** is untouched; kanata did not drive it
  either.

## Verify

```sh
python3 -m json.tool karabiner.json > /dev/null   # parse
python3 -c 'import json;[print(p["name"], p["selected"], len(p["complex_modifications"]["rules"])) for p in json.load(open("karabiner.json"))["profiles"]]'
/Applications/Karabiner-Elements.app/Contents/MacOS/karabiner_cli --show-current-profile-name
```

The profile line must print `kanata True 5` then `Default False 0`, and the CLI
must answer `kanata`. If `Default` shows `selected` true, the GUI switched
profiles - that is a real change, commit it or switch back.

Live check: hold a home-row key for a second and press another key - the
modifier applies; tap it - the letter is typed. Hold `right command` and press
`h` - left arrow. `option`+`c` in a text field - copy. Then check Settings > Log
if a rule does not fire.
