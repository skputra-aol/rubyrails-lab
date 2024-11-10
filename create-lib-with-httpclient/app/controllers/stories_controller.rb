class StoriesController < ApplicationController
  def top
    @stories = client.topstory(params[:id])
    render json: {status: {code: 200, message: "Success"}, data: @stories}
  end

  def tops
    @start = (params[:pageno] || 0).to_i
    @per_page = (params[:perpage] || 10).to_i
    @per_page = [@per_page, 20].min # max 20 per page
  
    @stories = client.topstories(@start, @per_page)
    render json: {status: {code: 200, message: "Success"}, data: @stories}
  end

  def topall
    @stories = client.topstoriesall()

    render json: {status: {code: 200, message: "Success"}, data: @stories}
  end

end
