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



export BAT_THEME="Catppuccin Mocha"
export "MICRO_TRUECOLOR=1"


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

# POWER
alias shutnow='shutdown now'
alias suspend='systemctl suspend'

# DISPLAY / GPU
alias checkmod='supergfxctl -g'
alias listmod='supergfxctl -s'
alias modintel='supergfxctl -m Integrated'
alias modhybrid='supergfxctl -m Hybrid'
alias ac='kscreen-doctor output.eDP-2.mode.1920x1200@60 && sleep 3 && modintel && loginctl terminate-user $USER'
alias plug='kscreen-doctor output.eDP-2.mode.1920x1200@165 && sleep 3 && modhybrid && loginctl terminate-user $USER'

# NAVIGATION
alias docs='cd Documents'
alias rice='cd Rice'
alias uni='cd uniStuff'
alias dl='cd Downloads'
alias lt='ls -lht'
alias lz='ls -lhS'
alias la='ls -A'

# GIT
alias gs='git status'
gacp() {
  if [ -z "$1" ]; then
    echo "isi commit message dulu njinggs"
    return 1
  fi
  git add .
  git commit -m "$1"
  git push
}

# EDITORS
alias nano='micro'
alias vim='nvim'
alias vi='nvim'

# FILE VIEWERS
alias see='bat'
alias view='gwenview'
alias zat='zathura'

# SHELL UTILS
alias ls='eza --icons --group-directories-first'
alias grep='grep --color=auto'
alias color='color_check'


# FETCH / INFO
alias morefetch='fastfetch -c ~/.config/fastfetch/morefetch.jsonc'
alias clock='tty-clock -s -c -C 5'

# FUN
alias aq='asciiquarium'
alias pipes='pipes.sh'
alias q='fortune | cowsay -r'
alias plis='sudo'



if [[ "$TERM_PROGRAM" != "vscode" ]]; then
    fastfetch
fi

# OH MY ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
    zsh-autosuggestions
    zsh-completions
    sudo
    fzf
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
