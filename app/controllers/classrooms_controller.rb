class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_classroom, only: [ :show, :bulk_mark_skills, :bulk_mark ]
  before_action :authorize_classroom_owner, only: [ :show, :bulk_mark_skills, :bulk_mark ]

  def show
    @students = @classroom.students
                          .includes(student_skills: :skill)
                          .order(:last_name, :first_name)
    @student = @classroom.students.build
    @sections = Section.ordered.includes(:skills)

    # Cache total skills count for efficiency
    @total_skills_by_level = {
      bronze: Skill.bronze.count,
      silver: Skill.silver.count,
      gold: Skill.gold.count
    }
  end

  def bulk_mark_skills
    skill = Skill.find(params[:skill_id])
    student_ids = params[:student_ids] || []

    if student_ids.empty?
      redirect_to bulk_mark_classroom_path(@classroom), alert: "Please select at least one student."
      return
    end

    students = @classroom.students.where(id: student_ids)
    marked_count = 0

    students.each do |student|
      student_skill = StudentSkill.find_or_initialize_by(
        student: student,
        skill: skill
      )
      unless student_skill.demonstrated?
        student_skill.mark_demonstrated!(current_user)
        marked_count += 1
      end
    end

    respond_to do |format|
      format.html {
        redirect_to bulk_mark_classroom_path(@classroom),
                    notice: "Marked '#{skill.description}' as demonstrated for #{marked_count} student(s)."
      }
      format.turbo_stream {
        flash.now[:notice] = "Marked '#{skill.description}' as demonstrated for #{marked_count} student(s)."
        render turbo_stream: turbo_stream.update("flash-messages", partial: "shared/flash")
      }
    end
  end

  def bulk_mark
    @students = @classroom.students.order(:last_name, :first_name)
    @sections_by_category = Section.ordered.group_by(&:category)

    # Category configuration (same as StudentsController but without student-specific counts)
    @categories = {
      "Design and Construct" => {
        icon: "🔨",
        gradient: "from-blue-500 to-blue-600",
        border: "border-blue-500",
        text_color: "text-blue-600",
        description: "Hand tools and workshop processes",
        total: @sections_by_category["Design and Construct"]&.count || 0
      },
      "Materials" => {
        icon: "🌳",
        gradient: "from-green-500 to-green-600",
        border: "border-green-500",
        text_color: "text-green-600",
        description: "Wood, plastics, metals, and sustainability",
        total: @sections_by_category["Materials"]&.count || 0
      },
      "Graphics" => {
        icon: "🎨",
        gradient: "from-orange-500 to-orange-600",
        border: "border-orange-500",
        text_color: "text-orange-600",
        description: "Sketching, CAD, graphic design, and digital fabrication",
        total: @sections_by_category["Graphics"]&.count || 0
      }
    }
  end

  private

  def set_classroom
    @classroom = current_user.classrooms.find(params[:id])
  end

  def authorize_classroom_owner
    classroom = @classroom || current_user.classrooms.find(params[:id])
    unless classroom.user == current_user
      redirect_to root_path, alert: "You do not have permission to access this classroom."
    end
  end
end
