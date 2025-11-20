class StudentSkill < ApplicationRecord
  belongs_to :student
  belongs_to :skill

  validates :student_id, uniqueness: { scope: :skill_id }

  scope :demonstrated, -> { where(demonstrated: true) }
  scope :not_demonstrated, -> { where(demonstrated: false) }

  def mark_demonstrated!(user)
    update!(
      demonstrated: true,
      demonstrated_at: Date.today
    )
  end

  def unmark_demonstrated!
    update!(
      demonstrated: false,
      demonstrated_at: nil
    )
  end
end




