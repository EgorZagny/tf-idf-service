defmodule TfIdfService do
  @moduledoc """
  Documentation for `TfIdfService`.
  """

  @doc """
  Service for Tf-Idf

  """
  def main(args \\ []) do
    :timer.sleep(:infinity)
  end

  def tfIdf(data) do
    word = data["word"]
    texts = data["texts"]
    text = Enum.at(texts, data["text"])
    texts = List.delete_at(texts, data["text"])
    tf = Task.async(TfIdfService, :sendRequest, [word, text, "tf"])
    texts = Enum.map(texts, fn(t) -> Task.async(TfIdfService, :sendRequest, [word, t, "isInText"]) end)
    tf = Task.await(tf, 15_000)
    texts = Enum.map(texts, fn(t) -> Task.await(t, 15_000) end)
    idf = :math.log((Enum.count(texts) + 1) / (Enum.reduce(texts, 0, fn(w, acc) -> acc + w end) + 1))
    tf * idf
  end

  def sendRequest(word, text, task) do
    data = Poison.encode!(%{"word" => word, "text" => text})
    response = HTTPotion.post "http://192.168.49.2:30002/" <> task, [body: data, timeout: 14_000]
    response = if isOk(response) == :nil do
      HTTPotion.post "http://192.168.49.2:30002/" <> task, [body: data, timeout: 14_000]
    else
      response
    end
    {result, _} = Float.parse(response.body)
    result
  end

  def isOk(%HTTPotion.ErrorResponse{}) do
    :nil
  end
  def isOk(%HTTPotion.Response{status_code: 200}) do
    :ok
  end
end
