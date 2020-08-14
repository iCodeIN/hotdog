defmodule Hotdog.Worker.Guild do
  use GenServer
  require Logger
  alias Hotdog.Manager
  alias Hotdog.Worker

  def start_link([registry, id]) do
    GenServer.start_link(__MODULE__, id, name: via_tuple(registry, id))
  end

  def handle(pid, message), do: GenServer.cast(pid, {:handle, message})

  def init(id) do
    Logger.info("Starting guild worker: #{inspect id}")
    {:ok, []}
  end

  def handle_cast({:handle, message}, state) do
    worker = Manager.channel(message.channel_id)
    Worker.Channel.handle(worker, message)
    {:noreply, state}
  end

  defp via_tuple(registry, id) do
    {:via, Registry, {registry, id}}
  end
end
