defmodule Hotdog.Bot.Events do
  use Alchemy.Events
  alias Hotdog.{Manager, Worker}
  alias Alchemy.{Events, Cache}

  Events.on_message(:on_message)
  def on_message(message) do
    {:ok, guild_id} = Cache.guild_id(message.channel_id)
    worker = Manager.guild(guild_id)
    Worker.Guild.handle(worker, message)
  end
end
