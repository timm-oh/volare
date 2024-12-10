defmodule VolareWeb.RevolutController do
  use VolareWeb, :controller

  def jwk(conn, _params) do
    text(conn, """
    {
      "keys": [
        {
          "e": "AQAB",
          "n": "oxCsRFP83JBQBi_ebDVSF6f7Oqv179NGJZ7bH-j9yNdVCk5kHCHtCzqd_mAjjcswF6YB3ZCsDHxbF73asIAaJ18lqjQSN3TIe4qHfTnvHRjE9v3IW19uwoLN4Jg6kNmzDhplAqd8pb2xjfzr3_J13WpeUwiO4fAuauZfvufKOHwZlU-_JaOt9LbJ0xV-yrolQ3M8w0f8nMtqkqMWyqLBBkL-2qB2TuumOH8gB_QjKQuTv6FvThizc58aEHyRAwCXuM2tS2EDjhWdLxfyzC5kfgbcId3JS0aifVRiBZyKrp75iietEDzTd-RRQZzHcU7QnBTHtmJ2M_M1N8cYjsdZAQ",
          "kid": "#{Volare.Auth.Revolut.kid()}",
          "kty": "RSA",
          "use": "sig"
        }
      ]
    }
    """)
  end
end
