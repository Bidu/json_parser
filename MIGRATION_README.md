Migration from `json_parser` to [arstotzka](https://github.com/darthjee/arstotzka)

The most stable version of `arstotzka` is [1.2.2](https://github.com/darthjee/arstotzka/tree/1.2.2)
and it can cohexist with json_parser so it can be added and migrate before `json_parser` removal


Instalation
---------------
1. Add Arstotzka to your `Gemfile` and `bundle install`:
  - Install it

```ruby
  gem install arstotzka -v '1.2.2'
```

- Or add Arstotka to you `Gemfile` and `bundle install`

```ruby
gem 'arstotzka', '1.2.2'
```

```bash
  bundle install arstotzka
```

Usage
------
update your models to include `Arstotzka` instead of `JsonParser`

```ruby
class MyModel
  # include JsonParser
  include Arstotzka
```

and use the new class method `expose`

```ruby
class MyModel
  # include JsonParser
  include Arstotzka

  # json_parse :id, :dog_name, cached: true
  expose :id, :dog_name, cached: true
```

also, port all your customization from `JsonParser::TypeCast` to `Arstotzka::TypeCast`

```ruby
module JsonParser::TypeCast
  def to_my_type(value)
    # code here
  end
end

module Arstotzka::TypeCast
  def to_my_type(value)
    # same code here
  end
end
```

Clen up
--------
finally, remove `json_parser` ... for good :D

keep up trying to update `arstotzka` on your project