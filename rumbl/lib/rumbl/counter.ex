defmodule Rumbl.Counter do
  use GenServer

  def inc(pid), do: GenServer.cast(pid, :inc)

  def dec(pid), do: GenServer.cast(pid, :dec)

  # ref = make_ref()
  # send(pid, {:val, self(), ref})
  # receive do
  #   {^ref, val} -> val
  # after timeout -> exit(:timeout)
  # end
  def val(pid) do
    # GenServer.call(server, request)
    GenServer.call(pid, :val)
  end

  def start_link(initial_val) do
    # {:ok, spawn_link(fn -> listen(initial_val) end)}
    GenServer.start_link(__MODULE__, initial_val)
  end

  # ~~~~~~~~~~~~~~ Server functions ~~~~~~~~~~
  def init(initial_val) do
    Process.send_after(self, :tick, 1000)
    {:ok, initial_val}
  end
  def handle_info(:tick,val) do
    IO.puts "tick #{val}"
    Process.send_after(self, :tick, 1000)
    {:noreplay, val - 1}
  end
  def handle_cast(:dec, val) do
    {:noreply, val - 1}
  end
  def handle_cast(:inc,val) do
    {:noreply, val + 1}
  end
  def handle_call(:val, _from, val) do
    {:replay, val, val}
  end
  # defp listen(val) do
  #   receive do
  #     :inc -> listen(val + 1)
  #     :dec -> listen(val - 1)
  #     {:val, sender, ref} ->
  #       send sender, {ref, val}
  #       listen(val)
  #   end
  # end
end
