# micromicro.cc

**Extract [microformats2](https://microformats.org)-encoded data from a webpage.**

[![Build](https://img.shields.io/github/actions/workflow/status/jgarber623/micromicro.cc/ci.yml?branch=main&logo=github&style=for-the-badge)](https://github.com/jgarber623/micromicro.cc/actions/workflows/ci.yml)
[![Deployment](https://img.shields.io/github/deployments/jgarber623/micromicro.cc/production?label=Deployment&logo=github&style=for-the-badge)](https://github.com/jgarber623/micromicro.cc/deployments/activity_log?environment=production)

## Usage

There are a couple of ways you can use micromicro.cc:

You may point your browser at [the website](https://micromicro.cc), enter a URL into the search form, and submit! You could also hack on the URL itself and throw something like this at your browser's URL bar:

```text
https://micromicro.cc/search?url=https://sixtwothree.org
```

Lastly, if you're comfortable working on the command line, you can query the service directly using a tool like [curl](https://curl.haxx.se):

```sh
curl --header 'Accept: application/json' --silent 'https://micromicro.cc/search?url=https://sixtwothree.org'
```

…or [Wget](https://www.gnu.org/software/wget/):

```sh
wget --header 'Accept: application/json' --quiet -O - 'https://micromicro.cc/search?url=https://sixtwothree.org'
```

The above command will return a [JSON](https://json.org) object with the results of the search.

## Improving micromicro.cc

You want to help make micromicro.cc better? Hell yeah! I like your enthusiasm. For more on how you can help, check out [CONTRIBUTING.md](https://github.com/jgarber623/micromicro.cc/blob/master/CONTRIBUTING.md).

### Donations

If diving into Ruby isn't your thing, but you'd still like to support micromicro.cc, consider making a donation! Any amount—large or small—is greatly appreciated. As a token of my gratitude, I'll add your name to the [Acknowledgments](#acknowledgments) below.

[![Donate via Square Cash](https://img.shields.io/badge/square%20cash-$jgarber-28c101.svg?style=for-the-badge)](https://cash.me/$jgarber)
[![Donate via Paypal](https://img.shields.io/badge/paypal-jgarber-009cde.svg?style=for-the-badge)](https://www.paypal.me/jgarber)

## Acknowledgments

micromicro.cc wouldn't exist without the hard work put in by everyone involved in the [IndieWeb](https://indieweb.org) and [microformats](https://microformats.org) communities.

Text is set using [Alfa Slab One](https://fonts.google.com/specimen/Alfa+Slab+One) and [Gentium Book Basic](https://fonts.google.com/specimen/Gentium+Book+Basic) which are provided by [Google Fonts](https://fonts.google.com). Iconography is from [Font Awesome](https://fontawesome.com)'s icon set.

micromicro.cc is written and maintained by [Jason Garber](https://sixtwothree.org).

## License

micromicro.cc is freely available under the [MIT License](https://opensource.org/licenses/MIT).
