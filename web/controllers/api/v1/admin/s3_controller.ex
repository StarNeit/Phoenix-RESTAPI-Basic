defmodule Playdays.Api.V1.Admin.S3Controller do
  use Playdays.Web, :controller
  alias Playdays.Services.Admin.S3.S3


  def create(conn, %{"content_type" => content_type, "file_name" => file_name}) do
    url = Application.get_env(:playdays, :ex_aws, [])[:s3]
     |> S3.generate_presign_url(file_name, content_type)

    render conn, "show.json", signed_url: url
  end

  def destroy(conn, %{"file_name" => file_name}) do
    Application.get_env(:playdays, :ex_aws, [])[:s3]
     |> S3.delete_object(file_name)

    send_resp(conn, :no_content, "OK")
  end
end
