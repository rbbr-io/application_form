# frozen_string_literal: true

require 'test_helper'

class ApplicationFormTest < Minitest::Test
  class User
    include ActiveModel::Model
    attr_accessor :a, :b

    def aaa?
      a == 'aaa'
    end

    def bbb?
      b == 'bbb'
    end

    def update(*args)
      assign_attributes(*args)
      true
    end
  end

  class UserForm < User
    include ApplicationForm

    check :aaa_and_bbb, ->(form) { form.aaa? && form.bbb? }
  end

  def setup
    @hash_params = { a: 'aaa', b: 'ccc' }
    @strong_params = ActionController::Parameters.new(@hash_params)
    @form = UserForm.new(@strong_params)
  end

  def test_check_fails
    skip
    assert { @form.checks_passed? }
  end
end
