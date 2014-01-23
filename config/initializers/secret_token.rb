# We have had lots of config issues with SECRET_TOKEN to avoid this mess we are moving it to redis
#  if you feel strongly that it does not belong there use ENV['SECRET_TOKEN']
#
Discourse::Application.config.secret_token = "a9271be7ea2cd66f3de95571f37145131a7252de66adbde2747dcb2de57ed706c05579e10412f8041d74500305af46938af1e5405c68ea149a0c723f19a54345"
