defmodule VolareWeb.Auth.RevolutController do
  use VolareWeb, :controller

  def callback(conn, params) do
    conn
    |> text(params |> Jason.encode!())
  end
end
