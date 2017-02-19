require 'net/http'
require 'nokogiri'

class Ingredient < ApplicationRecord
  validates_presence_of :name, :shopping_list_id
  validates :quantity, presence: true, unless: "metric.blank?"
  belongs_to :shopping_list

  INGREDIENT_CSS_CLASS = ".ingredients-list__item"

  def self.extract_ingredients_from_url(url)
    response = get_request_response("http://www.bbcgoodfood.com/recipes/salted-caramel-biscuit-bars")

    if response
      # ingredients_list = extract_ingredients_list_from_body(page_body)
      document = Nokogiri::HTML(response.body)
      ingredient_elements = document.css(INGREDIENT_CSS_CLASS)

      ingredient_elements.each do |element|
        ingredient_hash = self.preprocess_ingredient_text(element.text)
        # Ingredient.create(ingredient_hash)
      end
    else
      return nil
    end
    #
    # for ingredient in ingredients_list
    #   ingredient_params = preprocess_ingredient(ingredient)
    #   #set shopping list id
    #   Ingredient.create(ingredient_params)
    # end
  end

  private
    def self.get_request_response(url_string)
      url = URI.parse(url_string)

      if url.host and url.port
        req = Net::HTTP::Get.new(url.to_s)
        response = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }

        if response.kind_of? Net::HTTPSuccess
          return response
        end
      end

      return nil
    end

    def self.preprocess_ingredient_text(text)
      p text
      # extracts quantity and metric and name
      # creates a hash with quantity, metric and name
    end
end
