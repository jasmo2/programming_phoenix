defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel
  def join("videos_c:" <> video_id,  _params, socket) do
    {:ok, socket}
  end
  def handle_info(message, socket) do
    broadcast!(socket, "new_annotation", %{
      user: %{username: "anon"}
      body: params["body"]
      at: params["at"]
    })
    {:reply, :ok, socket}
  end
end
