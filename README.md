# hubot-kerb

A Hubot script to check what's on [KERB](http://www.kerbfood.com/).

See [`src/kerb.coffee`](src/kerb.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install altmetric/hubot-kerb --save`

Then add **hubot-kerb** to your `external-scripts.json`:

```json
[
  "hubot-kerb"
]
```

## Configuration

hubot-kerb is configured by a single environment variable:

* `KERB_URL` - optional, the URL to scrape for KERB traders. Default:
  http://www.kerbfood.com/kings-cross/

## Usage

```console
Hubot> hubot what's on kerb?
Hubot> Luardos (http://www.kerbfood.com/traders/luardos/)
  The original burrito boy. Deep in the game, ain't coming out any time soon.
Stakehaus (http://www.kerbfood.com/traders/stakehaus/)
  Home to great steaks
Vinn Goute - Seychelles Kitchen (http://www.kerbfood.com/traders/vinn-goute/)
  Never had Seychelles cooking before? You're in for a treat.
Well Kneaded (http://www.kerbfood.com/traders/well-kneaded/)
  Pizza wagon on a mission
```

## Acknowledgements

Originally written by [George Sheppard](https://github.com/fuzzmonkey) and
[Richard Koks](https://github.com/richardkoks) for [Digital
Science](https://www.digital-science.com/).

## License

Copyright © 2015 Altmetric LLP

Distributed under the MIT License.
