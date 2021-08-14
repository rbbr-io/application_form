# frozen_string_literal: true

require 'application_form/version'
require 'active_support/concern'

module ApplicationForm
  class Error < StandardError; end

  extend ActiveSupport::Concern

  included do
    prepend Included
    # raise superclass.inspect
    # parent.extend ActiveModel::Naming
  end

  module Included
    def initialize(attrs = {})
      permitted_attrs = permit_attrs(attrs)
      super(permitted_attrs)
    end
  end

  module ClassMethods
    delegate :sti_name, to: :superclass
    delegate :human_attribute_name, to: :superclass
    # NOTE: Controvertial thing. More details: https://github.com/Hexlet/active_form_model/issues/10
    delegate :name, to: :superclass

    def permit(*args)
      @_permitted_args = args
    end

    def _permitted_args
      @_permitted_args || (superclass.respond_to?(:_permitted_args) && superclass._permitted_args) || []
    end

    def check(key, block, field = :base)
      validate do |form|
        if !block.call(form)
          entity_name = self.class.superclass.to_s.tableize.split('/').last.singularize
          full_key = "#{entity_name}.errors.#{key}"
          form.add_error_key(field, full_key)
        end
      end
    end
  end

  def update(attrs = {})
    permitted_attrs = permit_attrs(attrs)
    super(permitted_attrs)
  end

  def update!(attrs = {})
    permitted_attrs = permit_attrs(attrs)
    super(permitted_attrs)
  end

  def assign_attributes(attrs = {})
    permitted_attrs = permit_attrs(attrs)
    super(permitted_attrs)
  end

  def permit_attrs(attrs)
    attrs.respond_to?(:permit) ? attrs.send(:permit, self.class._permitted_args) : attrs
  end

  def first_error_message
    errors&.full_messages&.first
  end

  def checks_passed?
    valid?
  end

  def first_failed_check
    errors.details[:base].first[:error].to_s
  end

  def assign_attrs(attrs)
    assign_attributes(attrs)
    self
  end
end
