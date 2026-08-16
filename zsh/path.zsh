# ============================================================
# path
# ============================================================

# fzfはプラグインディレクトリにインストール
export FZF_INSTALL=$HOME/.zsh/plugins/fzf
path+=(
  /snap/bin(N-/)
  $HOME/.local/bin(N-/)
  $HOME/bin(N-/)
  $FZF_INSTALL/bin(N-/)
)

if type nvim > /dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# 重複排除とパスの順序維持
typeset -U path PATH
