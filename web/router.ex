defmodule Playdays.Router do
  use Playdays.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated_admin do
    plug Playdays.Plugs.Api.TokenAuth, model: :admin
  end

  pipeline :authenticated_consumer do
    #plug Playdays.Plugs.Api.AuthenticatedConsumer
    plug Playdays.Plugs.Api.AuthenticatedMember
  end

  scope "/", Playdays do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Playdays.Api, as: :api do
    pipe_through :api

    scope "v1", V1, as: :v1 do

      scope "/admin", Admin, as: :admin do
        post "/auth_tokens", AuthTokenController, :create

        pipe_through :authenticated_admin
        delete "/auth_tokens", AuthTokenController, :destroy

        resources "/admins", AdminController, only: [:index, :show, :create, :update, :delete]
        resources "/consumers", ConsumerController, only: [:index]
        resources "/comments", CommentController, only: [:index, :delete]
        resources "/categories", CategoryController, only: [:index, :show, :create, :update]
        resources "/tags", TagController, only: [:index, :show, :create, :update]
        resources "/event_tags", EventTagController, only: [:index, :show, :create, :update]
        resources "/places", PlaceController, only: [:index, :show, :create, :update]
        resources "/events", EventController, only: [:index, :show, :create, :update]
        resources "/trial_classes", TrialClassController, only: [:index, :show, :create, :update]
        resources "/regions", RegionController, only: [:index, :show, :create, :update]
        resources "/districts", DistrictController, only: [:index, :show, :create, :update]
        resources "/s3", S3Controller, only: [:create]
        # post "/s3", S3Controller, :create
        get "/sessions", SessionController, :index
        put "/sessions", SessionController, :update
        delete "/image", S3Controller, :destroy
      end

      scope "/consumer", Consumer, as: :consumer do
        resources "/members", MemberController
        post "/auth", MemberController, :create
        post "/auth/update", MemberController, :update
        resources "/login", LoginController
        post "/auth/login", LoginController, :login
        post "/auth/logout", LoginController, :logout
        post "/verify_access_tokens", VerifyAccessTokenController, :create
        post "/registrations", RegistrationController, :create

        resources "/districts", DistrictController, only: [:index]
        resources "/categories", CategoryController, only: [:index]
        get "/tags", TagController, :index
        resources "/events", EventController, only: [:index, :show]
        resources "/places", PlaceController, only: [:index, :show]
        resources "/regions", RegionController, only: [:index]
        resources "/trial_classes", TrialClassController, only: [:index, :show]
        resources "/chat_participations", ChatParticipationController, only: [:show, :update, :create]
        resources "/users", UserController, only: [:index]
        get "/comments", CommentController, :index

        pipe_through :authenticated_consumer
        get "/me", MeController, :show
        put "/me", MeController, :update

        resources "/friends", FriendController, only: [:index, :show]
        resources "/friend_requests", FriendRequestController, only: [:index, :create, :update]
        resources "/chatrooms", ChatroomController, only: [:index,:create, :show, :update]
        resources "/chat_messages", ChatMessageController, only: [:create]
        resources "/sessions", SessionController, only: [:index, :create]
        post "/share_session", SessionController, :share_with_friends
        post "/comments", CommentController, :create
        resources "/reminders", ReminderController, only: [:index]
        put "/reminders/:id/archive", ReminderController, :archive
        put "/reminders/:id/mark_read", ReminderController, :mark_read
        resources "/private_events", PrivateEventController, only: [:index, :create, :show]
        resources "/private_event_invitations", PrivateEventInvitationController, only: [:update]

        put "/devices/:uuid", DeviceController, :update
      end
    end
  end


  # Other scopes may use custom stacks.
  # scope "/api", Playdays do
  #   pipe_through :api
  # end
end
