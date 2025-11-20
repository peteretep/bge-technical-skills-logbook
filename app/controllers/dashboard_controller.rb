class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @classrooms = current_user.classrooms.order(:name)
    @classroom = Classroom.new
  end

  def create
    @classroom = current_user.classrooms.build(classroom_params)

    if @classroom.save
      redirect_to root_path, notice: 'Classroom created successfully.'
    else
      @classrooms = current_user.classrooms.order(:name)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def classroom_params
    params.require(:classroom).permit(:name, :year_group)
  end
end




