defmodule TaskMaster.ChalkboardFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskMaster.Chalkboard` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> TaskMaster.Chalkboard.create_task()

    task
  end
end
