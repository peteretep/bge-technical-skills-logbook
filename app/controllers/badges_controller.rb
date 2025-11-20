class BadgesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student
  before_action :authorize_student_access

  def create
    @badge = @student.badges.build(badge_params)
    @badge.awarded_by = current_user

    if @badge.save
      redirect_to student_path(@student), notice: "#{@badge.level_name} badge awarded successfully!"
    else
      redirect_to student_path(@student), alert: @badge.errors.full_messages.join(', ')
    end
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def authorize_student_access
    unless @student.user == current_user
      redirect_to root_path, alert: 'You do not have permission to access this student.'
    end
  end

  def badge_params
    params.require(:badge).permit(:section_id, :level)
  end
end




