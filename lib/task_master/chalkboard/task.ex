defmodule TaskMaster.Chalkboard.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :description, :string
    field :title, :string
    field :board_id, :integer, default: 1

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :board_id])
    |> validate_required([:title, :description, :board_id])
  end




end
