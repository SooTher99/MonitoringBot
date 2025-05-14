mod settings;

use teloxide::prelude::*;

use crate::settings::SETTINGS;

#[tokio::main]
async fn main() {
    println!("{}", SETTINGS.bot_token);
    pretty_env_logger::init();
    log::info!("Starting throw dice bot...");

    let bot = Bot::new(&SETTINGS.bot_token);

    teloxide::repl(bot, |bot: Bot, msg: Message| async move {
        bot.send_message(msg.chat.id, "Hello!").await?;
        bot.send_dice(msg.chat.id).await?;
        Ok(())
    })
    .await;
}
