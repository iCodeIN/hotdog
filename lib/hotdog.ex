defmodule Hotdog do
  use Application

  def start(_args, _opts) do
    children = [
      {Hotdog.Manager, {}},
      {Hotdog.Bot, token()},
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  defp token do
    case Application.get_env(:hotdog, :token) do
      nil ->
        raise "HOTDOG_TOKEN environment variable is not set"

      token ->
        token
    end
  end
end
