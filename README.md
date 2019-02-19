# Scoped Concerns

Scoped-Concerns is a tiny utility library to help you encapsulate responsibilities in your Ruby applications by providing a common interface and a common response object for the so called _service classes_ or how we like to call them: _concerns_.

We've been playing around with this concept in a few applications and it was evolving until this point that we feel it reusable enough to become a separated library.

## Install

It's a Ruby gem in rubygems.org, so is as simple as:

```
gem install scoped-concerns
```

## Usage

Include `Scoped::Concern` in your service (concern) class, and implement your constructor and the `run` methods with the logic for your domain. For example

```Ruby
module MyApp
  module Concerns
    class ActivateUser
      include Scoped::Concern

      def initialize(params = {})
        @user_id = params[:user_id]
      end

      def run
        user = User.find(@user_id)
        return error(user: [:not_valid]) unless user

        begin
          user.activate!
          success(user: "Activated")
        rescue => e
          logger.log(e.message)
          error(update: [:not_valid])
        end
      end
    end
  end
end
```

Then you can use this concern in your endpoints logic, like:

```Ruby
on "activate/:id" do |id|
  response = MyApp::Concerns::ActivateUser.run(user_id: id)

  if response.success?
    json(message: "User has been activated")
  else
    json_error(message: [response.errors[:update], response.errors[:user]].join("\n"))
  end
end
```

`Scoped-Concerns` provides the `run`, `error` and `success` helper methods through `Concern` module and the `Scoped::Response` class as a standard response format.

`Scoped-Concerns` proposes the following conventions:

* Parameters to a concern should always be a `Hash`, even if you need only one parameter (see example above)
* A `Concern` should always return a `Scoped::Response` object. (`success` and `error` helper methods return this)

### Response

The `Scoped::Response` class has the `result` and `errors` attributes, both of them must be hashes. The keys of these `Hash`es will depend on your application domain, but, at least, you know that you'll deal with `Hash`es.

The `Scoped::Response` class also has a `success?` instance utility method that is a wrapper to `@errors.empty?` for readability's sake.
