module RakeUi
  class RakeTasksController < RakeUi::ApplicationController

    def index
      @rake_tasks = RakeUi::RakeTask.all
      @user_email = current_user.email

      unless params[:show_all]
        @rake_tasks = @rake_tasks.select(&:internal_task?)
      end

      respond_to do |format|
        format.html
        format.json do
          render json: {
            rake_tasks: rake_tasks_as_json(@rake_tasks)
          }
        end
      end
    end

    def show
      @rake_task = RakeUi::RakeTask.find_by_id(params[:id])
      @user_email = current_user.email

      respond_to do |format|
        format.html
        format.json do
          render json: {
            rake_task: rake_task_as_json(@rake_task)
          }
        end
      end
    end

    def execute
      @rake_task = RakeUi::RakeTask.find_by_id(params[:id])

      rake_task_log = @rake_task.call(
        args: params[:args],
        environment: params[:environment],
        user_email: current_user.email
      )

      redirect_to rake_task_log_path rake_task_log.id
    end
  end
end