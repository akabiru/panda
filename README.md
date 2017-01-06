![](https://www.dropbox.com/s/yfhnvtjd7iei1e4/panda.png?raw=1)

[![Code Climate](https://codeclimate.com/github/andela-akabiru/panda/badges/gpa.svg)](https://codeclimate.com/github/andela-akabiru/panda) [![Coverage Status](https://coveralls.io/repos/github/andela-akabiru/panda/badge.svg?branch=master)](https://coveralls.io/github/andela-akabiru/panda?branch=master) [![Issue Count](https://codeclimate.com/github/andela-akabiru/panda/badges/issue_count.svg)](https://codeclimate.com/github/andela-akabiru/panda) [![Build Status](https://travis-ci.org/akabiru/panda.svg?branch=master)](https://travis-ci.org/akabiru/panda)
[![Dependency Status](https://gemnasium.com/badges/github.com/andela-akabiru/panda.svg)](https://gemnasium.com/github.com/andela-akabiru/panda) [![Gem Version](https://badge.fury.io/rb/panda_frwk.svg)](https://badge.fury.io/rb/panda_frwk)

# Panda

Panda is an mvc framework built with Ruby for building web applications.

## Getting started

Clone Panda

    $ git clone https://github.com/andela-akabiru/panda

Add this line to your application's Gemfile:

```ruby
gem 'panda_frwk'
```

And then execute:

    $ bundle

## Usage

Panda uses the mvc pattern. Thus your application structure should be as follows:

    .
    ├── app
    │   ├── controllers
    │   │   └── todo_controller.rb
    │   ├── models
    │   │   └── todo.rb
    │   └── views
    │       ├── layouts
    │       │   └── application.html.erb
    │       └── todo
    │           ├── edit.html.erb
    │           ├── index.html.erb
    │           ├── new.html.erb
    │           └── show.html.erb
    ├── config
    │   ├── application.rb
    │   └── routes.rb
    ├── config.ru
    ├── db
    │   └── app.db
    ├── Gemfile
    ├── Gemfile.lock
    └── README.md



### Routes

Your routes should be defined in `config/routes.rb` file. Here's an example.

```ruby
TodoApplication.routes.draw do
  root "todo#index"
  get "/todo", to: "todo#index"
  get "/todo/new", to: "todo#new"
  get "/todo/:id", to: "todo#show"
  get "/todo/:id/edit", to: "todo#edit"
  post "/todo", to: "todo#create"
  put "/todo/:id", to: "todo#update"
  delete "/todo/:id", to: "todo#destroy"
end
```

### Models

Models are defined in `app/models` folder. Here's an example model

```ruby
class Todo < Panda::Record::Base
  to_table :todos
  property :id, type: :integer, primary_key: true
  property :title, type: :text, nullable: false
  property :body, type: :text, nullable: false
  property :status, type: :text, nullable: false
  property :created_at, type: :text, nullable: false
  create_table
end
```

### Controllers

Controllers are defined in `app/controllers`. Here's an example controller.

```ruby
class TodoController < Panda::BaseController
  def index
    @todos = Todo.all
  end

  def show
    @todo = Todo.find(params["id"])
  end

  def new
  end

  def edit
    @todo = Todo.find(params["id"])
  end

  def update
    todo = Todo.find(params["id"])
    todo.update(
      title: params["title"],
      body: params["body"],
      status: params["status"]
    )
    redirect_to "/todo/#{todo.id}"
  end

  def create
    Todo.create(
      title: params["title"],
      body: params["body"],
      status: params["status"],
      created_at: Time.now.to_s
    )
    redirect_to "/todo"
  end

  def destroy
    todo = Todo.find(params["id"])
    todo.destroy
    redirect_to "/todo"
  end
end
```

### Views

Views are mapped to the controller actions. E.g if You have a `TodoController`, views for that controller should be defined in `app/views/todos/action_name.erb`. Panda depends on [Tilt](https://github.com/rtomayko/tilt) gem and thus supports embedded ruby in the views. Instance variables defined in the controller actions can be accessed in the corresponding view.

Here's an example usage:

Controller `app/controllers/todo_controller.rb`

```ruby
[...]
def index
  @todos = Todo.all
end
[...]
```

View `app/views/index.html.erb`

```html
<h1>My Todos</h1>

<% @todos.each do |todo| %>
  <p><strong><%= todo.title %></strong> <em><%= todo.status %></em>
    <a href="/todo/<%= todo.id %>" id="todo_<%= todo.id %>">Show</a> | <a href="/todo/<%= todo.id %>/edit">Edit</a>
  </p>
<% end %>

<p><a href="/todo/new">New Todo</a></p>
```


Note that there's an layout file `app/views/layouts/application.html.erb`. Here you can define your general view layout. Other views will be rendered inside the file.

Here's a sample layout file:

```html
<!DOCTYPE html>
<html>
<head>
  <title><%= title %></title>
</head>
<body>
  <%= yield %>
</body>
</html>
```

### Configuration

I bet you've noticed that there's a `config.ru` file. This file that gets called when we run our panda application. However, there're some few things to take note of:

Set the `APP_ROOT` to the current directory since panda uses that constant to find templates.

```ruby
APP_ROOT = __dir__
```

Require `config/appliaction`

```ruby
require_relative './config/application.rb'
```

Add method override middleware. This masks put and delete request as post requests.

```ruby
use Rack::MethodOverride
```

After this what's left is initialising the panda application, locading the routes and running it.

To run the application run

    $ bundle exec rackup

at the root of your application.


### Tests

Panda is well tested with a sample application for integration tests and unit specs for the base model. To run the specs run

    $ bundle exec rake

Or

    $ bundle exec rspec -fd

## Application Limitations

  * Panda does not have a generator for file structures.
  * Panda does not support model relationships at the moment

## Dependencies
  1. [Ruby](https://github.com/rbenv/rbenv)
  2. [SQlite3](https://github.com/sparklemotion/sqlite3-ruby)
  3. [Bundler](https://github.com/bundler/bundler)
  4. [Rack](https://github.com/rack/rack)
  5. [Rack Test](https://github.com/brynary/rack-test)
  6. [Rspec](https://github.com/rspec/rspec)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/akabiru/panda. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
