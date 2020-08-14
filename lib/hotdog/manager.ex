defmodule Hotdog.Manager do
  use Supervisor
  alias Hotdog.{Manager, Worker}
  alias Manager.Repository

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = [
      Supervisor.child_spec({Repository, :guild}, id: repository(:guild)),
      Supervisor.child_spec({Repository, :channel}, id: repository(:channel)),
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def registry(kind) do
    String.to_atom(Atom.to_string(kind) <> "_repository")
  end

  def repository(kind) do
    String.to_atom(Atom.to_string(kind) <> "_repository")
  end

  def supervisor(kind) do
    String.to_atom(Atom.to_string(kind) <> "_supervisor")
  end

  def guild(id) do
    case Registry.lookup(registry(:guild), id) do
      [{pid, _worker}] -> pid
      [] -> start(:guild, Worker.Guild, id)
    end
  end

  def channel(id) do
    case Registry.lookup(registry(:channel), id) do
      [{pid, _worker}] -> pid
      [] -> start(:channel, Worker.Channel, id)
    end
  end

  def start(kind, worker, id) do
    {:ok, pid} = Manager.Supervisor.start_child(kind, worker, id)
    pid
  end
end
