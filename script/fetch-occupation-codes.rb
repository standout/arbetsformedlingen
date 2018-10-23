#!/usr/bin/env ruby

require "json"
require "net/http"
require "nokogiri"

# Data retrieved via this script was used to populate third column of
# data/occupation-codes.csv

API_HOST = "https://www.arbetsformedlingen.se"

CATEGORIES = {
  1070 => "Administration, ekonomi, juridik",
  1072 => "Bygg och anläggning",
  1065 => "Data/IT",
  1068 => "Försäljning, inköp, marknadsföring",
  1077 => "Hantverksyrken",
  1071 => "Hotell, restaurang, storhushåll",
  1078 => "Hälso- och sjukvård",
  1076 => "Industriell tillverkning",
  1060 => "Installation, drift, underhåll",
  1073 => "Kropps- och skönhetsvård",
  1061 => "Kultur, media, design",
  1075 => "Militärt arbete",
  1079 => "Naturbruk",
  1067 => "Naturvetenskapligt arbete",
  1064 => "Pedagogiskt arbete",
  1066 => "Sanering och renhållning",
  1063 => "Socialt arbete",
  1062 => "Säkerhetsarbete",
  1069 => "Tekniskt arbete",
  1074 => "Transport"
}

def fetch_categories_list
  uri = URI(API_HOST + "/For-arbetssokande/Valj-yrke/Hitta-yrken.html")

  request = Net::HTTP::Get.new(uri)

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  response = http.request(request)

  doc = Nokogiri::HTML(response.body)

  # TODO: Port this JavaScript to nokogiri xpath if this script is needed again
  # Array.from(
  #   document.querySelectorAll('ul[formarrayname="yrkesomraden"] li label')
  # ).map(labelEl => {
  #   return `${labelEl.htmlFor.replace(/^omrade_/, '')} ${labelEl.innerText}`
  # }).join('\n')
end

def fetch_category_professions_json(category_id)
  uri = URI(API_HOST + "/rest/yrkesvagledning/rest/vagledning/yrken/yrkessok")

  request = Net::HTTP::Post.new(uri).tap do |req|
    req.add_field("Content-Type", "application/json")
    req.body = JSON.dump(
      efterGymn2less: false,
      efterGymn2more: false,
      ejGymnasie: false,
      gymnasie: false,
      sok: "",
      yrkesomraden: "#{category_id}, "
    )
  end

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  response = http.request(request)

  JSON.parse(response.body)
end

occupations = CATEGORIES.flat_map do |category_id, category_name|
  professions = fetch_category_professions_json(category_id)

  professions.map do |profession|
    id = profession.fetch("id")
    name = profession.fetch("namn")

    [id, name, category_id, category_name].map(&JSON.method(:dump)).join(",")
  end
end

puts occupations
