# Tango::Client

[![Build Status](https://travis-ci.org/doitian/tango-client.png)](https://travis-ci.org/doitian/tango-client)

HTTP client to ease using Tango API

## Installation

Add this line to your application's Gemfile:

    gem 'tango-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tango-client

## Usage

### Use Tango class methods

```ruby

require 'tango'

Tango.get_available_balance
# => 539694976

Tango.purchase_card(cardSku: 'tango-card',
                    cardValue: 100,
                    tcSend: false,
                    recipientName: nil,
                    recipientEmail: nil,
                    giftMessage: nil,
                    giftFrom: nil)
# => {
#   :referenceOrderId=>"112-12226603-04",
#   :cardToken=>"50bdb8ce341848.92673903",
#   :cardNumber=>"7001-5040-0198-7543-015",
#   :cardPin=>"971642",
#   :claimUrl=>nil,
#   :challengeKey=>"7001504001987543015"
# }

```

### Use Client instance

```ruby
require 'tango'

client = Tango::Client.new(:username => 'myaccount', :password => 'mypassword')

client.get_available_balance
client.purchase_card({})
```

### Configuration

-   `Tango` class methods are delegated to `Tango.client`, which options can
    be changed by updating `Tango.options`. The changes are applied since next
    request.
-   `Tango::Client` instances are configured by initialization argument.
-   Default username, password and endpoint can be configured by environment variable
    `TANGO_USERNAME`, `TANGO_PASSWORD` and `TANGO_ENDPOINT`.
-   Changes to `Tango::Default.options` will applied to following created new client
    instance as default values.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
