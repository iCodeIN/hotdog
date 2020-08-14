defmodule Hotdog.Manager.Repository do
  use Supervisor
  alias Hotdog.Manager

  def start_link(kind) do
    Supervisor.start_link(__MODULE__, kind)
  end

  def init(kind) do
    children = [
      {Manager.Supervisor, kind},
      {Registry, [keys: :unique, name: Manager.registry(kind)]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
