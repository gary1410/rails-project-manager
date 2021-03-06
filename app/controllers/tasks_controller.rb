class TasksController < ApplicationController

  def index
    @tasks = Task.where(project_id: params[:project_id])
    @project = Project.find(params[:project_id])
    render :index, layout: false
  end

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
      redirect_to project_path(@task.project)
    else
      flash[:error] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy!
  end


private

  def params_task
    params.require(:task).permit(:name, :description, :difficulty_level, :project_id)
  end

end
