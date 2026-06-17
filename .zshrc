# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZDIR=$HOME/dotfiles/zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ ! -f ~/.secrets/keys ]] || source ~/.secrets/.keys

export BROWSER=/usr/bin/vivaldi-stable
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export QT4_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export CLUTTER_IM_MODULE=fcitx
export DefaultIMModule=fcitx
export LANG=ja_JP.UTF-8
export LANGUAGE=ja_JP:ja
export PULSE_SERVER=127.0.0.2
