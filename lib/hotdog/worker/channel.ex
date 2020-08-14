defmodule Hotdog.Worker.Channel do
  use GenServer
  require Logger

  def start_link([registry, id]) do
    GenServer.start_link(__MODULE__, id, name: via_tuple(registry, id))
  end

  def handle(pid, message), do: GenServer.cast(pid, {:handle, message})

  def init(id) do
    Logger.info("Starting channel worker #{inspect id}")
    {:ok, []}
  end

  def handle_cast({:handle, message}, state) do
    IO.inspect state
    {:noreply, state ++ [message.content]}
  end

  defp via_tuple(registry, id) do
    {:via, Registry, {registry, id}}
  end
end
