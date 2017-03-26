class Api::V1::ApiController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    render json: {
      status: 'error',
      message: 'Not found.'
    }, status: 404
  end
end
