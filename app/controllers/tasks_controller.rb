class TasksController < ApplicationController

	def new
		@task = Task.new(project_id: params[:project_id])
	end

  def create
    @task = Task.new(params_task)
    @task.project_id = params[:project_id]
    if @task.save!
      flash[:success] = "You've saved your Task"
      redirect_to project_path(@task.project_id)
    else
      flash[:error] = "Something went wrong"
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
  @task = Task.find(params[:id])
    if @task.update(params_task)
      flash[:success] = "Updated!"
      redirect_to project_path(@task.project_id)
    else
      flash[:error] = "Something went wrong"
      render :edit
    end
  end

private

  def params_task
    params.require(:task).permit(:name, :description, :difficulty_level, :project_id)
  end

end
