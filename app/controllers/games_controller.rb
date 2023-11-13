require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # generate a grid of 10 random letters
    @letters = []
    10.times do
      @letters.push(('a'..'z').to_a.sample)
    end
  end

  def score
    @guess = params[:word]
    @letters = params[:letters]
    @valid = valid_word?(@guess, @letters)
    @english = english_word?(@guess)
  end

  def valid_word?(guess, letters)
    # word can't be built out of the original grid
    guess.upcase.chars.all? { |char| letters.upcase.count(char) >= guess.upcase.chars.count(char) }
  end

  def english_word?(guess)
    # word is valid against the grid but not an english word
    url = "https://wagon-dictionary.herokuapp.com/#{guess}"
    word_serialized = URI.open(url).read
    result = JSON.parse(word_serialized)
    result['found']
  end
end
