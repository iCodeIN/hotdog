defmodule Hotdog.Manager.Supervisor do
  use DynamicSupervisor
  alias Hotdog.Manager

  def start_link(kind) do
    DynamicSupervisor.start_link(__MODULE__, [], name: Manager.supervisor(kind))
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(kind, worker, id) do
    DynamicSupervisor.start_child(
      Manager.supervisor(kind),
      %{
        :id => id,
        :start => {worker, :start_link, [[Manager.registry(kind), id]]},
        :restart => :transient
      }
    )
  end
end
