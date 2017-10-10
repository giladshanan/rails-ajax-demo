class KittensController < ApplicationController
  def index
    @kittens = Kitten.all
  end

  def new
  end

  def create
    @kitten = Kitten.new(kitten_params)
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
    @kitten = Kitten.find(params[:id])
    render js: "alert('Meet #{@kitten.name}, a #{@kitten.color} kitten who #{@kitten.quirk}.')"
  end

  private

  def kitten_params
     params.require(:kitten).permit(:name, :color, :quirk)
  end
end
