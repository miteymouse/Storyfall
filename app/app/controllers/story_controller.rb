class StoryController < ApplicationController

  before_action :is_authenticated?

  def all_story
    @stories = Story.all.entries
  end


  def new
    render :create_story
  end


  def show
    @story = Story.find_by({:index => params[:code]})
  end


  def create_story
    if params[:story][:title].blank? || params[:story][:content].blank?
      flash.now[:notice] = "Please enter a title and message"
      render :create_story
    else
      story = Story.new
      story.title = params[:story][:title]
      story.index = Story.count + 1

      message = Message.new
      message.content = params[:story][:content]
      story.messages << message



      message.save
      story.save

      flash.now[:notice] = "Your Story has been created"
      redirect_to :controller => 'story', :action => 'show', :code => story.index
    end
  end


  def next_title
    rand = rand(Story.count) + 1
    @story = Story.find_by({:index => rand})
    # render :story
    redirect_to :controller => 'story', :action => 'show', :code => @story.index
  end


  def contribute
    story = Story.find_by({:index => params[:message][:index]})

    message = Message.new
    message.content = params[:message][:content]
    story.messages << message

    message.save
    story.save

    flash.now[:notice] = "Your contribution has been submitted"
    redirect_to :controller => 'story', :action => 'show', :code => story.index
  end



end



