class ExperiencesOutcome < ApplicationRecord
  has_and_belongs_to_many :skills, join_table: :experiences_outcomes_skills
  has_and_belongs_to_many :sections, join_table: :experiences_outcomes_sections

  validates :code, presence: true, uniqueness: true
  validates :description, presence: true

  # Parse comma-separated codes and return array
  def self.parse_codes(text)
    return [] if text.blank?
    text.split(',').map(&:strip).reject(&:blank?)
  end
end
