class TasksController < ApplicationController
#  before_action :set_task, only: [:edit, :destroy]


  def new
    @task = Task.new
    render :layout => false
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:notice] = "Task successfully created."
      redirect_to :action => 'task_list'
    else
      render :new, layout: false
    end
  end

  def task_list
    @tasks = Task.paginate(page: params[:page], per_page: 10)
    render :layout => false
  end


  def edit
    @task = Task.find(params[:id])
    render :layout => false
  end

  def update_task
    @task = Task.find(params[:id])
     if @task.update(task_params)
      flash[:notice] = "Task successfully updated."
      redirect_to :action => 'task_list'
    else
      flash[:notice] = "Task not updated."
      render :new, layout: false
    end
  end

  def delete_task
    @task = Task.find(params[:id])
    if @task.destroy
      flash[:notice] = "Task successfully deleted."
    else
      flash[:notice] = "Task not deleted."
    end
    redirect_to :action => 'task_list'
  end

  private

  def task_params
    params.require(:task).permit(:title, :status, :date)
  end
  #def set_task
   # @task = Task.find(params[:id])
  #end

end

