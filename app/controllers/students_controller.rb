class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student
  before_action :authorize_student_access

  def show
    @sections = Section.ordered.includes(:skills)
    @student_skills_map = @student.student_skills.index_by(&:skill_id)
    @badges = @student.badges.includes(:section).order(awarded_at: :desc)
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def authorize_student_access
    unless @student.user == current_user
      redirect_to root_path, alert: 'You do not have permission to access this student.'
    end
  end
end




