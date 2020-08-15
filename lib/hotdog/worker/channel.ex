defmodule Hotdog.Worker.Channel do
  use GenServer
  require Logger
  alias Hotdog.Hot.Counter

  def start_link([registry, id]) do
    GenServer.start_link(__MODULE__, id, name: via_tuple(registry, id))
  end

  def handle(pid, message), do: GenServer.cast(pid, {:handle, message})

  def init(id) do
    Logger.info("Starting channel worker #{inspect id}")
    Counter.start_link([])
  end

  def handle_cast({:handle, message}, agent) do
    {:ok, time, _} = DateTime.from_iso8601(message.timestamp)
    Counter.add(agent, time)

    if message.content == "<@!#{Alchemy.Cache.user().id}>" do
      count = Counter.count(agent, DateTime.now!("Etc/UTC"))
      Alchemy.Client.send_message(message.channel_id, count)
    end

    {:noreply, agent}
  end

  defp via_tuple(registry, id) do
    {:via, Registry, {registry, id}}
  end
end
