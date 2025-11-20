class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_classroom, only: [:show, :bulk_mark_skills]
  before_action :authorize_classroom_owner, only: [:show, :create_student, :destroy_student, :bulk_mark_skills]

  def show
    @students = @classroom.students.order(:last_name, :first_name)
    @student = @classroom.students.build
    @sections = Section.ordered.includes(:skills)
  end

  def bulk_mark_skills
    skill = Skill.find(params[:skill_id])
    student_ids = params[:student_ids] || []

    if student_ids.empty?
      redirect_to classroom_path(@classroom), alert: 'Please select at least one student.'
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

    redirect_to classroom_path(@classroom), 
                notice: "Marked '#{skill.description}' as demonstrated for #{marked_count} student(s)."
  end

  def create_student
    @classroom = current_user.classrooms.find(params[:id])
    @student = @classroom.students.build(student_params)

    if @student.save
      redirect_to classroom_path(@classroom), notice: 'Student added successfully.'
    else
      @students = @classroom.students.order(:last_name, :first_name)
      render :show, status: :unprocessable_entity
    end
  end

  def destroy_student
    @classroom = current_user.classrooms.find(params[:id])
    @student = @classroom.students.find(params[:student_id])
    @student.destroy
    redirect_to classroom_path(@classroom), notice: 'Student removed successfully.'
  end

  private

  def set_classroom
    @classroom = current_user.classrooms.find(params[:id])
  end

  def authorize_classroom_owner
    classroom = @classroom || current_user.classrooms.find(params[:id])
    unless classroom.user == current_user
      redirect_to root_path, alert: 'You do not have permission to access this classroom.'
    end
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name)
  end
end

