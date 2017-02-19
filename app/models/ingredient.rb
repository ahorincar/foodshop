require 'net/http'
require 'nokogiri'

class Ingredient < ApplicationRecord
  validates_presence_of :name, :shopping_list_id
  validates :quantity, presence: true, unless: "metric.blank?"
  validates :quantity, numericality: true, allow_nil: true

  belongs_to :shopping_list

  INGREDIENT_CSS_CLASS = ".ingredients-list__item"

  def self.extract_ingredients_from_url(url)
    response = get_request_response(url)

    if response
      document = Nokogiri::HTML(response.body)
      ingredient_elements = document.css(INGREDIENT_CSS_CLASS)
      shopping_list = ShoppingList.get_or_create_first

      ingredient_elements.each do |element|
        quantity, metric, name = self.preprocess_ingredient_text(element.text)
        self.create_or_update_ingredient(quantity, metric, name, shopping_list)
      end
    end
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
      tbsp_regex = /(.*)\s+(tbsp|tsp)\s+([\w\s\-]*)/i
      weight_regex = /(\d+)(g|kg|l|ml)\s+([\w\s\-]*)/i
      number_regex = /(\d+)\s+([\w\s\-]*)/i

      if match = text.match(tbsp_regex)
        quantity, metric, name = match.captures
      elsif match = text.match(weight_regex)
        quantity, metric, name = match.captures
      elsif match = text.match(number_regex)
        quantity, name = match.captures
      else
        name = text
      end

      return quantity, metric, name
    end

    def self.create_or_update_ingredient(quantity, metric, name, shopping_list)
      results = Ingredient.where(name: name)

      if results.empty?
        Ingredient.create(name: name, quantity: quantity, metric: metric, shopping_list: shopping_list)
      else
        results.first.update(name: name, quantity: quantity, metric: metric)
      end
    end
end
