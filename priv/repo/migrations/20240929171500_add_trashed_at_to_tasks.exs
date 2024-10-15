defmodule TaskMaster.Repo.Migrations.AddTrashedAtToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :trashed_at, :utc_datetime
    end
  end
end
