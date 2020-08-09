# frozen_string_literal: true

require 'symbol_serializer'

class Group < ApplicationRecord
  include Moderate::GroupConfig
  include Sluggable

  GROUP_TYPES = %i[facebook_group facebook_page other].freeze

  alias_attribute :type, :gtype

  has_one :info, dependent: :destroy
  has_one :location, dependent: :destroy
  has_one :submitter, dependent: :destroy

  serialize :gtype, Slg::SymbolSerializer

  validates :info, presence: true
  validates :location, presence: true
  validates_associated :info
  validates_associated :location
  validates_associated :submitter

  validates :name, presence: true
  validates :slug, presence: false, on: :create
  validates :type,
            presence: true,
            inclusion: { in: GROUP_TYPES, if: proc { |g| g.type? } }

  before_create :assign_slug
  before_update :assign_slug, if: proc { |m| m.name_changed? }

  accepts_nested_attributes_for :info
  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :submitter

  def to_param
    slug
  end

  private

  def assign_slug
    self.slug = generate_slug(name)
  end
end
