defmodule Hotdog.Bot do
  alias Alchemy.Client

  def start(token) do
    run = Client.start(token)
    use Hotdog.Bot.Events
    run
  end

  def child_spec(opts) do
    %{
      id: Bot,
      start: {__MODULE__, :start, [opts]},
      type: :supervisor,
    }
  end
end
