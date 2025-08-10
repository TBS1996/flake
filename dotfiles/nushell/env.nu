# PATH tweaks
let home = $nu.home-path
$env.PATH = ($env.PATH
  | split row (char esep)
  | append "/home/tor/.cache/cargo/bin"
  | append $"($home)/.local/bin"
  | uniq
  | str join (char esep)
)

# Optional: editor for Ctrl-e behavior
if ($env.EDITOR? | is-empty) { $env.EDITOR = "nvim" }
