# WSL2 Wezterm

## Create a symbolic link
e.g.
```mklink /D C:\Users\antho\.config\wezterm \\wsl.localhost\Ubuntu-24.04\home\dang\repos\dotfiles\wsl\wezterm```
```mklink /D C:\Users\antho\.glzr\glazewm \\wsl.localhost\Ubuntu-24.04\home\dang\repos\dotfiles\wsl\glazewm```

- Linux/Ubuntu
```ln -s ~/repos/dotfiles/wsl/zsh/.zshrc ~/.zshrc```



tools:

- glazewm
- wezterm
- zsh
- ohmyzsh
- zoxide
- fzf
- thefuck
- ripgrep
- (dotenv-linter)[https://github.com/dotenv-linter/dotenv-linter]

zsh plugins:
- zsh-autosuggestions
- zsh-syntax-highlighting
- zsh-completions


```
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```