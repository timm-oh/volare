defmodule Volare.Payments.Revolut do

  def create_consent(payment_token, amount, currency, callback_url) do
    %{access_token: access_token} = Volare.Auth.Revolut.get_access_token()
    payload = %{
      "Data" => %{
        "Initiation" => %{
          "InstructionIdentification" => payment_token,
          "EndToEndIdentification" => payment_token,
          "InstructedAmount" => %{
            "Amount" => amount,
            "Currency" => currency
          },
          "CreditorAccount" => %{
            "SchemeName" => "UK.OBIE.SortCodeAccountNumber",
            "Identification" => "00000070207055",
            "Name" => "Receiver Co."
          },
          "RemittanceInformation" => %{
            "Reference" => payment_token,
          }
        }
      },
      "Risk" => %{
        "PaymentContextCode" => "BillPayment",
        "MerchantCategoryCode" => "5967",
        "MerchantCustomerIdentification" => "1238808123123",
      }
    }

    header = %{
      "typ" => "JOSE",
      "alg" => "PS256",
      "kid" => Volare.Auth.Revolut.kid(),
      "crit" => ["http://openbanking.org.uk/tan"],
      "http://openbanking.org.uk/tan" => "macbook.volareee.com"
    }

    req =
      Req.new(
        headers: [
          {"x-fapi-financial-id", "001580000103UAvAAM"},
          {"Authorization", "Bearer #{access_token}"},
          {"x-idempotency-key", payment_token},
        ],
        json: payload,
        url: "https://sandbox-oba.revolut.com/domestic-payment-consents"
      )
      |> Req.Request.append_request_steps(
        jwt_signature: fn request ->
          signature = sign(header, request.body)
            |> String.replace(~r/\..+\./, "..")

          request
          |> Req.Request.put_header("x-jws-signature", signature)
        end
      )

    case Req.post(req) do
      {:ok, %{status: 201, body: body}} ->
        %{"Data" => %{"ConsentId" => consent_id}} = body
        {:ok, redirect_to_oauth(consent_id, payment_token, callback_url)}
      _ -> {:error, :failed_to_create_consent}
    end
  end

  defp redirect_to_oauth(consent_id, payment_token, callback_url) do
    header = %{
      "alg" => "PS256",
      "kid" => Volare.Auth.Revolut.kid()
    }

    params = %{
      "response_type" => "code id_token",
      "client_id" => Volare.Auth.Revolut.client_id(),
      "redirect_uri" => callback_url,
      "scope" => "payments",
      "state" => payment_token,
    }

    body = params
      |> Map.merge(%{
        "claims" => %{
            "id_token" => %{
                "openbanking_intent_id" => %{
                    "value" => consent_id
                }
            }
        }
      })

    signed_request = sign(header, body |> Jason.encode_to_iodata!())

    Volare.Auth.Revolut.base_url()
    |> URI.new!
    |> URI.append_path("/ui/index.html")
    |> URI.append_query(URI.encode_query(params))
    |> URI.append_query(URI.encode_query(%{"request" => signed_request}))
  end

  defp sign(header, payload) do
    # TODO: figure out why the jose lib doesn't work
    {result, 0} = System.cmd(
      "#{File.cwd!}/lib/volare/payments/revolut_jws.sh",
      [
        header |> Jason.encode!(),
        payload |> to_string(),
        Volare.Auth.Revolut.private_key_path()
      ]
    )
    result
  end
end
