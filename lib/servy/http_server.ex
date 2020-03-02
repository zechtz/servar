#server() ->
  #{ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0}, {active, false}]),
  #{ok, Sock} = gen_tcp:accept(LSock),
  #{ok, Bin} = do_recv(Sock, []),
  #ok = gen_tcp:close(Sock)
  #Bin.
# variables in Erlang starting with small letters are atoms in Elixir
# while those starting with capital letters are just normal variables
# calling erlang module from elixir you prefix with colon and use dot to call functions

defmodule Servy.HttpServer do
  def server do
    {:ok, lsock} = :gen_tcp.listen(5678, [:binary, packet: 0, active: false])
    {:ok, sock} = :gen_tcp.accept(lsock)
    {:ok, bin} = :gen_tcp.recv(sock, 0)
    :ok = :gen_tcp.close(sock)
    bin
  end
end
