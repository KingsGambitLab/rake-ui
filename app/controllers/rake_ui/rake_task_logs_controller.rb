# frozen_string_literal: true

module RakeUi
  class RakeTaskLogsController < ApplicationController
    RAKE_TASK_LOG_ATTRS = [:id,
      :name,
      :args,
      :environment,
      :rake_command,
      :rake_definition_file,
      :log_file_name,
      :log_file_full_path].freeze

    def index
      @rake_task_logs = RakeUi::RakeTaskLog.all.sort_by(&:id)

      respond_to do |format|
        format.html
        format.json do
          render json: {
            rake_task_logs: rake_task_logs_as_json(@rake_task_logs)
          }
        end
      end
    end

    def show
      key_name = "#{params[:id]}.txt"
      @file_contents_from_s3 = RakeUi::S3Client.get_object_from_s3(bucket: S3_BUCKET, key: key_name)
      @rake_task_log_content = @file_contents_from_s3.gsub("\n", '<br />')
      @rake_task_log_content_url = rake_task_log_path(params[:id], format: :json)
      @is_rake_task_log_finished = @file_contents_from_s3.include?(RakeUi::RakeTaskLog::FINISHED_STRING)

      respond_to do |format|
        format.html
        format.json do
          render json: {
            rake_task_log_content: @rake_task_log_content,
            rake_task_log_content_url: @rake_task_log_content_url,
            is_rake_task_log_finished: @is_rake_task_log_finished
          }
        end
      end
    end

    private

    def rake_task_log_as_json(task)
      RAKE_TASK_LOG_ATTRS.each_with_object({}) do |param, obj|
        obj[param] = task.send(param)
      end
    end

    def rake_task_logs_as_json(tasks = [])
      tasks.map { |task| rake_task_log_as_json(task) }
    end
  end
end
