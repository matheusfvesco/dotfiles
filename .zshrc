#!/bin/zsh

# ensures $SHELL is also set to zsh
export SHELL=/bin/zsh

PLUGINS_DIR="$HOME/.zsh_addons"
if [ ! -d $PLUGINS_DIR ]; then
    mkdir "$PLUGINS_DIR"
fi
# higher precedence
source $PLUGINS_DIR/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source /etc/zsh_command_not_found # sudo apt install command-not-found

# adds home bin folder to path, if it already wasn't there
if ! [[ ":$PATH:" == *":$HOME/bin:"* ]]; then
    export PATH="$HOME/bin:$PATH"
fi


# Check if .aliases exists and sources it
[[ -f $HOME/.aliases ]] && source $HOME/.aliases

# Check if .aliases.local exists and sources it
# this can be used to set aliases for your specific environment
[[ -f $HOME/.aliases.local ]] && source $HOME/.aliases.local


# Check if poetry is installed and sets up completions
if command -v poetry &> /dev/null; then
    [ ! -f ~/.zfunc ] && mkdir -p ~/.zfunc &> /dev/null
    [ ! -f ~/.zfunc/_poetry ] && poetry completions zsh > ~/.zfunc/_poetry
    fpath+=~/.zfunc
    autoload -Uz compinit && compinit
fi

# uses tmux as the default terminal in ssh incoming connections                                                                                        
if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then                                                            
    tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux                                                          
fi

# Starts starship
eval "$(starship init zsh)"