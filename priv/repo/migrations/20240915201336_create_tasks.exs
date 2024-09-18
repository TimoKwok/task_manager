defmodule TaskMaster.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:tasks) do
      add :title, :string
      add :description, :text
      timestamps()
    end
  end
end
