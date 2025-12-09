## 環境
OS: Ubuntu24.04

## 初期設定

1. 本リポジトリをローカルにクローン
```
git clone <ssh or https> ~/.config/
```

2. NeoVim本体のインストール<br>
参考URL：https://neovim.io/doc/install/
```
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

3. 以下の内容を~/.bashrcに追記
```
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
```

4. ~/.bashrcの再読込
```
source ~/.bashrc 
```

5. lazy.nvimのインストール (nvimプラグイン管理ツール)
```
git clone https://github.com/folke/lazy.nvim.git \
  ~/.local/share/nvim/lazy/lazy.nvim
```

6. 必要パッケージのインストール
```
sudo apt update
sudo apt install -y build-essential xclip ripgrep
```

LSPがNode.jsで作られているためnpm, node.jsも入れる
```
sudo apt update
sudo apt install -y ca-certificates curl gnupg
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

7. 必要文字フォントの設定
```
sudo mkdir -p /usr/share/fonts/JetBrainsMono
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
unzip JetBrainsMono.zip -d /usr/share/fonts/JetBrainsMono
fc-cache -fv
rm JetBrainsMono.zip
```

8. ターミナルへのフォント適用
- ターミナル右上のハンバーガーマーク->設定->サイドメニューで適用されているプロファイル選択
- フォントで"JetBrainsMono Nert Font"を選択
- 一度全てのターミナルを閉じる
- 再度ターミナルを起動してフォントが直っていればOK

9. lazygitのインストール<br>
参考URL：https://github.com/jesseduffield/lazygit
```
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
```

## tmuxセットアップ
tmux: ターミナル管理ツール<br><br>

1. tmuxインストール
```
sudo apt install tmux
```
2. カラー定義確認
以下実行してterminfoの内容が並べばOK
```
infocmp tmux-256color
```
3. ~/.tmux.conf定義
※一緒に便利なキーバインドも定義
以下内容を"\~/.tmux.conf"に記載
```
set -g mouse on
setw -g mode-keys vi

set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:RGB"

bind -n C-h select-pane -L
bind -n C-j select-pane -D
bind -n C-k select-pane -U
bind -n C-l select-pane -R

bind -n M-h split-window -h
bind -n M-v split-window -v
```
4. tmux再起動 ※起動しているtmuxセッションなければSkip
```
tmux kill-server
```
※カラースキームの適用のためには完全再起動必要なためkill-server

## Docker連携
- 基本的にはホストでファイル編集して、コンテナ上で実行
- formatterが機能しないのはpyright
- pythonについてはローカルでもuv syncにより仮想環境を構築して、コンテナと同一のpython環境を作りローカルで作業
