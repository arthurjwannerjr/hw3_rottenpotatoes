# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
#puts page.body
  index_e1 = page.body.index(e1)
  #puts "index_e1=" + index_e1.to_s
  index_e2 = page.body.index(e2)
  #puts "index_e2=" + index_e2.to_s
  index_e1.should_not == nil
  index_e2.should_not == nil
  index_e1.should < index_e2
  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(",")
  if uncheck == "un"
    ratings.each do |rating|
      step "I uncheck" + ' "ratings_' + rating + '"'
    end
  else
    ratings.each do |rating|
      step "I check" + ' "ratings_' + rating + '"'
    end
  end
end

Then /I should see all of the movies/ do
  db_rows = Movie.all.count
  #puts "db_rows=" + db_rows.to_s
  html_rows = page.body.scan('<tr>').count - 1 # -1 for thead
  #puts "html_rows=" + html_rows.to_s
  db_rows.should == html_rows
end

Then /I should see no movies/ do
  html_rows = page.body.scan('<tr>').count - 1 # -1 for thead
  #puts "html_rows=" + html_rows.to_s
  html_rows.should == 0
end
