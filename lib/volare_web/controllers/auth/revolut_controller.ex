defmodule VolareWeb.Auth.RevolutController do
  use VolareWeb, :controller

  def callback(conn, params) do
    conn
    |> text(params |> Jason.encode!())
  end

  def create(conn, _params) do
    text(conn, "Hello world")
  end
end
