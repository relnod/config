[color]
    diff = auto
    status = auto
    branch = auto
    interactive = auto
    ui = true
    pager = true
[user]
    email = {{ .GitUser }}
    name = {{ .GitEmail }}

[include]
    path = ~/.config/git/.gitconfig
