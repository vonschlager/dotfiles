# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
DEFAULT_USER=jacek
EDITOR=vim
VISUAL=vim

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
SOLARIZED_THEME="dark"
ZSH_THEME="jacek"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias feh="feh -NF"
alias mpa="mplayer -novideo"
alias bower='noglob bower'

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git archlinux lein docker docker-compose)

source $ZSH/oh-my-zsh.sh

# User configuration

bindkey -v
bindkey "^?" backward-delete-char

export PATH="/home/jacek/.bin:/home/jacek/.cabal/bin:./.cabal-sandbox/bin:/opt/ghc783/bin:/home/jacek/.bin:/home/jacek/.cabal/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
export PATH=$PATH:"/home/jacek/elm/Elm-Platform/0.16/.cabal-sandbox/bin"
export PATH=$PATH:"/opt/android-sdk/platform-tools"
export NODE_PATH="/usr/lib/node_modules"
# export MANPATH="/usr/local/man:$MANPATH"
if [[ -f ~/.dircolors ]] ; then
    eval $(dircolors -b ~/.dircolors)
fi

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
# export ANT_OPTS="-Xmx1024m -XX:MaxPermSize=512m"

# OPAM configuration
. /home/jacek/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
