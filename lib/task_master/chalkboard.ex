defmodule TaskMaster.Chalkboard do
  @moduledoc """
  The Chalkboard context.
  """

  import Ecto.Query, warn: false
  alias TaskMaster.Repo

  alias TaskMaster.Chalkboard.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  #this is the "edit" function
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """


  #dev intervention, change this so  that it moves it to another page


  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end





  #this is where I also need to add the functionality of updating the trashed_at attribute form being nil to the current time, then back to nil
  #now I need to enqueue the oban job that I made in the garbage_man module
  def move_task(%Task{} = task) do
    attrs = %{board_id: 2, trashed_at: DateTime.utc_now()}
    case task
         |> Task.changeset(attrs)
         |> TaskMaster.Repo.update() do
      {:ok, updated_task} ->
        %{"task_id" => updated_task.id}
        |> TaskMaster.Jobs.GarbageMan.new(schedule_in: 24 * 60 * 60)
        |> Oban.insert()
      {:error, _} ->
        :error
    end
  end





  def move_back(%Task{} = task) do
    attrs = %{board_id: 1, trashed_at: nil}
    task
    |> Task.changeset(attrs)
    |> TaskMaster.Repo.update()
  end

end
