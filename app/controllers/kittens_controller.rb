class KittensController < ApplicationController
  def index
    @kittens = Kitten.all
  end

  def new
  end

  def create
    @kitten = Kitten.new(params[:kitten])
    respond_to do |format|
      if @kitten.save
        format.html { redirect_to @kitten, notice: 'Kitten was successfully created.' }
        format.js
        format.json { render json: @kitten, status: :created, location: @kitten }
      else
        format.html { render action: "new" }
        format.json { render json: @kitten.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    render js: "alert('The kitten id number is: #{params[:id]}')"
  end
end
