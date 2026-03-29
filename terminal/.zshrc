if [[ "$TERM_PROGRAM" != "vscode" ]]; then
   fastfetch -c ~/.config/fastfetch/small.jsonc
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=on
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export TERM=xterm-256color
export LS_COLORS=""
export BAT_THEME="Catppuccin Mocha"
export "MICRO_TRUECOLOR=1"
export EZA_CONFIG_DIR="$HOME/.config/eza/"
export EDITOR=micro
export VISUAL=micro
export COLORTERM=truecolor

export PATH="$HOME/.cargo/bin:$PATH"
export GOPATH=$HOME/.go
export PATH="$GOPATH/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$HOME/.local/bin:$PATH"

bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history

setopt auto_cd
setopt interactive_comments
setopt multios
setopt histexpand

arch_news_check() {
    echo "🔔 Latest Arch Linux news:"
    curl -s https://archlinux.org/news/ \
      | grep -Eo 'href="/news/[^"]+"' \
      | cut -d'"' -f2 \
      | head -n 5 \
      | sed 's|^|https://archlinux.org|'
}

color_check() {
for i in {0..255}; do
        printf "\e[48;5;%sm%3d " "$i" "$i"
    if (( (i + 1) % 16 == 0 )); then
        printf "\e[0m\n"
    fi
done
}

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    zsh-autosuggestions
    sudo
)

skip_global_compinit=1                          
autoload -Uz compinit 
if [[ -n /tmp/zcompdump-$USER(#qN.mh+24) ]]; then
  compinit -d /tmp/zcompdump-$USER
else
  compinit -C -d /tmp/zcompdump-$USER
fi

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

# FZF
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

#     ___   ___                
#    / _ | / (_)__ ____ ___ ___
#   / __ |/ / / _ `(_-</ -_|_-<
#  /_/ |_/_/_/\_,_/___/\__/___/

# SYSTEM
alias up='paru -Syu'
alias clean='sudo paccache -rk2 && paru -c'
alias pacnews='arch_news_check'
alias upgrub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias zshnew='source ~/.zshrc'
alias gmn='npx @google/gemini-cli'

# POWER
alias sn='shutdown now'
alias suspend='systemctl suspend'
alias rb='reboot'

# DISPLAY / GPU
alias checkmod='supergfxctl -g'
alias listmod='supergfxctl -s'
alias modintel='supergfxctl -m Integrated'
alias modhybrid='supergfxctl -m Hybrid'
alias nv='nvim'


# GIT
alias gs='la && git status'
gacp() {
  if [ -z "$1" ]; then
    echo "isi commit message dulu njinggs"
    return 1
  fi
  git add .
  git commit -m "$1"
  git push
}
alias gp='git pull'

# EDITORS
alias nano='micro'
alias vim='nvim'
alias vi='nvim'
alias mic='micro'

# FILE VIEWERS
alias see='bat'
alias view='gwenview'
alias zat='zathura'
take() {
  mkdir -p "$1" && cd "$1"
}

# NAVIGATION
alias docs='cd Documents'
alias rice='cd Rice'
alias uni='cd uniStuff'
alias dl='cd Downloads'
alias sz='du -sh * | sort -h'
alias y='yazi'
unalias ls
alias ls='eza -l -h --sort=modified --reverse --color=always --icons --git --group-directories-first'
alias lss='eza -l -h --sort=modified --reverse --color=always --icons --git --group-directories-first -G'
alias la='ls -A'
alias lsa='la -G'
alias lt='ls -T'
alias c='clear'
alias x='exit'
# SHELL UTILS
alias color='color_check'
alias grep='rg --color=auto --smart-case'
alias cd='z'
alias find='fd'

fuck() { sudo $(fc -ln -1) }
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *) echo "Format tolol." ;;
    esac
  else
    echo "mana filenya su."
  fi
}

# FETCH / INFO
alias morefetch='fastfetch -c ~/.config/fastfetch/morefetch.jsonc'
alias clock='tty-clock -s -c -C 5'

# FUN
alias aq='asciiquarium'
alias pipes='pipes.sh'
alias q='fortune | cowsay -r'
alias plis='sudo'
weather() {
  curl wttr.in/"$1"
}
alias udanraksu='weather semarang'

f() { eval $(thefuck $(fc -ln -1)); }

# STARSHIP (LAST)
#eval "$(starship init zsh)"

# Created by `pipx` on 2025-12-31 05:14:11
export PATH="$PATH:/home/reval/.local/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(zoxide init zsh)"

