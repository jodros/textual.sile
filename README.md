# textual.sile

This module does almost the same job of a book class... But for me it makes more sense to write these commands in a package like this one. Mostly in order to use it together with my other module [`config.sile`](https://github.com/jodros/config.sile).

PRs are welcome! Take a look at the [TODO](/TODO) file.

The file [`settings.toml`](/example/settings.toml) is aimed to help the use of `textual.sile` along with `config.sile`.

## Install

Just run `luarocks install --server=https://luarocks.org/dev textual.sile`, or clone this repository and then run `luarocks --local make`.

---

You may need to declare the `twoside` package in your class as well in order to use thr `head`command with the option `openSpread`...

In order to use the `versalete` command, I recommend any of these fonts which are available at [`Google Fonts`](https://fonts.google.com/): 

- Aboreto
- Alegreya SC
- Cinzel
- Cormorant SC
- IM Fell Double Pica SC
- IM Fell English SC
- IM Fell Great Primer SC

