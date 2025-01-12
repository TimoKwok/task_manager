defmodule TaskMasterWeb.Master_BoardChannel do
  use TaskMasterWeb, :channel

  @impl true
  def join("master_board:lobby", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("new_task", payload, socket) do #set to pattern match on "new_task", remember this
    broadcast(socket, "new_task", payload) #sends the payload (the task details) to all clients connected to the "master__board:lobby" topic
    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end


end
