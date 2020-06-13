require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(8)
  end

  def score
    @word = params[:userWord]
    @letters = params[:letters].split
    win = true
    @message = ''
    # binding.pry

    # Check if word can be built with grid
    # Sorry but TEST can't be built out of GRID
    unless check_against_grid(@word, @letters)
      win = false
      @message = "Sorry but <strong>#{@word}</strong> can't be built out of #{@letters}"
    end

    # Check if word is an english workd
    if !check_against_dictionary(@word) && win
      win = false
      # Sorry but TEST does not seem to be a valid English word
      @message = "Sorry but <strong>#{@word}</strong> does not seem to be a valid English word"
    end

    # BLACK Congratulations! BLACK TEST is a valid English word!
    @message = "<strong>Congratulations!</strong> #{@word} is a valid English word!" if win
    # binding.pry
  end
end

private

def generate_grid(grid_size)
  (0...grid_size).map { ('A'..'Z').to_a.sample }
end

def check_against_dictionary(attempt)
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  dict_response_json = open(url).read
  dict_response = JSON.parse(dict_response_json)
  dict_response["found"]
  # ? message = "Well done!" : message = "not an english word"
  # { success: dict_response["found"], message: message }
end

def check_against_grid(attempt, grid)
  hash_grid = hashizator(grid)
  success = true
  attempt.upcase.chars.each do |char|
    if (hash_grid[char] -= 1).negative?
      success = false
      break
    end
  end
  success
end

def hashizator(array)
  # Creates a hash from an array, with value the number of occurences of each
  # item
  hash_grid = Hash.new(0)
  array.each { |char| hash_grid[char] += 1 }
  hash_grid
end
