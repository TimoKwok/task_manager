defmodule TaskMasterWeb.Router do
  use TaskMasterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TaskMasterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  #what does this do? All requests like this will be handled by the home/2 function in the PageController module
  scope "/", TaskMasterWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/tasks/trash", TaskController, :trash
    get "/tasks/move/:id", TaskController, :move
    get "/tasks/recover/:id", TaskController, :recover
    get "/tasks/chat", TaskController, :chat
    get "/tasks/delete/:id", TaskController, :delete

    resources "/tasks", TaskController
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaskMasterWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:task_master, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TaskMasterWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
