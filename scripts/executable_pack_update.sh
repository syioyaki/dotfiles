#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# Common
###############################################################################

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

log() {
    printf "\n==> %s\n" "$*"
}

get_latest_github_release() {
    curl -fsSL "https://api.github.com/repos/$1/releases/latest" |
        sed -n 's/.*"tag_name":[[:space:]]*"v\{0,1\}\([^"]*\)".*/\1/p' |
        head -n1
}

check_update() {
    CURRENT="$1"
    LATEST="$2"

    [ "$CURRENT" != "$LATEST" ]
}

###############################################################################
# apt
###############################################################################
log "Updating apt..."
# 最新のアップデートを確認

sudo apt-get update
# 最新のアップデートを適用
sudo apt-get -y upgrade
# ディストリビューションを最新のものに更新
sudo apt-get -y dist-upgrade
# 使われなくなったパッケージを削除
sudo apt-get -y autoremove
# aptキャッシュを削除
sudo apt-get -y autoclean

###############################################################################
# Desktop launchers
###############################################################################

log "Checking VS Code launcher..."


CODE_DESKTOP="/usr/share/applications/code.desktop"

# VS Codeへのno-sandboxオプション追記（必要なら）
if grep -q 'Exec=/usr/share/code/code %F' "$CODE_DESKTOP"; then
    sudo sed -i \
        's#Exec=/usr/share/code/code %F#Exec=/usr/share/code/code --unity-launch --no-sandbox %F#' \
        "$CODE_DESKTOP"
fi

log "Checking Vivaldi launcher..."

VIVALDI_DESKTOP="/usr/share/applications/vivaldi-stable.desktop"

# Vivaldiへのno-sandboxとdisable-gpuオプションの再追記（必要なら）
if grep -q '^Exec=/usr/bin/vivaldi-stable' "$VIVALDI_DESKTOP"; then
    sudo sed -i '/^Exec=\/usr\/bin\/vivaldi-stable/{
        /--no-sandbox/! s#^Exec=/usr/bin/vivaldi-stable#Exec=/usr/bin/vivaldi-stable --no-sandbox --disable-gpu#
    }' "$VIVALDI_DESKTOP"
fi

###############################################################################
# pyenv
###############################################################################

if [ -n "${PYENV_ROOT:-}" ] && [ -d "$PYENV_ROOT" ]; then
    log "Updating pyenv..."
    git -C "$PYENV_ROOT" pull
fi

###############################################################################
# LazyGit
###############################################################################

log "Checking LazyGit..."
CURRENT="$(lazygit --version | \
    sed -n 's/.*,\s*version=\([0-9.]*\),.*/\1/p')"
LATEST="$(get_latest_github_release jesseduffield/lazygit)"

echo "Current : $CURRENT"
echo "Latest  : $LATEST"

if check_update "$CURRENT" "$LATEST"; then
    log "Updating LazyGit..."

    curl -fLo "$TMPDIR/lazygit.tar.gz" \
        "https://github.com/jesseduffield/lazygit/releases/download/v${LATEST}/lazygit_${LATEST}_linux_arm64.tar.gz"

    tar -xf "$TMPDIR/lazygit.tar.gz" -C "$TMPDIR"

    sudo install "$TMPDIR/lazygit" /usr/local/bin

    echo "Updated LazyGit -> $LATEST"
else
    echo "LazyGit is already up to date."
fi

###############################################################################
# Neovim
###############################################################################

log "Checking Neovim..."

CURRENT="$(nvim --version 2>/dev/null | sed -n '1s/^NVIM v//p')"
LATEST="$(get_latest_github_release neovim/neovim)"

echo "Current : $CURRENT"
echo "Latest  : $LATEST"

if check_update "$CURRENT" "$LATEST"; then

    curl -fLo "$TMPDIR/nvim.tar.gz" \
        https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz

    sudo rm -rf /opt/nvim-linux-arm64
    sudo tar -C /opt -xzf "$TMPDIR/nvim.tar.gz"

    echo "Updated Neovim -> $LATEST"

else
    echo "Neovim is already up to date."
fi

###############################################################################
# Deno
###############################################################################

log "Checking Deno..."

CURRENT="$(deno --version 2>/dev/null | sed -n '1s/^deno //p')"
LATEST="$(get_latest_github_release denoland/deno)"

echo "Current : $CURRENT"
echo "Latest  : $LATEST"

if check_update "$CURRENT" "$LATEST"; then

    curl -fsSL https://deno.land/install.sh | sh

    echo "Updated Deno -> $LATEST"

else
    echo "Deno is already up to date."
fi

###############################################################################

log "All updates completed."
