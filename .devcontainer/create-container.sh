#!/bin/sh
KEY_PATH=/home/vscode/.ssh
KEY_FILE=id_rsa
KEY_FILEPATH=$KEY_PATH/$KEY_FILE
mkdir -p $KEY_PATH
cat /key/.ssh/${KEY_FILE} > $KEY_FILEPATH
chmod 0600 $KEY_FILEPATH

GITCONFIG_PATH=/home/vscode
GITCONFIG_FILE=.gitconfig
GITCONFIG_FILEPATH=$GITCONFIG_PATH/$GITCONFIG_FILE
cat /key/$GITCONFIG_FILE > $GITCONFIG_FILEPATH
chmod 0644 $GITCONFIG_FILEPATH

# TFLintのインストール
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Pluralithのインストール
# [Run Pluralith Locally](https://docs.pluralith.com/docs/get-started/run-locally/)の指示通りインストールすると、
# pluralith loginコマンドで
# initializing application directories failed -> initApp: InitPaths: mkdir /usr/local/bin/Pluralith: permission denied
# というエラーが出る。
# sudoコマンドをつけてログインをすると、ログインはできるようになるが、pluralith graphを実行すると、
# initializing application directories failed -> initApp: InitPaths: mkdir /usr/local/bin/Pluralith/bin: permission denied
# setting API key failed -> initApp: SetAPIKey: open /usr/local/bin/Pluralith/credentials: permission denied
# というエラーが出る。
# sudoコマンドをつけてログインをすると、terraformコマンドが含まれるフォルダはrootユーザーのPATHには含まれていないため、terraformのフォルダがPATHに追加されていないというエラーが出る。
# あらかじめ/usr/local/bin/Pluralith/binフォルダを作成して、/usr/local/bin/Pluralith以下の所有者をvscodeにする。
# pluralith graphを実行すると、
# /workspaces/tts/terraform/.pluralith/pluralith.plan.bin: permission denied.
# というエラーが出る。
# このフォルダはバージョン管理対象外なので、開発用コンテナを作成するたびにこのフォルダーをvscodeユーザーで作成しておく必要がある。
# そのあとgraphコマンドを実行すると、
# generating diagram failed -> GenerateGraph: running CLI command failed -> GenerateDiagram: fork/exec /usr/local/bin/Pluralith/bin/pluralith-cli-graphing: no such file or directory
# というエラーが出る。
# pluralith versionを実行すると、
# Graph Module Version: Not Installedと表示されてGraph Moduleがインストールされていないことがわかる。
# このモジュールは初回のgraphコマンドを実行する際にインストールされるようだ。このインストールにも失敗している模様。
# pluralith install graph-moduleコマンドで個別にインストールしようとしてもParsing request result failedと表示されてインストールできない。
# [グラフコマンドを手動でインストール](https://github.com/Pluralith/pluralith-cli/issues/131#issuecomment-1851979006)をする。
# するとversionコマンドでGraph Module Version: 0.2.1と表示されるようになった。
# exec: "xdg-open": executable file not found in $PATH
# このコマンドがないことで自動で画面が開かないですが、表示されたリンクをブラウザに貼り付ければ画面が開きます。
# pluralithのコマンドにちょくちょくparsing response failed -> GetGitHubRelease: %!w(<nil>)というのが出るのが気になる。
# https://github.com/Pluralith/pluralith-cli/issues/131 ではM1 Macで出てるということだが、こちらはWindowsで動いているUbuntuのdockerのdebianなのでIntel。
curl -L https://github.com/Pluralith/pluralith-cli/releases/download/v0.2.2/pluralith_cli_linux_amd64_v0.2.2 -o pluralith
sudo mkdir -p /usr/local/bin/Pluralith/bin
sudo chown vscode:vscode -R /usr/local/bin/Pluralith
sudo mv pluralith /usr/local/bin
chmod +x /usr/local/bin/pluralith
curl -L https://github.com/Pluralith/pluralith-cli-graphing-release/releases/download/v0.2.1/pluralith_cli_graphing_linux_amd64_0.2.1 -o pluralith-cli-graphing
mv pluralith-cli-graphing /usr/local/bin/Pluralith/bin
chmod +x /usr/local/bin/Pluralith/bin/pluralith-cli-graphing

# Downloads the infracost CLI based on your OS/arch and puts it in /usr/local/bin
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# テスト用データベースのSQLite3をインストールする
sudo apt update
sudo apt upgrade -y
sudo apt install -y sqlite3

# PlantUMLのプレビューを表示するために必要なモジュール
# PlantUMLのプレビューで日本語を使用すると文字が重なる不具合を解消するため、日本語フォントをインストールする。
sudo apt install -y graphviz fonts-ipafont
fc-cache -fv

# Protocol Buffer Compilerをインストールする
sudo apt install -y protobuf-compiler
# gRPCクライアントツールのevansをインストールする
curl -OL https://github.com/ktr0731/evans/releases/download/v0.10.11/evans_linux_arm64.tar.gz
tar zxvf evans_linux_arm64.tar.gz
sudo mv evans /usr/local/bin
rm evans_linux_arm64.tar.gz
