defmodule Playdays.Api.V1.Consumer.TagControllerTest do
  use Playdays.ConnCase, async: false
  import Playdays.Utils.MapUtils


  setup do
    conn = conn()
            |> put_req_header("accept", "application/json")

    tags = create_list(5, :tag)
    {:ok, conn: conn, tags: tags}
  end


  # test "list all tags", %{conn: conn, tags: tags} do
  #   conn = get conn, api_v1_consumer_tag_path(conn, :index)
  #
  #   expected_data = Enum.map(tags, &Map.take(&1, [:id, :title]))
  #
  #   response_data = json_response(conn, 200)["data"] |> to_atom_keys
  #   assert conn.status == 200
  #   assert response_data == expected_data
  # end

end
