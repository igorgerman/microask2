class QuestionsController < ApplicationController
  def index
    @q = Question.ransack(params[:q])
    @questions = @q.result(:distinct => true).includes(:restaurant, :responses).page(params[:page])

    render("questions/index.html.erb")
  end

  def show
    @response = Response.new
    @question = Question.find(params[:id])

    @choice1 = 0
    @choice2 = 0

    @question.responses.each do |response|

       if response.selection == @question.option_1
       @choice1 = @choice1 + 1
       else
      @choice2 = @choice2 + 1

      end
    end

    render("questions/show.html.erb")
  end

  def new
    @question = Question.new
    @restaurants = current_user.restaurants
    render("questions/new.html.erb")
  end

  def create
    @question = Question.new

    @question.body = params[:body]
    @question.option_1 = params[:option_1]
    @question.option_2 = params[:option_2]
    @question.name = params[:name]
    @question.restaurant_id = params[:restaurant_id]

    save_status = @question.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/questions/new", "/create_question"
        redirect_to("/questions")
      else
        redirect_back(:fallback_location => "/", :notice => "Question created successfully.")
      end
    else
      render("questions/new.html.erb")
    end
  end

  def edit
    @question = Question.find(params[:id])

    render("questions/edit.html.erb")
  end

  def update
    @question = Question.find(params[:id])

    @question.body = params[:body]
    @question.option_1 = params[:option_1]
    @question.option_2 = params[:option_2]
    @question.name = params[:name]
    @question.restaurant_id = params[:restaurant_id]

    save_status = @question.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/questions/#{@question.id}/edit", "/update_question"
        redirect_to("/questions/#{@question.id}", :notice => "Question updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "Question updated successfully.")
      end
    else
      render("questions/edit.html.erb")
    end
  end

  def destroy
    @question = Question.find(params[:id])

    @question.destroy

    if URI(request.referer).path == "/questions/#{@question.id}"
      redirect_to("/", :notice => "Question deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Question deleted.")
    end
  end
end
