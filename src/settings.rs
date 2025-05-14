use config::{Config, ConfigError, Environment};
use once_cell::sync::Lazy;
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct Settings {
    // === DATABASE ===
    pub postgres_db: String,
    pub postgres_user: String,
    pub postgres_password: String,
    pub postgres_host: String,
    pub postgres_port: u16,

    // === TELEGRAM ===
    pub bot_token: String,
}

impl Settings {
    fn new() -> Result<Self, ConfigError> {
        dotenv::dotenv().ok();

        let config = Config::builder()
            .add_source(Environment::default())
            .build()?;

        config.try_deserialize()
    }
}

pub static SETTINGS: Lazy<Settings> =
    Lazy::new(|| Settings::new().expect("Failed to load settings"));
