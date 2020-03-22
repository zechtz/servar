defmodule Servy.PledgeServer do

  @name :pledge_server

  # Client Interface

  def start do
    IO.puts "\nStarting the pledge server..."
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @name)
    pid
  end

  def create_pledge(name, amount) do
    send @name, {self(), :create_pledge, name, amount}

    receive do {:response, response} -> response end
  end

  def recent_pledges do
    send @name, {self(), :recent_pledges}

    receive do {:response, response} -> response end
  end

  def total_pledged do
    send @name, {self(), :total_pledged}

    receive do {:response, response} -> response end
  end

  # Server Interface

  def listen_loop(state) do
    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        new_state = [{name, amount} | state]
        send sender, {:response, id}
        listen_loop(new_state)
      {sender, :recent_pledges} ->
        send sender, {:response, state}
        listen_loop(state)
      {sender, :total_pledged} ->
        total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
        send sender, {:response, total}
        listen_loop(state)
      unexpected ->
        IO.puts "Unexpected message #{inspect unexpected}"
        listen_loop(state)
    end

  end

  defp send_pledge_to_service(name, amount) do
    # CODE GOES HERE TO SEND PLEDGE TO EXTERNAL SERVICE
    {:ok, "pledge-#{:rand.uniform(1000)} by #{name} amount #{amount}"}
  end
end
