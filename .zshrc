#!/bin/zsh

# ensures $SHELL is also set to zsh
export SHELL=/bin/zsh

PLUGINS_DIR="$HOME/.zsh_addons"
if [ ! -d $PLUGINS_DIR ]; then
    mkdir "$PLUGINS_DIR"
fi

# REALLY IMPORTANT FOR AUTOCOMPLETE
setopt interactivecomments

# this on top of autocomplete fixes "unhandled ZLE widget"
source $PLUGINS_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# higher precedence than other plugins
source $PLUGINS_DIR/zsh-autocomplete/zsh-autocomplete.plugin.zsh

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

# loads all autocompletions from ~/.zfunc
for file in "$HOME/.zfunc"/*; do
    [ -f "$file" ] && source "$file"
done


# uses tmux as the default terminal in ssh incoming connections                                                                                        
if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then                                                            
    tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux                                                          
fi

# Starts starship
eval "$(starship init zsh)"