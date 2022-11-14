require "open-uri"

class GamesController < ApplicationController
  LETTERS = ('A'..'Z').to_a
  def new
    @letters = LETTERS.sample(10)
  end

  def score
    # 1. Get the input word & grid
    @user_word = params[:word]
    @letters = params[:letters].split(" ")

    # 2. Check if word contains only letters in the grid
    @valid_grid = included?(@user_word, @letters)

    # 3. Validate if it is an english word (using the api)
    @valid_english = english_word?(@user_word)

    # 4- Put a message and update score
    if @valid_grid && @valid_english
      @message = "Congratulations! #{@user_word} is a valid English word!"
    elsif !@valid_grid && @valid_english
      @message = "Sorry but #{@user_word} can't be build out of the #{@letters}."
    else
      @message = "Sorry but #{@user_word} does not seem to be a valid Engish word.."
    end
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
