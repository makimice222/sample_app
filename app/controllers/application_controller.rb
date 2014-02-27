class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  # CSRF脆弱性の対策のために、サインアウトさせる。
  def handle_unverified_request
    sign_out
    super
  end
end
