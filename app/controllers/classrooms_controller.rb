class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_classroom, only: [ :show, :bulk_mark_skills, :bulk_mark, :viable_badges, :award_viable_badge, :award_all_viable_badges ]
  before_action :authorize_classroom_owner, only: [ :show, :bulk_mark_skills, :bulk_mark, :viable_badges, :award_viable_badge, :award_all_viable_badges ]

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

  def viable_badges
    @students = @classroom.students.includes(:badges, student_skills: :skill).order(:last_name, :first_name)
    @sections = Section.ordered.includes(:skills)

    # Build list of viable badges: student, section, level combinations where student is ready
    @viable_badges = []

    @students.each do |student|
      @sections.each do |section|
        [:bronze, :silver, :gold].each do |level|
          if student.ready_for_badge?(section, level) && !student.has_badge?(section, level)
            @viable_badges << {
              student: student,
              section: section,
              level: level,
              level_name: level.to_s.capitalize,
              level_icon: level == :bronze ? '🥉' : (level == :silver ? '🥈' : '🥇')
            }
          end
        end
      end
    end
  end

  def award_viable_badge
    student = @classroom.students.find(params[:student_id])
    section = Section.find(params[:section_id])
    level = params[:level].to_sym

    if student.ready_for_badge?(section, level) && !student.has_badge?(section, level)
      Badge.create!(
        student: student,
        section: section,
        level: level,
        awarded_by: current_user,
        awarded_at: Date.today
      )
      redirect_to viable_badges_classroom_path(@classroom), notice: "#{level.to_s.capitalize} badge awarded to #{student.full_name}!"
    else
      redirect_to viable_badges_classroom_path(@classroom), alert: "Badge cannot be awarded."
    end
  end

  def award_all_viable_badges
    awarded_count = 0
    students = @classroom.students.includes(:badges, student_skills: :skill)
    sections = Section.all

    students.each do |student|
      sections.each do |section|
        [:bronze, :silver, :gold].each do |level|
          if student.ready_for_badge?(section, level) && !student.has_badge?(section, level)
            Badge.create!(
              student: student,
              section: section,
              level: level,
              awarded_by: current_user,
              awarded_at: Date.today
            )
            awarded_count += 1
          end
        end
      end
    end

    redirect_to viable_badges_classroom_path(@classroom), notice: "Awarded #{awarded_count} badge(s) successfully!"
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
