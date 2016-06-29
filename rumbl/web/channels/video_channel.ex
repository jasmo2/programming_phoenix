defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel
  def join("videos_c:" <> video_id,  _params, socket) do
    {:ok, assign(socket, :video_id, String.to_integer(video_id, 10))}
    
  end
end
