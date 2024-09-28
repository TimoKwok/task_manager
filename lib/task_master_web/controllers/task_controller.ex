defmodule TaskMasterWeb.TaskController do
  use TaskMasterWeb, :controller

  alias TaskMaster.Chalkboard
  alias TaskMaster.Chalkboard.Task

  def index(conn, _params) do
    tasks = Chalkboard.list_tasks()
    render(conn, :index, tasks: tasks)
  end



  def trash(conn, _params) do
    tasks = Chalkboard.list_tasks()
    render(conn, :trash, tasks: tasks)
  end





  def new(conn, _params) do
    changeset = Chalkboard.change_task(%Task{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    case Chalkboard.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task has been added to the board")
        |> redirect(to: ~p"/tasks/#{task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Chalkboard.get_task!(id)
    render(conn, :show, task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Chalkboard.get_task!(id)
    changeset = Chalkboard.change_task(task)
    render(conn, :edit, task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Chalkboard.get_task!(id)
    IO.inspect(task_params)
    IO.inspect("HELLOOO TIMOOOO")

    case Chalkboard.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: ~p"/tasks/#{task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Chalkboard.get_task!(id)
    {:ok, _task} = Chalkboard.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: ~p"/tasks/trash")
  end

    def move(conn, %{"id" => id}) do
    task = Chalkboard.get_task!(id)
    {:ok, _task} = Chalkboard.move_task(task)

    conn
    |> put_flash(:info, "Task Has Been Moved To Trash")
    |> redirect(to: ~p"/tasks")
  end

  def recover(conn, %{"id" => id}) do
    task = Chalkboard.get_task!(id)
    {:ok, _task} = Chalkboard.move_back(task)
    conn
    |> put_flash(:info, "Task Has Been Recovered")
    |> redirect(to: ~p"/tasks/trash")
  end


end
