defmodule Hotdog.Hot.Counter do
  use Agent

  @period 3600 # secs

  def start_link(_args) do
    Agent.start_link(fn -> %{
      list: [],
      count: 0,
    } end)
  end

  def add(pid, time) do
    Agent.update(pid, fn state -> %{
      list: [time | state.list],
      count: state.count + 1,
    } end)
  end

  def count(pid, now) do
    drop_old(pid, now)
    Agent.get(pid, fn state -> state.count end)
  end

  defp drop_old(pid, now) do
    since = now |> DateTime.add(-@period, :second)
    Agent.update(pid, fn state ->
      {dropped_list, list} = state.list
        |> Enum.split_with(fn time ->
          DateTime.compare(time, since) == :lt
        end)
      drop_count = dropped_list |> Enum.count

      %{
        list: list,
        count: state.count - drop_count,
      }
    end)
  end
end
