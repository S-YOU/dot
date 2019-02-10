# これは何？

- Makefileのテンプレート
- *.cからa.outをビルド
- *.o, a.outはbuildディレクトリに出力
- BUILD_DIR=.にすることも可能
- `-MMD`により.cファイルから.hファイルへの依存関係も自動的に生成する
- コマンドはフラグ、入力、出力の順になるよう統一してある（例：gcc -W -Wall -c hoge.c -o hoge.o）

オリジナル：https://stackoverflow.com/a/30142139/5209556
