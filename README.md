# Capistrano Confirm Branch
[![Gem Version](https://badge.fury.io/rb/capistrano_confirm_branch.png)](http://badge.fury.io/rb/capistrano_confirm_branch)


Requires confirmation before switching deployed branches using capistrano and
warns when deploying with unpushed changes.

![Confirm Deploy](http://i.imgur.com/7IdUY.png)

## Usage

Install the gem using rubygems:

```bash
$ gem install capistrano_confirm_branch
```

or add it to your Gemfile and run `bundle install`

```ruby
gem 'capistrano_confirm_branch'
```

Then in your `Capfile` add `require 'capistrano/confirm_branch'` and you will be
asked to confirm changing branches before each deploy.


### Configuration options

By default `capistrano_confirm_branch` will warn when changing branches AND when
there are unpushed git commits. You can opt out of either warning by setting the
following options:

```ruby
# config/deploy.rb

# Turn off unpushed git commit check
set :check_unpushed_commits_before_deploy, false

# Turn off branch change warning
set :confirm_branch_before_deploy, false
```

## Bonus

To deploy from the current working branch, use this in your capistrano recipe:

```ruby
set :branch, $1 if `git branch` =~ /\* (\S+)\s/m
```

## License

Copyright (c) 2012 Jordan Byron

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
