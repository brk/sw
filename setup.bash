#!/bin/bash

set -euo pipefail

# Makes a link AT $1 POINTING TO $2
# Note that this is the opposite semantics of `ln`
function link_to {
	if [[ -h "$1" ]]; then # if it's a symlink
		rm "$1" # relink it (might link to same file as old link, that's okay)
	elif [[ -f "$1" ]]; then # it's a regular file
		echo "setup.bash refusing to delete existing file:" "$1"
		echo "                         when symlinking to " "$2"
		exit 1
	fi
	ln -s "$2" "$1" # We've cleared the way to lay down a symlink!
}

mkdir -p ~/config
link_to ~/.config/fish ~/sw/config_fish

mkdir -p ~/config/jj
link_to ~/.config/jj/config.toml ~/sw/jj_config.toml
# machine-specific configs can go in ~/.config/jj/conf.d/*.toml

mkdir -p ~/.local/bin

### uv
curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
# update via `uv self update`

mkdir -p ~/.local/share/fish/vendor_completions.d
echo 'uv generate-shell-completion fish | source' > ~/.local/share/fish/vendor_completions.d/uv.fish
echo 'uvx --generate-shell-completion fish | source' > ~/.local/share/fish/vendor_completions.d/uvx.fish

### llm
uv tool install llm

# llm keys set openai
# llm keys set anthropic

### jq
/bin/bash ./bin/:get-jq.sh

### jj
/bin/bash ./bin/jjup.sh

### fish
/bin/bash ./bin/:get-fish.sh

### run fish
~/.local/bin/fish
