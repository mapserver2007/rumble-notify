# rumble-notify

LINEにTwitterのトレンド情報を通知します。

## 使い方
1. https://notify-bot.line.me/my/ にアクセスしトークンを発行する
2. config/config.ymlの`LINE_NOTIFY_ACCESS_TOKEN`に設定する
3. `bundle exec clockwork bin/notify.rb`で実行する

## License
Licensed under the MIT
http://www.opensource.org/licenses/mit-license.php
