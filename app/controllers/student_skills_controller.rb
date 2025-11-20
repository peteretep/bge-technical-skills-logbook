class StudentSkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student_and_skill
  before_action :authorize_student_access

  def toggle
    @student_skill = StudentSkill.find_or_initialize_by(
      student: @student,
      skill: @skill
    )

    # Toggle the demonstrated status
    if params[:demonstrated]
      @student_skill.demonstrated = true
      @student_skill.demonstrated_at = Date.today
    else
      @student_skill.demonstrated = false
      @student_skill.demonstrated_at = nil
    end
    
    @student_skill.save!
    
    # Get the section for this skill
    @section = @skill.section
    @level = @skill.level
    
    # Calculate updated counts
    @demonstrated_count = @student.demonstrated_skills_for(@section, @level).count
    @total_skills = @section.skills.where(level: @level).count
    @percentage = @total_skills > 0 ? (@demonstrated_count.to_f / @total_skills * 100).round : 0
    
    # Check badge status
    @has_badge = @student.has_badge?(@section, @level)
    @ready_for_badge = @student.ready_for_badge?(@section, @level) && !@has_badge
    
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_student_and_skill
    @student = Student.find(params[:id])
    @skill = Skill.find(params[:skill_id])
  end

  def authorize_student_access
    unless @student && @student.classroom.user == current_user
      head :forbidden
    end
  end
end