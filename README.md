# Ruby LSP FactoryBot GoTo

A Ruby LSP addon that provides **"Go to Definition"** support for [FactoryBot](https://github.com/thoughtbot/factory_bot) factories.

> **Note**: This is a separate addon from [`ruby-lsp-factory_bot`](https://rubygems.org/gems/ruby-lsp-factory_bot). That gem provides code completion, while this gem provides navigation (go-to-definition). They complement each other and can be used together!

## Features

- 🎯 **Go to Definition**: Jump from factory references to their definitions
- 🏷️ **Alias Support**: Works with factory aliases (e.g., `factory :user, aliases: [:admin]`)
- 📁 **Subdirectories**: Indexes factories in `spec/factories/**/*.rb` recursively
- ⚡ **Fast**: Uses Prism for efficient AST parsing

### Supported FactoryBot Methods

- `create(:factory_name)`
- `build(:factory_name)`
- `build_list(:factory_name)`
- `create_list(:factory_name)`
- `attributes_for(:factory_name)`

Works with both symbol and string arguments: `create(:user)` and `create("user")`

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'ruby-lsp-factory_bot-goto'
end
```

Then run:

```bash
bundle install
```

The addon will be automatically loaded by Ruby LSP.

## Usage

Once installed, the addon automatically activates when you use Ruby LSP. Simply:

1. Place your cursor on a factory name in a FactoryBot call (e.g., `:user` in `create(:user)`)
2. Use "Go to Definition" (typically `F12` or `Cmd+Click` in VS Code)
3. Jump directly to the factory definition!

## Example

Given a factory definition:

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "john@example.com" }
  end
end
```

You can now jump to it from any test:

```ruby
# spec/models/user_spec.rb
it "creates a user" do
  user = create(:user)  # <- Cmd+Click on :user jumps to the factory!
end
```

### Factory Aliases

The addon fully supports factory aliases:

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user, aliases: [:admin, :member] do
    name { "John Doe" }
  end
end
```

Now all three names work: `create(:user)`, `create(:admin)`, `create(:member)`

## How It Works

The addon:

1. Indexes all factories in `spec/factories/**/*.rb` when Ruby LSP starts
2. Parses factory definitions using Prism to extract names and aliases
3. Listens for FactoryBot method calls in your code
4. Provides location information for "Go to Definition" requests

## Requirements

- Ruby >= 3.0
- Ruby LSP >= 0.26
- Prism >= 0.19

## Development

To test the addon locally in your Rails project:

1. Add it to your project's Gemfile with a `path:` directive:
   ```ruby
   gem 'ruby-lsp-factory_bot-goto', path: '~/projects/ruby-lsp-factory_bot-goto'
   ```
2. Run `bundle install`
3. Restart your Ruby LSP server

## Building and Publishing

To build the gem:

```bash
gem build ruby-lsp-factory_bot-goto.gemspec
```

To publish to RubyGems:

```bash
gem push ruby-lsp-factory_bot-goto-0.1.0.gem
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tylercainerhodes/ruby-lsp-factory_bot-goto.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

Built with [Ruby LSP](https://shopify.github.io/ruby-lsp/) and [Prism](https://ruby.github.io/prism/).
