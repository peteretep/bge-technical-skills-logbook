class Section < ApplicationRecord
  has_many :skills, -> { order(:position) }, dependent: :destroy
  has_many :badges, dependent: :destroy

  has_and_belongs_to_many :experiences_outcomes, join_table: :experiences_outcomes_sections

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true

  CATEGORIES = [
    "Design and Construct",
    "Materials",
    "Graphics"
  ].freeze

  validates :category, inclusion: { in: CATEGORIES }

  before_save :sync_experiences_outcomes

  scope :ordered, -> { order(:position) }
  scope :by_category, ->(cat) { where(category: cat) }

  def bronze_skills
    skills.where(level: :bronze)
  end

  def silver_skills
    skills.where(level: :silver)
  end

  def gold_skills
    skills.where(level: :gold)
  end

  private

  def sync_experiences_outcomes
    return if experiences_and_outcomes.nil?

    codes = ExperiencesOutcome.parse_codes(experiences_and_outcomes)
    self.experiences_outcomes = codes.map do |code|
      ExperiencesOutcome.find_or_create_by(code: code) do |eo|
        eo.description ||= "Description for #{code}"
      end
    end
  end
end
