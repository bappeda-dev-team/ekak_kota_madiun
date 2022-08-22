module Skalable
  extend ActiveSupport::Concern

  included do
    has_many :skalas, as: :skalable
  end
end
