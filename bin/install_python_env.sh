sudo apt update
sudo apt install pipx
pipx ensurepath

pipx install ruff
ruff generate-shell-completion zsh > ~/.zfunc/_ruff

curl -LsSf https://astral.sh/uv/install.sh | sh
uv generate-shell-completion zsh > ~/.zfunc/_uv
