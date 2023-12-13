#!/usr/bin/env -S cargo -Z unstable-options -Z script 
//! ```cargo
//! cargo-features = ["edition2024"]
//! package.edition = "2024"
//! [dependencies]
//! indoc = "*"
//! ```
#![feature(
  array_chunks,
  associated_type_bounds,
  const_mut_refs,
  const_trait_impl,
  impl_trait_in_assoc_type,
  impl_trait_in_fn_trait_return,
  iter_next_chunk,
  log_syntax,
  slice_as_chunks,
  trace_macros,
  trait_alias,
  type_alias_impl_trait,
  variant_count,
)]

fn main() {
  let mut arg_or_default = {
    let mut args = std::env::args().skip(1);
    move |d: usize| match args.next() {
      Some(ref s) => s.parse().unwrap(),
      None => d,
    }
  };
  let cnt_t = arg_or_default(5);
  let cnt_c = arg_or_default(10);
  println!("{}", cmds(cnt_t, cnt_c));
}

fn cmds(cnt_t: usize, cnt_c: usize) -> String {
  let bots_t = "bot_add t; ".repeat(cnt_t);
  let bots_c = "bot_add ct; ".repeat(cnt_c);
  indoc::formatdoc!("
    bot_kick; 
    mp_warmup_end; 
    sv_cheats 1; 
    sv_pausable 1; 
    mp_limitteams 0; 
    mp_autoteambalance 0; 
    mp_maxmoney 60000; 
    mp_startmoney 60000; 
    mp_buytime 9999; 
    mp_buy_anywhere 1; 
    mp_freezetime 0; 
    mp_roundtime 3; 
    mp_roundtime_defuse 60; 
    sv_infinite_ammo 1; 
    ammo_grenade_limit_total 5; 
    sv_grenade_trajectory_prac_pipreview 1; 
    mp_restartgame 1; 
    {bots_t} 
    {bots_c}
  ")
}
