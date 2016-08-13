# Packer for Vagrant Box with proxy environment

## Overview

proxy環境下でCentOS 6.8のVagrant用boxファイルを作成します。

chefのインストールまで行うようにしています。

kickstartのファイルを読めるようにするため、Packerを実行するホストにHTTPサーバを建て、公開ルートディレクトリに ks.cfg ファイルをコピーしてからPackerを実行する必要があります。
