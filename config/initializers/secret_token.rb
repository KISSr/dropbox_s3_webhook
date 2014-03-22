# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
DropboxS3Webhook::Application.config.secret_key_base = '83f41e720342aac7ede1ae998264583dca909982dde1e8078bd65d43832ebc78fa6c554de6266037d32aba8636ead01d9ce1596110e5b33323bd17b63a3089a8'
