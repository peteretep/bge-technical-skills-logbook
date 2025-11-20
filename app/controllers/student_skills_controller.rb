class StudentSkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student_and_skill
  before_action :authorize_student_access

  def toggle
    @student_skill = StudentSkill.find_or_initialize_by(
      student: @student,
      skill: @skill
    )

    if @student_skill.persisted?
      if @student_skill.demonstrated?
        @student_skill.unmark_demonstrated!
      else
        @student_skill.mark_demonstrated!(current_user)
      end
    else
      @student_skill.mark_demonstrated!(current_user)
      @student_skill.save!
    end

    # Reload to ensure we have fresh data
    @student_skill.reload
    @skill.reload if @skill.changed?

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to student_path(@student) }
    end
  end

  private

  def set_student_and_skill
    @student = Student.find(params[:id])
    @skill = Skill.find(params[:skill_id])
  end

  def authorize_student_access
    unless @student && @student.user == current_user
      redirect_to root_path, alert: 'You do not have permission to access this student.'
    end
  end
end

