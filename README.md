# YamlValidations

Convert this:

    books:
      required:
        authors:
          schema: author

        author:
          required:
            id: str?
            name: str?
            org_id: int?
          optional:
            address: str?

To `dry-validation`

    BooksSchema = Dry::Validation.Schema do
      required(:authors).schema(AuthorSchema)
      optional(:address).maybe(:str?)
    end

    Books::AuthorSchema = Dry::Validation.Schema do
      required(:id).filled(:str?)
      required(:name).filled(:str?)
      required(:org_id).filled(:int?)
      optional(:address).maybe(:str?)
    end

Via:

    yaml_validations generate dry-validation books.yaml

Other validation formats will be configured later.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yaml_validations'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yaml_validations

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/yaml_validations. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YamlValidations project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/yaml_validations/blob/master/CODE_OF_CONDUCT.md).
