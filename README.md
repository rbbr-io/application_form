# ApplicationForm

![github action status](https://github.com/rbbr_io/application_form/workflows/main/badge.svg)

Painless forms for ActiveRecord. Based on Inheritance. Included:

* Strong parameters
* Validation (based on the model validation)
* Data normalization

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'application_form'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install application_form

## Usage

1. Create directory *app/forms*
1. Add Form class for a model
1. Add permitted params inside the class
1. Use it as a normal model (without strong_params)

## Generator

Use the supplied generator to generate forms:

    $ rails g application_form:form sign_up --model=user

or with namespace model

    $ rails g application_form:form admin_post --model=blog/post

### Basic usage

```ruby
# app/forms/user_sign_up_form.rb
class UserSignUpForm < User
  include ApplicationForm

  # list all the permitted params
  permit :first_name, :email, :password

  # add validation if necessary
  # they will be merged with base class' validation
  validates :password, presence: true

  # optional data normalization
  def email=(email)
    if email.present?
      write_attribute(:email, email.downcase)
    else
      super
    end
  end
end
```

```
form = UserSignUpForm.new(user_params)
form.valid?
```

### Usage with `becomes`

In some cases it is necessary to use ActiveRecord object directly without form. For such cases conveniently to use method `becomes()` (built-in ActiveRecord):

```ruby
user = User.find(params[:id])
form = user.becomes(UserSignUpForm)
```

### Checks

Checks are build on top of Rails validations. They are semantically separated from validations, because we treat them as business logic checks, not as data validation.

```ruby
class ReservationCreateForm < Reservation
  include ApplicationForm

  permit :user_id, :vehicle_id, :start_at, :end_at, :pickup_location_id, :return_location_id

  check :max_number_of_reservations_reached, ->(form) { !form.user&.reservations_limit_reached? }
  check :car_is_on_maintenance, ->(form) { form.vehicle&.reservable? }
end

# In controller:
form = ReservationCreateForm.new(prepared_params)

if form.checks_passed?
  # ...
else
  render_error!(form.first_failed_check) # form.first_failed_check returns "reservation.error.max_number_of_reservations_reached"
end
```

You can also assign check to a specific field:

```ruby
check :end_at_must_be_greater_then_start_at, ->(form) { form.end_at > form.start_at }, :end_at
```

In this case it will work as a regular validation.

### `assign_attrs`

It works as regular `assign_attributes` but it also returns the object, so that you can chain it:

```ruby
form = current_user.becomes(UserApplyReferralProgramForm)
                   .assign_attrs(registration_referral_code: referral_code)
```

It is a usual pattern when you use for in `#update` action.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rbbr_io/application_form. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/rbbr_io/application_form/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ApplicationForm project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rbbr_io/application_form/blob/master/CODE_OF_CONDUCT.md).
