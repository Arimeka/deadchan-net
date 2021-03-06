class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

  expose(:boards) { Board.published.asc(:placement_index) }
  expose(:entry)  { nil }

  protected

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  private

  # Check slug
  #
  # / or .html not allowed
  #
  # @return [Boolean]
  def bad_slug?
    request.env["REQUEST_PATH"] =~ /.+\/$/ || params[:format].present?
  end

  # Redirect to good slug
  #
  # 301 - Moved Permanently
  def redirect_to_good_slug
    redirect_to params.merge({
      id: params[:id],
      format: nil,
      status: :moved_permanently
    })
  end
end
