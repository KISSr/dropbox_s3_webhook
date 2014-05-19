class ApplicationController < ActionController::Base
  def authorize_dropbox
    unless valid_signature?
      render nothing: true, status: 401
    end
  end

  def valid_signature?
    request.headers['X-Dropbox-Signature'] == sign(request.body.read)
  end

  def sign(data)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), ENV['DROPBOX_SECRET'], data)
  end
end
