defmodule TaskMasterWeb.PageController do
  use TaskMasterWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
