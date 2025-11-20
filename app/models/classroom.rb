class Classroom < ApplicationRecord
  belongs_to :user
  has_many :students, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }

  def full_name
    "#{year_group} #{name}".strip
  end
end




