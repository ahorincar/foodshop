class Ingredient < ApplicationRecord
  validates :name, :shopping_list_id, presence: true
  validates :quantity, presence: true, unless: "metric.blank?"
  validates :quantity, numericality: true, allow_nil: true

  scope :sorted, -> { order(:updated_at) }

  belongs_to :shopping_list

  # This is the expected CSS selector for an ingredient element.
  # The app with assume that any element with this class is an ingredient.
  INGREDIENT_CSS_CLASS = ".ingredients-list__item"

  def self.extract_ingredients_from_url(url)
    response = get_request_response(url)

    if response
      ingredient_elements = extract_ingredients_from_html(response.body)
      shopping_list = ShoppingList.get_or_create_first

      ingredient_elements.each do |element|
        # Get relevant information from the ingredient string.
        quantity, metric, name = self.preprocess_ingredient_text(element.text)
        Ingredient.create(name: name, quantity: quantity, metric: metric, shopping_list: shopping_list)
      end
      return true
    end
    false
  end

  def self.extract_ingredients_from_html(html)
    document = Nokogiri::HTML(html)
    # Get the elements using the ingredient CSS class.
    document.css(INGREDIENT_CSS_CLASS)
  end

  def self.preprocess_ingredient_text(text)
    # Matches a text that contains the string tbsp or tsp.
    # E.g. "Half tbsp of sugar", "3 tsp vanilla extract".
    tbsp_regex = /(.*)\s+(tbsp|tsp)\s+([\w\s\-]*)/i
    # Matches a text that contains the string g, kg, l or ml.
    # E.g. "1 l milk".
    weight_regex = /(\d+)(g|kg|l|ml)\s+([\w\s\-]*)/i
    # Matches string beginning with a number.
    # E.g. "4 oranges".
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

private
    def self.get_request_response(url_string)
      url = URI.parse(url_string)

      if url.host and url.port
        req = Net::HTTP::Get.new(url.to_s)
        response = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') do |http|
          # Get the recipe from the given URL.
          http.request(req)
        end

        if response.kind_of? Net::HTTPSuccess
          return response
        end
      end

      return nil
    end
end
