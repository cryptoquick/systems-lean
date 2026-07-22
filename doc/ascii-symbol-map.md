# ASCII symbol map

Unicode -> ASCII glossary used by hygiene `--fix` and by authors outside the Unicode allowlist.

**Unicode allowed in novel work only here, in `README.md`, and in `doc/vocabulary.md`.** Everywhere else we author: tab/LF/CR + printable ASCII only.

Rows between MAP_BEGIN/MAP_END: `CODEPOINT <TAB> UNICODE <TAB> ASCII <TAB> NAME`.
Enforce: `just hygiene / nix flake check`, `nix flake check` (`source-hygiene`).

## Map data

MAP_BEGIN
```
0020	 	space (reference only)
00A0	 	 	no-break space
00AD	­		soft hyphen (delete)
00AB	«	<<	left double angle quote
00BB	»	>>	right double angle quote
00B7	·	*	middle dot
00D7	×	x	multiplication sign
00F7	÷	/	division sign
00A7	§	section	section sign (write "section" or "sec.")
00A9	©	(c)	copyright sign
00AE	®	(R)	registered sign
00B5	µ	u	micro sign
03A9	Ω	Omega	Greek capital omega
03B1	α	alpha	Greek small alpha
03B2	β	beta	Greek small beta
03B3	γ	gamma	Greek small gamma
03BB	λ	lambda	Greek small lambda
03C0	π	pi	Greek small pi
03C9	ω	omega	Greek small omega (QTT unrestricted: write omega)
2010	‐	-	hyphen
2011	‑	-	non-breaking hyphen
2012	‒	-	figure dash
2013	–	-	en dash
2014	—	--	em dash
2015	―	--	horizontal bar
2018	‘	'	left single quotation mark
2019	’	'	right single quotation mark / apostrophe
201A	‚	'	single low-9 quotation mark
201B	‛	'	single high-reversed-9 quotation mark
201C	“	"	left double quotation mark
201D	”	"	right double quotation mark
201E	„	"	double low-9 quotation mark
201F	‟	"	double high-reversed-9 quotation mark
2020	†	+	dagger
2021	‡	++	double dagger
2022	•	*	bullet
2026	…	...	horizontal ellipsis
2032	′	'	prime
2033	″	"	double prime
2039	‹	<	single left angle quotation
203A	›	>	single right angle quotation
2044	⁄	/	fraction slash
2122	™	(TM)	trade mark sign
2190	←	<-	leftwards arrow
2191	↑	^	upwards arrow
2192	→	->	rightwards arrow
2193	↓	v	downwards arrow
2194	↔	<->	left right arrow
21D2	⇒	=>	rightwards double arrow
2200	∀	forall	for all
2203	∃	exists	there exists
2208	∈	in	element of
2212	−	-	minus sign
2260	≠	!=	not equal to
2264	≤	<=	less-than or equal to
2265	≥	>=	greater-than or equal to
22A2	⊢	|-	right tack / proves
22A8	⊨	|=	double turnstile / models
```
MAP_END

Prefer: `Curry-Howard`, `0/1/omega`, `--`, `...`, `"..."`, `->`/`<->`, `!=`. `ref/**` not under this rewrite. Fail closed elsewhere.

SPDX-License-Identifier: Unlicense
