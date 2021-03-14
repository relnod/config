[color]
    diff = auto
    status = auto
    branch = auto
    interactive = auto
    ui = true
    pager = true
[pull]
    rebase = true
[user]
    email = {{ .GitEmail }}
    name = {{ .GitUser }}
    signingkey = {{ .GitSignKey }}

[commit]
    gpgsign = true

[ore]
	excludesFile = ~/.config/git/gitignore

[include]
    path = ~/.config/git/.gitconfig
