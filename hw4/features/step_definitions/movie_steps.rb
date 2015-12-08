#This is a declarative step for populating the DB with Movies

Given(/^the following movies exist:$/) do |movies_table|
  movies_table.hashes.each do |movie|
    #debugger
    # movies_table is an in memory representacion of the table
    # in the .feature file
    # Create the movies in the test_db. They are used in scenarios  
    Movie.create(movie)
  end
end

Then(/^the director of "(.*?)" should be "(.*?)"$/) do |movie, director|
     expect(page).to have_content(movie)
     expect(page).to have_content(director)
end

When /^I follow“(.*)”$/ do |sort_choice|
  if sort_choice=="Movie Title"
    click_link("title_header")
  elsif sort_choice=="Release Date"
      click_link("release_date_header")
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  expect page.body =~ /#{e1}.+#{e2}/m
end

Then /I should see all the movies/ do 
  # Make sure that all the movies in the app are visible in the table
  page.all('table#movies tbody tr', :count => 10)
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  if uncheck == "un"
    rating_list.split(', ').each {|x| step %{I uncheck "ratings_#{x}"}}
  else
    rating_list.split(', ').each {|x| step %{I check "ratings_#{x}"}}
  end

end