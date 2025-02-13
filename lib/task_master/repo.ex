defmodule TaskMaster.Repo do
  use Ecto.Repo,
    otp_app: :task_master,
    adapter: Ecto.Adapters.Postgres,
    pool_size: 10

  def init(_type, config) do
    {:ok, Keyword.put(config, :url, System.get_env("DATABASE_URL"))}
  end

end
