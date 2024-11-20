# running this file assumes you don't have existing files
ln -s $(pwd)/nvim ~/.config
ln -s $(pwd)/tmux/.tmux.conf ~/.tmux.conf
mkdir -p ~/.config/tms
ln -s $(pwd)/tmux-sessionizer/config.toml ~/.config/tms/config.toml
