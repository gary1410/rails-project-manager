class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @projects = Project.page(params[:page]).per(10)
  end

  def show
    if @project.owners.where(id: current_user.id).first || @project.viewers.where(id: current_user.id).first
      render :show
    else
      flash[:warning] = "Can't view because this isn't your project"
      redirect_to projects_path
    end
  end

  def new
    @project = Project.new
  end

  def edit
    if @project.owners.where(id: current_user.id).first || current_user.admin? == true
      render :edit
    else
      flash[:warning] = "You don't have Owner and Admin privileges"
      redirect_to projects_path
    end
  end

  def create
    @project = Project.new(project_params)
    @project.owners << current_user
    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @project.owners.where(id: current_user.id).first || current_user.admin? == true
        @project.destroy
        format.html { redirect_to projects_path, notice: "Successfully Deleted."}
      else
        flash[:warning] = "You don't have Owner and Admin privileges"
        redirect_to projects_path
      end
    end
  end

#Attempt here to delete a task on ajax

  # def destroy
  #   if @project.owners.where(id: current_user.id).first || current_user.admin? == true
  #     @project.destroy
  #     # format.html { redirect_to projects_path, notice: "Successfully Deleted!"}
  #     render json: { task_list: render_to_string( partial: "tasks") }
  #   else
  #     render json: { error: @project.errors.full_messages.join(", ")}, status: :unprocessible_entity
  #     # flash[:warning] = "You don't have Owner and Admin privileges"
  #     # redirect_to projects_path
  #   end
  # end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name)
    end
end
