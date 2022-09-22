class ApplicationController < ActionController::API
  rescue_from(ActionController::BadRequest, with: :render_bad_request_response)

  def render_bad_request_response(error)
    render(json: { errors: [{ detail: "Bad request: #{error.message}" }] }, status: :bad_request)
  end
end
