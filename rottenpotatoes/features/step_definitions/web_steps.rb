
require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

#module WithinHelpers
#  def with_scope(locator)
#    locator ? within(*selector_for(locator)) { yield } : yield
#  end
#end
#World(WithinHelpers)

# Single-line step scoper
#When /^(.*) within (.*[^:])$/ do |step, parent|
#  with_scope(parent) { When step }
#end

# Multi-line step scoper
#When /^(.*) within (.*[^:]):$/ do |step, parent, table_or_string|
#  with_scope(parent) { When "#{step}:", table_or_string }
#end

#Background
Given(/^the following movies exist:$/) do |table|
  table.hashes.map {|row|
    #Save each row in table
    Movie.create! row
  }
  
end

#Scenario 1
When(/^I go to the edit page for "(.*?)"$/) do |arg1|
  id = Movie.where(title: arg1).first.id
  visit path_to('edit movie page for ' + id.to_s)
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |arg1, arg2|
  field = "movie[" + arg1.downcase + "]"
  fill_in(field, :with => arg2)
end

When(/^I press "(.*?)"$/) do |arg1|
  click_button(arg1)
end

Then(/^the director of "(.*?)" should be "(.*?)"$/) do |arg1, arg2|
  director = Movie.where(title: arg1).first.director
  expect(director).to match(arg2)
end

#Scenario 2
Given(/^I am on the details page for "(.*?)"$/) do |arg1|
  id = Movie.where(title: arg1).first.id
  visit path_to('details page for ' + id.to_s)
end

When(/^I follow "(.*?)"$/) do |arg1|
  click_link(arg1)
end

Then(/^I should be on the Similar Movies page for "(.*?)"$/) do |arg1|
  id = Movie.where(title: arg1).first.id
  current_path = URI.parse(current_url).path
  
  if current_path.respond_to? :should
    current_path.should == path_to('similar movies page for ' + id.to_s)
  else
    assert_equal path_to('similar movies page for ' + id.to_s), current_path
  end
end

Then(/^I should see "(.*?)"$/) do |arg1|
  if page.respond_to? :should
    page.should have_content(arg1)
  else
    assert page.has_content?(arg1)
  end
end

Then(/^I should not see "(.*?)"$/) do |arg1|
  if page.respond_to? :should
    page.should have_no_content(arg1)
  else
    assert page.has_no_content?(arg1)
  end
end

#Scenario 3
Then(/^I should be on the home page$/) do
  current_path = URI.parse(current_url).path
  
  if current_path.respond_to? :should
    current_path.should == path_to('home page')
  else
    assert_equal path_to('home page'), current_path
  end
end