use std::env;
use teloxide::prelude::*;
use dotenv::dotenv;

#[tokio::main]
async fn main() {
    dotenv().ok();

    pretty_env_logger::init();
    log::info!("Starting throw dice bot...");

    let bot = Bot::new(
        env::var("TELOXIDE_TOKEN").expect("TELOXIDE_TOKEN must be set")
    );

    teloxide::repl(bot, |bot: Bot, msg: Message| async move {
        bot.send_message(msg.chat.id, "Hello!").await?;
        bot.send_dice(msg.chat.id).await?;
        Ok(())
    }).await;
}
