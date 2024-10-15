defmodule TaskMaster.Jobs.GarbageMan do
  use Oban.Worker, queue: :default

  @impl true

  #alterable, this is the amount of time that must pass for the task to be deleted
  @time_cycle 24 * 60 * 60


  #the logic of the worker...
  # task gets moved to the oban worker (it gets inserted)
  # case statement?
  # if current_time - trashed_at is greater than time_cycle
  # if the criteria is met, we delete the task: TaskMaster.Chalkboard.delete_task(TaskMaster.Chalkboard.get_task!(task_id))
  # if its not, it needs to check again right? it needs to check so long as the trashed_at is NOT nil
  # if trashed at is nil, then :ok, stop the worker


  #could I use tail recursion???
  #nah man this is dumb cause like, it is just going to keep checking forever and ever until 20 seconds have passed, thats not going to scale well
  #say I change the time to be a full 24 hours, say its even


  def perform(%Oban.Job{args: %{"task_id" => task_id}}) do
    task = TaskMaster.Chalkboard.get_task!(task_id)
    case task.trashed_at do
      nil ->
        :ok
      _ ->
        if DateTime.diff(DateTime.utc_now(), task.trashed_at) >= @time_cycle do
          TaskMaster.Chalkboard.delete_task(task)
          :ok
        else
          {:error, "task could not be deleted, not time yet"}
        end
    end
  end
end
