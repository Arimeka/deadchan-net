# Be sure to restart your server when you modify this file.

DeadchanNet::Application.config.session_store :redis_store, SESSION_STORE["redis"].symbolize_keys!
