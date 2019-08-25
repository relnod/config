[color]
    diff = auto
    status = auto
    branch = auto
    interactive = auto
    ui = true
    pager = true
[user]
    email = {{ .GitEmail }}
    name = {{ .GitUser }}

[include]
    path = ~/.config/git/.gitconfig
