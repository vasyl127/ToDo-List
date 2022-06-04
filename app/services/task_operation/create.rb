  module TaskOperation
    class Create
      def initialize(task_params)
        @task = Task.new(task_params)
        create_task
      end

      def create_task
        @task.save

          # respond_to do |format|
        #   if @task.save
        #     format.html { redirect_to task_url(@task), notice: "Task was successfully created." }
        #     format.json { render :show, status: :created, location: @task }
        #   else
        #     format.html { render :new, status: :unprocessable_entity }
        #     format.json { render json: @task.errors, status: :unprocessable_entity }
        #   end
        # end
      end
    end
  end
