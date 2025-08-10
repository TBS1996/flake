# ===== Prompt (like your PS1) =====
def create_prompt [] {
  let u = (whoami)
  let h = (hostname)
  let p = (pwd)
  $"(ansi red_bold)[(ansi yellow_bold)$u(ansi green_bold)@(ansi blue_bold)$h (ansi magenta_bold)$p(ansi red_bold)](ansi reset)$ "
}

# ===== lfcd (ctrl-o): open lf and cd to last dir =====
def lfcd [...args] {
  let tmp = (mktemp)
  ^lf --last-dir-path $tmp ...$args
  if ($tmp | path exists) {
    let dir = (open $tmp | str trim)
    rm $tmp
    if ($dir != "" and $dir != (pwd)) { cd $dir }
  }
}

# ===== Git / Nix / misc helpers (multi-step -> defs) =====
def gap [] { ^git add .; ^git commit -m "wip"; ^git push }
def gac [] { ^git add --all; ^git commit -m wip }
def gc [msg:string] { ^git add .; ^git commit -m $msg }
def gcb [name:string] { ^git checkout -b $name }
def gcm [] { ^git checkout main }
def gb [] { ^git branch }
def gp [] { ^git pull }
def gam [] { ^git add --all; ^git commit --amend --no-edit }

def grn [] {
  cd /home/tor/flake
  ^nix fmt
  ^nix flake update
  ^git add .
  ^git commit -m "rebuilding"
  ^git push
  ^sudo nixos-rebuild switch --flake .#sys
  ^swaymsg reload
  cd -
}
def grl [] {
  cd /home/tor/flake
  ^nix fmt
  ^sudo nixos-rebuild switch --flake .#sys
  ^swaymsg reload
  cd -
}
def grp [] {
  cd ~/flake
  ^sudo nixos-rebuild switch --flake .#sys
  ^swaymsg reload
}

def cerr [] { ^cargo build --quiet --message-format=short | lines | where ($it !~ 'warning') | str join (char nl) }

def amend [] { ^git add --all; ^git commit --amend --no-edit }
def treegit [] { ^git ls-tree -r --name-only HEAD | ^tree --fromfile }
def tg [] { treegit }
def i [] { ^wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ }
def u [] { ^wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1- }
def totfmt [] { ^cargo fmt; ^git add --all; ^git commit -m fmt; ^cargo fix; ^git add --all; ^git commit -m fix }
def plan [] { cd ~/prog/timeplan; ^nix develop; ^python main.py }
def chat [] { ^zellij --layout chat }
def webcam [] { ^mpv av://v4l2:/dev/video0 }

# ===== Aliases (single-command shorthands) =====
alias nd = nix develop
alias ndc = nix develop .#rust
alias kv = /home/tor/flake/scripts/kvmenu.sh
alias pg = ping google.com
alias scl = systemctl
alias z = zellij
alias nb = newsboat -r
alias y = yazi
alias nt = nmtui
alias cc = calcurse
alias dp = dagplan
alias td = tordo

# ===== Defs (multi-command or block-style) =====
def flakefix [] {
  f
  rm -r etc/libcar/target
  rm -r etc/excar/target
}

# work
def ndt [] { cd ~/myflakes/terraform; nix develop }
def infra [] { cd ~/prog/infrastructure }
def tf [] { cd ~/prog/terraform }
def lts [] { cd ~/prog/local-test-services }

# cd shortcuts
def f [] { cd /home/tor/flake }
def p [] { cd /home/tor/prog }
def s [] { cd /home/tor/prog/speki }
def c [] { cd /home/tor/.config }
def n [] { cd /home/tor/velv; hx main.md }

# misc
def xexit [] { pkill -KILL -u $env.USER }

# copy: works with a file OR piped input
#   cpy some.txt
#   cat some.txt | cpy
def cpy [file?: path] {
  if $file != null {
    open $file | ^wl-copy
  } else {
    $in | ^wl-copy
  }
}

def work [...args] {
  p
  cd infrastructure/services/turbofish
  ndc
  code . ...$args
}


# ===== Shell UI / behavior =====
$env.PROMPT_COMMAND = { create_prompt }
$env.PROMPT_INDICATOR = { " " }
$env.PROMPT_MULTILINE_INDICATOR = { "… " }

# Disable welcome banner + set history & completion & vi mode + keybinds
$env.config = ($env.config | default {} | merge {
  show_banner: false
  edit_mode: vi
  history: {
    max_size: 10000
    file_format: "plaintext"
    sync_on_enter: true
  }
  completions: {
    algorithm: "fuzzy"
    case_sensitive: false
    external: { enable: true }
  }
  keybindings: [
    # Vim-like movement in menus
    { name: menu-left  mode: [emacs, vi_insert, vi_normal] key: "h" event: { send: menu_left  } }
    { name: menu-up    mode: [emacs, vi_insert, vi_normal] key: "k" event: { send: menu_up    } }
    { name: menu-right mode: [emacs, vi_insert, vi_normal] key: "l" event: { send: menu_right } }
    { name: menu-down  mode: [emacs, vi_insert, vi_normal] key: "j" event: { send: menu_down  } }

    # Ctrl-e: edit current command in $EDITOR
    { name: open-editor mode: [emacs, vi_insert, vi_normal] modifier: ctrl key: "e" event: { send: OpenEditor } }

    # Ctrl-o: run lfcd
    { name: lfcd mode: [emacs, vi_insert, vi_normal] modifier: ctrl key: "o"
      event: { send: ExecuteHostCommand, cmd: "lfcd" } }
  ]
})

