## 環境
OS: Ubuntu24.04

## 初期設定

1. 本リポジトリをローカルにクローン
```
git clone <ssh or https> ~/.config/nvim
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

5. 必要パッケージのインストール
```
sudo apt update
sudo apt install -y neovim build-essential xclip
```

6. 必要文字フォントの設定
```
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
unzip JetBrainsMono.zip
fc-cache -fv
```

7. ターミナルへのフォント適用
- ターミナル右上のハンバーガーマーク->設定->サイドメニューで適用されているプロファイル選択
- フォントで"JetBrainsMono Nert Font"を選択
- 一度全てのターミナルを閉じる
- 再度ターミナルを起動してフォントが直っていればOK

8. lazygitのインストール<br>
参考URL：https://github.com/jesseduffield/lazygit
```
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
```

