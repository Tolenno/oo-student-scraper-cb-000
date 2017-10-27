require 'open-uri'
require 'pry'

class Scraper

  # URL: fixtures/student-site/index.html
  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))

    students = []
    index_page.css(".student-card").each do |card|
      student_name = card.css(".student-name").text
      student_location = card.css(".student-location").text
      student_profile_url = card.css("a")[0]["href"]

      students << {name: student_name, location: student_location, profile_url: student_profile_url}
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student_profile_page = Nokogiri::HTML(open(profile_url))
    student_profile = {}

    student_profile_page.css(".social-icon-container a").each do |element|
      case
        when element["href"].include?("twitter")
          student_profile[:twitter] = element["href"]
        when element["href"].include?("linkedin")
          student_profile[:linkedin] = element["href"]
        when element["href"].include?("github")
          student_profile[:github] = element["href"]
        when (element["href"] =~ (/twitter|linkedin|github/)) == nil
          student_profile[:blog] = element["href"]
      end
    end
    student_profile[:profile_quote] = student_profile_page.css(".profile-quote").text
    student_profile[:bio] = student_profile_page.css(".description-holder p").text
    student_profile
  end
end
