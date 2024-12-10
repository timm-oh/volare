defmodule Volare.Auth.Revolut do
  def get_access_token do
    %{body: body} =
      Req.post!(
        url: "https://sandbox-oba-auth.revolut.com/token",
        form: %{
          "grant_type" => "client_credentials",
          "scope" => "payments",
          "client_id" => client_id()
        },
        connect_options: connect_options()
      )

    %{access_token: body["access_token"]}
  end

  def authorize!(code) do
    %{body: body} =
      Req.post!(
        url: "https://sandbox-oba-auth.revolut.com/token",
        form: %{
          "grant_type" => "authorization_code",
          "code" => code,
          "client_id" => client_id(),
          "scope" => "payments"
        }
      )

    %{access_token: body["id_token"]}
  end

  def kid do
    "T3vLpq0TDW6UBGYy7fz2K0B/lrWfB7g0mrtaGAnHmPT9awshPmdtbbCT38rSfJoI"
  end

  def private_key_path do
    cert_path("private.key")
  end

  defp connect_options do
    [
      transport_opts: [
        certfile: cert_path("transport.pem"),
        keyfile: cert_path("private.key"),
        verify: :verify_none
      ]
    ]
  end

  defp cert_path(file) do
    "#{File.cwd!()}/certs/revolut/#{file}"
  end

  def base_url do
    "https://sandbox-oba.revolut.com"
  end

  def client_id do
    "90969d62-82a1-4a95-8d75-b77e5c3cfa65"
  end
end
