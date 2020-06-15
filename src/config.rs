use anyhow::{anyhow, Context as _, Result};
use serde::{de::Error as _, Deserialize, Deserializer};
use std::collections::HashMap;
use web3::types::Address;

/// Wrapper type of Address that implements deserialize from hex string.
#[derive(Debug)]
pub struct Address_(pub Address);

// Copied from ethcontract-rs.
fn hex_string_to_address(string: &str) -> Result<Address> {
    let prefix = "0x";
    if !string.starts_with(prefix) {
        return Err(anyhow!("does not start with {}", prefix));
    }
    Ok(string[2..].parse()?)
}

impl<'de> Deserialize<'de> for Address_ {
    fn deserialize<D>(deserializer: D) -> Result<Address_, D::Error>
    where
        D: Deserializer<'de>,
    {
        let string = String::deserialize(deserializer)?;
        let address = hex_string_to_address(&string)
            .with_context(|| format!("failed to parse address \"{}\"", string))
            .map_err(D::Error::custom)?;
        Ok(Address_(address))
    }
}

#[derive(Debug, Deserialize)]
pub struct ConfigAddress {
    pub address: Address_,
    pub ether: bool,
    pub tokens: Vec<String>,
    pub tag: Option<String>,
}

/// The user facing config file.
#[derive(Debug, Deserialize)]
pub struct Config {
    pub tokens: HashMap<String, Address_>,
    pub addresses: HashMap<String, ConfigAddress>,
}
