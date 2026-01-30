# Created by newuser for 5.9

# BASIC ENV & KEYBIND
export TERM=xterm-256color

bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history

setopt auto_cd
setopt interactive_comments
setopt multios

arch_news_check() {
    echo "🔔 Latest Arch Linux news:"
    curl -s https://archlinux.org/news/ \
      | grep -Eo 'href="/news/[^"]+"' \
      | cut -d'"' -f2 \
      | head -n 5 \
      | sed 's|^|https://archlinux.org|'

    echo
    read -p "Do you want to continue with the system upgrade? [y/N] " answer
    if [[ "$answer" =~ ^[yY]$ ]]; then
        sudo pacman -Syu
    else
        echo "⏹️ Upgrade cancelled."
    fi
}

color_check() {
for i in {0..255}; do
        printf "\e[48;5;%sm%3d " "$i" "$i"
    if (( (i + 1) % 16 == 0 )); then
        printf "\e[0m\n"
    fi
done
}

gacp() {
  if [ -z "$1" ]; then
    echo "isi commit message dulu njinggs"
    return 1
  fi
  git add .
  git commit -m "$1"
  git push
}

# ALIASES
alias up='paru -Syu'
alias clean='sudo paccache -rk1 && paru -c'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias shutnow='shutdown now'
alias suspend='systemctl suspend'
alias aq='asciiquarium'
alias pipes='pipes.sh'
alias zshnew='source ~/.zshrc'
alias rain='terminal-rain --rain-color white --lightning-color yellow'
alias clock='tty-clock -s -c -C 5'
alias checkmod='supergfxctl -g'
alias ls='eza --icons --group-directories-first'
alias pacnews="arch_news_check"
alias morefetch="fastfetch"
alias quote='fortune | cowsay -r'
alias color="color_check"
alias modintel='supergfxctl -m Integrated'\
alias modhybrid='supergfxctl -m Hybrid'
alias listmod='supergfxctl -s'
alias gs='git status'



if [[ "$TERM_PROGRAM" != "vscode" ]]; then
    fastfetch
fi

# OH MY ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
    zsh-autosuggestions
    zsh-completions
)

source $ZSH/oh-my-zsh.sh


# COMPLETION BEHAVIOR
zstyle ':completion:*' menu select
setopt AUTO_MENU
unsetopt MENU_COMPLETE

# nicer matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'


# AUTOSUGGESTIONS
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'


# SYNTAX HIGHLIGHTING
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null












# ===============================
# STARSHIP (LAST)
# ===============================
eval "$(starship init zsh)"


# Created by `pipx` on 2025-12-31 05:14:11
export PATH="$PATH:/home/reval/.local/bin"
