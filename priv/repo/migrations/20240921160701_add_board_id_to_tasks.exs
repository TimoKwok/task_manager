defmodule TaskMaster.Repo.Migrations.AddBoardIdToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :board_id, :integer, default: 1
      #makes it so that each tasks is on the main board always, we only add it to the deleted board if it is deleted
    end
  end
end
