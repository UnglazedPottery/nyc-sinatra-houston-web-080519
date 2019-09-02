class FiguresController < ApplicationController

  get '/figures' do
    @figures = Figure.all
    erb :'figures/index'
  end

  get '/figures/new' do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'figures/new'
  end

  post '/figures' do
    @figure = Figure.create(name: params[:figure][:name])
    if !params[:title][:name].empty?
      @figure.titles << Title.create(params[:title])
    end
    #add the checked items to figure
    titles = params[:figure][:title_ids]
    if titles
      titles.each do |id|
        @figure.titles << Title.find(id)
      end
    end

    if !params[:landmark][:name].empty?
      @figure.landmarks << Landmark.create(params[:landmark])
    end
    landmarks = params[:figure][:landmark_ids]
    if landmarks
      landmarks.each do |id|
        @figure.landmarks << Landmark.find(id)
      end
    end
    @figure.save
    redirect to "/figures/#{@figure.id}"
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    erb :'figures/show'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    @landmarks = Landmark.all
    @titles = Title.all
    erb :'figures/edit'
  end

  patch '/figures/:id' do
    title = params[:title]
    title_ids = params[:figure][:title_ids]
    landmark = params[:landmark]
    landmark_ids = params[:figure][:landmark_ids]
    #change figure's name
    @figure = Figure.find(params[:id])
    @figure.name = params[:figure][:name]
    #if items are checked
    @figure.titles.clear
    if title_ids
      title_ids.each do |id|
        @figure.titles << Title.find(id)
      end
    end
    if !title[:name].empty?
      @figure.titles << Title.create(name: title[:name])
    end
    @figure.landmarks.clear
    if landmark_ids
      landmark_ids.each do |id|
        @figure.landmarks << Landmark.find(id)
      end
    end
    if !landmark[:name].empty?
      @figure.landmarks << Landmark.create(name: landmark[:name])
    end
    @figure.save
    redirect to "/figures/#{@figure.id}"
  end

end
