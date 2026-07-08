export PYENV_ROOT="$HOME/.pyenv"
export DENO_INSTALL="$HOME/.deno"
export NIVM_DIR=/opt/nvim-linux-arm64
path+=(
  /snap/bin(N-/)
  $HOME/.local/bin(N-/)
  $NVIM_DIR/bin(N-/)
  $HOME/bin/chezmoi(N-/)
  $HOME/.nvm(N-/)
  $DENO_INSTALL/bin(N-/)
  $PYENV_ROOT/bin(N-/)
  $HOME/.cargo/env(N-/)
)

if type nvim > /dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

if [ -d $PYENV_ROOT ]; then
 eval "$(pyenv init -)"
 eval "$(pyenv virtualenv-init -)"
fi

# 重複排除とパスの順序維持
typeset -U path PATH
