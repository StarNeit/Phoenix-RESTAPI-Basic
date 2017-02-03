defmodule Playdays.Services.Admin.S3.S3 do

  def generate_presign_url(s3_env, file_path, content_type) do
    content_type = String.to_char_list(content_type)
    file_path = String.to_char_list(file_path)

    s3_bucket_name = s3_env[:bucket] |> String.to_char_list
    aws_access_key_id = s3_env[:access_key_id] |> String.to_char_list
    aws_secret_access_key = s3_env[:secret_access_key] |> String.to_char_list

    :erlcloud_s3.configure(aws_access_key_id, aws_secret_access_key)
    :erlcloud_s3.make_put_url(3000, s3_bucket_name, file_path, %{content_type: content_type, acl: 'public-read'})
        |> to_string
  end

  def delete_object(s3_env, file_path) do
    file_path = String.to_char_list(file_path)

    s3_bucket_name = s3_env[:bucket] |> String.to_char_list
    aws_access_key_id = s3_env[:access_key_id] |> String.to_char_list
    aws_secret_access_key = s3_env[:secret_access_key] |> String.to_char_list

    conf = :erlcloud_s3.new(aws_access_key_id, aws_secret_access_key)
    [delete_marker: false, version_id: 'null'] = :erlcloud_s3.delete_object(s3_bucket_name, file_path, conf)
    :ok
  end

end
