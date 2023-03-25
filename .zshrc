# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

HISTCONTROL=ignorespace
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

clear

# Aliases
source $HOME/.config/aliases

#if [ -z "$TMUX" ]; then
#    tmux attach -t default || tmux new -s default
#fi

# Path to your oh-my-zsh installation.
export ZSH="/home/$USER/.oh-my-zsh"
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share/applications"

setopt clobber correct listrowsfirst chaselinks pushdtohome pushdsilent

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
export TERM="xterm-256color"
export VISUAL="lvim"

#export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
#export PATH="$PATH:$GEM_HOME/bin"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git
         asdf
         zsh-autosuggestions
         cp
         copypath
         copyfile
         zsh-completions
         sudo
         fast-syntax-highlighting
         history
         pip
         fasd
         z
         wd
         fzf
        )

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases , run `alias`.

#. /opt/asdf-vm/asdf.sh

setopt AUTO_PUSHD

if [[ -d $asdf_dir ]]; then
    source $asdf_dir/asdf.sh
    source $asdf_dir/completions/asdf.bash
fi

# Function to auto save my dotfiles
dtfpush() {
    dtf add -u
    if [ -n "$1" ]; then
        dtf commit -m "$1"
    else
        dtf commit -m $(date +%Y-%m-%d_%-kh%Mm%Ss)
    fi
    dtf push
}

# Function to auto save my notes
orgpush() {
    cd ~/Org/ && g add . && g commit -m $(date +%Y-%m-%d_%-kh%Mm%Ss) && g push
    1
}

#. ~/.asdf/plugins/java/set-java-home.zsh
export PATH=$HOME/.cargo/bin:$HOME/.local/bin:$PATH
#source $(dirname $(gem which colorls))/tab_complete.sh

# Customize fzf output (Necessary highlight and tree packages)
export FZF_DEFAULT_OPTS="--ansi --preview '(highlight -O ansi -l {} 2>/dev/null || cat {} || tree -C {}) 2>/dev/null | head -200'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Show last login whenever terminal is opened
BYellow='\033[1;33m'    # Bold Yellow
Blue='\033[0;34m'       # Blue
NC='\033[0m'            # No Color

LASTLOG=$(last --fullnames --fulltimes -i | head -n 3 | sed '/reboot/d;/no logout/d;/still logged/d' | tr -s ' ')
echo "${BYellow}Last login:${NC}"
echo "\t${Blue}Started/finish${NC}" $(echo $LASTLOG | cut -d ' ' -f4-)
echo "\t${Blue}on${NC}" $(echo $LASTLOG | cut -d ' ' -f2)
echo "\t${Blue}as${NC}" $(echo $LASTLOG | cut -d ' ' -f1)
echo "\t${Blue}from${NC}" $(echo $LASTLOG | cut -d ' ' -f3)

ACTIVELOG=$(last --fullnames --fulltimes -i | grep "still logged in" | sed 's/still logged in//' | tr -s ' ')
if [[ -n "${ACTIVELOG}" ]]; then
    echo "\n${BYellow}Still logged in:${NC}"
    echo $ACTIVELOG | while read -r line; do 
        echo "\t${Blue}Started on${NC}" $(echo $line | cut -d ' ' -f5-)
        echo "\t${Blue}on${NC}" $(echo $line | cut -d ' ' -f2)
        echo "\t${Blue}as${NC}" $(echo $line | cut -d ' ' -f1)
        echo "\t${Blue}from${NC}" $(echo $line | cut -d ' ' -f3) "\n"
    done
fi
