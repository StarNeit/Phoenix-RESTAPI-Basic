defmodule Playdays.Services.Consumer.PushNotification.SendPushNotification do

  alias Playdays.Repo
  alias Playdays.Services.PushNotification.SendPush

  def call(%{type: "new_chat_message", chatroom: chatroom, chat_participation: chat_participation, text_content: text_content}) do

    case chatroom.is_group_chat do
      true -> title = "#{chatroom.name}"
      false -> title = "New Message"
    end
    message = "#{chat_participation.consumer.name}:\n #{text_content}"
    chatroom.chat_participations
    |> Enum.reject(&(&1.id == chat_participation.id))
    |> Enum.flat_map(&(&1.consumer.devices))
    |> send_push_notification(%{title: title, message: message})
  end

  def call(%{type: "joined_trial_class", session: session}) do
    title = "Trial Class Approved"
    message = "Your trial class was approved."
    session.consumer.devices
    |> send_push_notification(%{title: title, message: message})
  end

  def call(%{type: "rejected_trial_class", session: session}) do
    title = "Trial Class Rejected"
    message = "Your trial class was rejected."
    session.consumer.devices
    |> send_push_notification(%{title: title, message: message})
  end

  def call(%{type: "new_friend_request", requestee: requestee, requester: requester}) do
    title = "New Friend Request"
    message = "#{requester.name} just send you a friend request."
    requestee.devices
    |> send_push_notification(%{title: title, message: message})
  end

  def call(%{type: "accepted_friend_request", requestee: requestee, requester: requester }) do
    title = "Friend Request Accepted"
    message = "#{requestee.name} just accept your friend request."
    requester.devices
    |> send_push_notification(%{title: title, message: message})
  end

  def call(%{type: "private_event_invitation", host: host, private_event_invitations: private_event_invitations}) do
    title = "New Private Event Invitation"
    message = "#{host.name} just send you a invitation."
    private_event_invitations
    |> Enum.flat_map(&(&1.consumer.devices))
    |> send_push_notification(%{title: title, message: message})
  end

  def call(%{type: "accepted_private_event_invitation", host: host, private_event_invitation: private_event_invitation}) do
    title = "Evnet Invitation Accepted"
    message = "#{private_event_invitation.consumer.name} joined your event."
    host.devices
    |> send_push_notification(%{title: title, message: message})
  end


  defp send_push_notification(devices, %{title: title, message: message}) do
    devices
    |> Enum.filter(&(&1.device_token != nil))
    |> Enum.each(fn(device) ->
      SendPush.call(%{device: device, title: title, message: message, data: %{}})
    end)
  end
end
