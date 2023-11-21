if [[ -r $HOME/.zsh/welcome.sh ]]; then
  $HOME/.zsh/welcome.sh
fi

# Prompt settings
autoload -Uz add-zsh-hook vcs_info
add-zsh-hook precmd vcs_info

# See https://man.archlinux.org/man/zshmisc.1#EXPANSION_OF_PROMPT_SEQUENCES
setopt prompt_subst
PROMPT='%B%F{blue}%~ %b%F{8}${vcs_info_msg_0_}%(?.%F{green}.%F{red}%B[%?] )%#%f%b '
RPROMPT="%F{magenta}%n@%m"

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '(%b%u%c) '

# Path
path+=("$HOME/.local/bin")
path+=("$HOME/.cargo/bin")
export PATH

# History settings
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY HIST_SAVE_NO_DUPS HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS

# Bind useful keys
bindkey "^[[3~" delete-char
bindkey '5~' kill-word
bindkey '^H' backward-kill-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Kitty aliases
if [[ "$TERM" = "xterm-kitty" ]]; then
  alias ssh="kitten ssh"
fi

# Other aliases
alias ll="ls -lh --color=auto"

if [[ -x "$(command -v doas)" ]]; then
  alias sudo="doas"
else
  echo "doas not found, alias disabled"
fi

if [[ -x "$(command -v cht.sh)" ]]; then
  alias cht="cht.sh"
else
  echo "cht.sh not found, alias disabled"
fi

if [[ -x "$(command -v bat)" ]]; then
  alias cat="bat --paging=never"
else
  echo "bat not found, alias disabled"
fi

mkcd ()
{
  mkdir -p -- "$1" &&
    cd -P -- "$1"
}

# Enable libusb for adb
export ADB_LIBUSB=1

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ZSH plugins
ZSH_CACHE_DIR=~/.cache/zsh
ZSH_AUTOSUGGEST_STRATEGY=(completion history)

plugins=(
  /usr/share/doc/pkgfile/command-not-found.zsh
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Should be sourced last
)

for plugin in ${plugins[@]} ;do
  if [[ -r $plugin ]]; then
    source $plugin
  fi
done
