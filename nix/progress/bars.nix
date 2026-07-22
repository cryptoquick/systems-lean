# SPDX-License-Identifier: Unlicense
# ASCII progress bars for meters (pure Nix).
{ lib }:
let
  clamp =
    pct:
    if pct < 0 then
      0.0
    else if pct > 100 then
      100.0
    else
      pct;

  pctOneDecimal =
    p:
    let
      whole = builtins.floor p;
      frac = builtins.floor ((p - whole) * 10 + 0.5);
      frac' = if frac > 9 then 9 else frac;
    in
    "${toString whole}.${toString frac'}%";

  fill =
    width: pct:
    let
      p = clamp pct;
      n = builtins.floor ((p / 100.0) * width + 0.5);
      n' = if n < 0 then 0 else if n > width then width else n;
      hashes = lib.concatStrings (lib.genList (_: "#") n');
      dashes = lib.concatStrings (lib.genList (_: "-") (width - n'));
    in
    {
      inherit hashes dashes;
      pctStr = pctOneDecimal p;
    };
in
{
  # Width-20 meter with right-padded percent.
  bar =
    pct:
    let
      f = fill 20 pct;
      pad =
        s:
        let
          len = builtins.stringLength s;
        in
        if len >= 6 then s else (lib.concatStrings (lib.genList (_: " ") (6 - len))) + s;
    in
    "[${f.hashes}${f.dashes}] ${pad f.pctStr}";

  # Width-10 meter for table rows.
  bar10 =
    pct:
    let
      f = fill 10 pct;
    in
    "[${f.hashes}${f.dashes}] ${f.pctStr}";
}
