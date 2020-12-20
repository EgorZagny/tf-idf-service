defmodule TfIdfService.Router do
    use Plug.Router
  
    plug :match
    plug :dispatch
    plug Plug.Parsers, parsers: [:urlencoded]
  
    post "/tfIdf" do
        {:ok, data, _conn} = read_body(conn)
        data = Poison.decode!(data)
        result = "#{TfIdfService.tfIdf(data)}"
        send_resp(conn, 200, result)
    end

    match _ do
        send_resp(conn, 404, "Requested page not found!")
    end
  end