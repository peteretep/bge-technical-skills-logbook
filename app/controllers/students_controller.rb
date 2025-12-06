# app/controllers/students_controller.rb

class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_classroom, only: [ :create, :destroy ]
  before_action :set_student, except: [ :create ]
  before_action :authorize_student, except: [ :create ]
  before_action :authorize_classroom, only: [ :create, :destroy ]

  def create
    @student = @classroom.students.build(student_params)

    if @student.save
      redirect_to classroom_path(@classroom, add_student: true), notice: "Student added successfully."
    else
      @students = @classroom.students.order(:last_name, :first_name)
      @sections = Section.ordered.includes(:skills)
      @total_skills_by_level = {
        bronze: Skill.bronze.count,
        silver: Skill.silver.count,
        gold: Skill.gold.count
      }
      render "classrooms/show", status: :unprocessable_entity
    end
  end

  def destroy
    @student = @classroom.students.find(params[:id])
    @student.destroy
    redirect_to classroom_path(@classroom), notice: "Student removed successfully."
  end

  def show
    # Group sections by category
    @sections_by_category = Section.ordered.group_by(&:category)
    
    # Calculate badge counts
    @bronze_count = @student.badges.where(level: :bronze).count
    @silver_count = @student.badges.where(level: :silver).count
    @gold_count = @student.badges.where(level: :gold).count
    
    # Category configuration
    @categories = {
      "Design and Construct" => {
        icon: "🔨",
        gradient: "from-blue-500 to-blue-600",
        border: "border-blue-500",
        text_color: "text-blue-600",
        description: "Hand tools and workshop processes",
        total: @sections_by_category["Design and Construct"]&.count || 0,
        started: sections_started_count(@student, "Design and Construct"),
        skills: skills_demonstrated_count(@student, "Design and Construct")
      },
      "Materials" => {
        icon: "🌳",
        gradient: "from-green-500 to-green-600",
        border: "border-green-500",
        text_color: "text-green-600",
        description: "Wood, plastics, metals, and sustainability",
        total: @sections_by_category["Materials"]&.count || 0,
        started: sections_started_count(@student, "Materials"),
        skills: skills_demonstrated_count(@student, "Materials")
      },
      "Graphics" => {
        icon: "🎨",
        gradient: "from-orange-500 to-orange-600",
        border: "border-orange-500",
        text_color: "text-orange-600",
        description: "Sketching, CAD, graphic design, and digital fabrication",
        total: @sections_by_category["Graphics"]&.count || 0,
        started: sections_started_count(@student, "Graphics"),
        skills: skills_demonstrated_count(@student, "Graphics")
      }
    }
  end

  def award_badge
    section = Section.find(params[:section_id])
    level = params[:level].to_sym
    
    if @student.ready_for_badge?(section, level)
      Badge.create!(
        student: @student,
        section: section,
        level: level,
        awarded_by: current_user,
        awarded_at: Date.today
      )
      
      flash[:notice] = "#{level.to_s.capitalize} badge awarded to #{@student.full_name}!"
    else
      flash[:alert] = "Student is not ready for this badge yet."
    end
    
    redirect_to student_path(@student)
  end

  private

  def set_classroom
    @classroom = current_user.classrooms.find(params[:classroom_id])
  end

  def set_student
    @student = Student.find(params[:id])
  end

  def authorize_classroom
    unless @classroom.user == current_user
      redirect_to dashboard_path, alert: "You don't have access to that classroom."
    end
  end

  def authorize_student
    unless @student.classroom.user == current_user
      redirect_to dashboard_path, alert: "You don't have access to that student."
    end
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name)
  end

  def sections_started_count(student, category)
    sections = Section.where(category: category)
    sections.count do |section|
      student.student_skills.joins(:skill).where(skills: { section: section }).any?
    end
  end

  def skills_demonstrated_count(student, category)
    student.student_skills
      .where(demonstrated: true)
      .joins(:skill)
      .joins('INNER JOIN sections ON skills.section_id = sections.id')
      .where(sections: { category: category })
      .count
  end
end