class Api::V1::GoodsController < ApplicationController
  authorize_resource only: [:index]

  def index
    @goods = Good.all
  end
end
