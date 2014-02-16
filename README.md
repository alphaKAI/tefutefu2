#てふてふ2
##これはなに？
Ruby製のTwitter bot  
てふてふの新規書き直し版 前回実装した機能は全て実装済み  
  
  
##特徴
Rubyで記述されてるぼっと、機能の説明は
機能についてはこちらをどうぞ  
[てふてふいろいろ更新してます(てふてふの仕様とか](http://blog.alpha-kai-net.info/?p=370)  
後述する簡単なフォーマットでプラグインを開発することができます  
  
  
##プラグインの記述
てふてふの動作用の簡易スクリプトの構文  
拡張子は.tfで/てふてふのルートディレクトリ/userfuncs/に保存することで自動的に読み込まれます  
動作中も新しく追加された場合は読み込みます  
ファイルを削除する、または何らかの方法で機能を削除することもできるようにします  
--sample.tf  
   `title`:簡易スクリプトのタイトル Ex:sample(ファイル名と同じにする必要はありませんが、UserMethodを使用する場合は同じにして下さい)  
   `runlevel`:実行レベルです  解析対象のツイートとマッチする正規表現をもつ簡易スクリプトが存在した場合にrunlevelの低い方を優先します  
            デフォルトでは3です, 1 <= RUNLEVEL <=5です  
   `function`:挙動を書いて下さい 後述するユーザー定義のメソッドを実行することも可能です  
            (Reply|Favorite|ReTweet|Fellow|Remove|DirectMessage|UserMethod:メソッド名)|And Other)  
   `target`:反応する対象の判別方法(正規表現)  
   `string`:Tweet,Reply,DirectMessage等、文章を投稿する際に記述します  
          UserMethodを使用する場合は省略して下さい  
         Ex:(Replyを帰す場合){USERNAME}さん！ こんにちは！  
         {規定の定数名}で文字列にてふてふの内部処理時の変数を埋め込むことができます  
   `separate_thread?`:独立したスレッドで動作させるかどうか(true/false)  
   `method`:UserMethodを使用する場合にのみ記述して下さい Rubyで記述して下さい  
   記法は  
```
    method:st
      #コード
      def abc
        puts :abc
      end
    fn
```
   としてください  
   TefuEngineのインスタンスメソッドとしてevalでメソッドを定義します  
   破棄の際は`TefuEngine#disable(メソッド名)`でできます  
   再度有効化する場合は`TefuEngine#enable(メソッド名)vです  
##LICENSE
Copyright (C) alphaKAI 2014 http://alpha-kai-net.info  
GPLv3 LICENSE  
  
  
##開発環境
Windows 8.1 x64 Pro with MediaCenter  
Ruby 1.9.3  
  
  
##必要なTwitter Gem
* nokogiri
* oauth
  
  
##Change Log
####0.01 alpha fix 01
* バグ修正
* デーモン化させるようにした(?)
  
<<<<<<< HEAD
=======
####0.01 alpha fix 02
* バグ修正
* 定義ファイルに新オプション[ignore]を追加
  
####0.01 beta
* バグ修正:リプライじのユーザー名が変わらないバグを解決
* resource/setting.xmlにdebugを追加
  
<<<<<<< HEAD
>>>>>>> 6e79b57... 0.01 beta バグ修正:リプライじのユーザー名が変わらないバグを解決
=======
####0.01 beta
* バグ修正:リプライ時に2重にリプライが飛ばされるバグを解消
* resource/setting.xmlにdebugを追加
>>>>>>> 3ca07b7... 0.01 beta fix 01

##つかいかた
`git clone https://github.com/alphaKAI/tefutefu2.git`  
してからgemいれてresource/setting.xmlにconsumerkeyなどを記述して  
`ruby main.rb`です  
  
  
##作者 WEB SITE
Blog <http://blog.alpha-kai-net.info>  
HP <http://alpha-kai-net.info>  
Twitter <http://twitter.com/alpha_kai_NET>  
Github <https://github.com/alphaKAI>  
Mail to <alpha.kai.net@alpha-kai-net.info>  
