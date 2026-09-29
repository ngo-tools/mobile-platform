#![recursion_limit = "256"]

pub mod api;
mod frb_generated;
pub mod nse;

#[cfg(target_os = "android")]
mod android;
