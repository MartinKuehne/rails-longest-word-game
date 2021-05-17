require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @result = run_game(params[:answer])
  end

  private

  def dictionary_api(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    api_output = URI.open(url).read
    result = JSON.parse(api_output)
    result['found']
  end

  def check_characters(answer)
    letters = answer.upcase.chars
    letters.all? { |char| letters.count(char) <= params[:letters_array].count(char) }
  end

  def score_answer(answer)
    answer.length*answer.length
  end

  def run_game(answer)
    if dictionary_api(answer) && check_characters(answer)
      "Congratulations. #{answer} is a valid English word! Your score is #{score_answer(answer)}."
    elsif !dictionary_api(answer)
      "Sorry, but #{answer} doesn't seem to be an English word..."
    elsif !check_characters(answer)
      "Sorry, but #{answer} can't be built out of #{@letters.join("', '")}"
    end
  end
end
