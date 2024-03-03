#!/usr/bin/env fish

function install_dotfiles --description "Install the dotfiles using chezmoi"
	# exit early if the data already exists
	test -d ~/.local/share/chezmoi/; and exit 0

	git clone --depth 1 git@github.com:nachtjasmin/dotfiles.git ~/.local/share/chezmoi/
	cd ~/.local/share/chezmoi/
	./install.sh
end

if status --is-interactive
	install_dotfiles
end

