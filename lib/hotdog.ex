defmodule Hotdog do
  use Application
  require Logger
  alias Alchemy.Client

  def start(_type, _args) do
    case Application.get_env(:hotdog, :token) do
      nil ->
        raise "HOTDOG_TOKEN environment variable is not set"

      token ->
        run = Client.start(token)
        use Hotdog.Events
        run
    end
  end
end
