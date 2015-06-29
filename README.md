#EDUBUDI BOT

Steps to run

- Clone the repo
- cd into the repo
- run `bundle install`
- Create your own Telegram bot with father bot, note the key. 
- Add ` export EDUBUDI_API="<telegram-bot-key>"`, `export MERIAM_API="<your-api-key>"` and `export EDUBUDI_PASSWORD="<set-yourown-password-here"` to your `~/.zshrc` or `~/.bashrc`. 
- Create your app on [https://apps.twitter.com/](https://apps.twitter.com/), and note downt eh consumer key and consumer secret. 
- run `twurl authorize --consumer-key key  --consumer-secret secret`
- run `ruby edubudi.rb`
