require 'rubygems'
require 'selenium-webdriver'
require "test/unit/assertions"
require 'rspec'
require 'csv'
require './fast-selenium'
# require 'rspec/exceptions'
include Test::Unit::Assertions

include RSpec::Matchers

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
@driver = Selenium::WebDriver.for :chrome, options: options


# @driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(timeout: 8)


# GITHUB_SET_UP_YOUR_TEST = "https://github.com/srebs/bs_docs_revamp_content/blob/master/automate/set-up-your-test/"

# GITHUB_PAGES = ["select-browsers-and-devices.md", "allow-all-cookies.md"]

BSDOCS_AUTOMATE_SELENIUM_LINK = "http://bsuser:bs@Super.S3CRET!@bsdocs2.wpengine.com"
BSDOCS_PAGES = ["/docs/alerts-test/", "/docs/dscsc/"]

FILENAME = "Javascript.csv"

col_data = []
CSV.foreach(FILENAME) {|row| 
	if row[6] != "URL" 
		col_data << row[6]
	end
	}
#puts col_data

# GITHUB_BODY = "readme"
# BSDOCS_BODY = "article.main-content div.row"

github_osx_text = "<OS X & Linux / Windows selector> OS X & Linux ./BrowserStackLocal --key ekKTGeFduvsvXvXx96xG Windows BrowserStackLocal.exe --key ekKTGeFduvsvXvXx96xG"
bsdocs_osx_text = "OS X & Linux Windows ./BrowserStackLocal --key ekKTGeFduvsvXvXx96xG BrowserStackLocal.exe --key ekKTGeFduvsvXvXx96xG"
feedback_text = "Was this page helpful? Yes No"

@driver.manage.window.maximize

def switch_to_window(handle)
    @driver.switch_to.window handle
end

def new_tab(action="open")            
    @driver.execute_script("window.#{action}()")
    # retry_count = 2
    begin
      switch_to_window(@driver.window_handles.last)
      @driver.get 'http://www.google.com'
      sleep 5
	  element = @driver.find(:name, 'q')
	  element.click
	  e = element.send_keys [:control, 'v']
	  e.text
    # rescue
    #   # logger.info "[Window Handles]"
    #   retry_count -= 1
    #   retry if retry_count > 0
    #   switch_to_window(@driver.window_handles.first)
    end
end

def find(tagname, locator)
	
	    # require 'pry'; binding.pry
	    # puts "#{tagname} \t #{locator}"
	begin
		wait = Selenium::WebDriver::Wait.new(timeout: 8)
	    wait.until { @driver.find_element(tagname, locator).displayed? }
		return @driver.find_element(tagname, locator)
	rescue Exception => e
  		return false
  		puts e.message
	end
end

def find_multiple(tagname, locator)
	
	    # wait = Selenium::WebDriver::Wait.new(timeout: 8)
	    # wait.until { @driver.find_elements(tagname, locator)[0].displayed? }
    begin
	    wait = Selenium::WebDriver::Wait.new(timeout: 8)
	    wait.until { @driver.find_elements(tagname, locator)[0].displayed? }
		elements = @driver.find_elements(tagname, locator)
		return elements
	rescue Exception => e
  		return false
	end
end

len = col_data.size

blank_docs = []
incorrect_urls_or_url_not_created = []
for i in 0...(len) do
	puts "----------------------------------------------------"
	@driver.get BSDOCS_AUTOMATE_SELENIUM_LINK + col_data[i]
	puts "#{i+1} URL: #{col_data[i]}"
	h1 = find_multiple(:tag_name, 'h1')
	if h1
		no_of_h1_tags = h1.size
		if no_of_h1_tags > 1
		  puts "Multiple H1 tags present"
		end
	else
		puts "H1 tag not present"
		blank_docs << col_data[i]
		
	end
	incorrect_url = find_multiple(:class, 'section-404__heading')
	if incorrect_url
		puts "Incorrect URL or URL not created: #{col_data[i]}"
		incorrect_urls_or_url_not_created << col_data[i]
	end

	puts "----------------------------------------------------"
end


puts "Count of blank docs: #{blank_docs.size}"
puts "Blank docs: "

for i in 0...(blank_docs.size)
 puts "#{i+1} URL: #{blank_docs[i]}"
end

puts "*************************"
puts "Count of incorrect URLs: #{incorrect_urls_or_url_not_created.size}"
puts "Incorrect URLs of URL not created: "

for i in 0...(incorrect_urls_or_url_not_created.size)
	puts "#{i+1} URL: #{incorrect_urls_or_url_not_created[i]}"
end

# len = GITHUB_PAGES.size
# for i in 0...(len) do
# 	driver.get GITHUB_SET_UP_YOUR_TEST+GITHUB_PAGES[i]
# 	begin
# 		# sleep 3
# 		element = driver.find_element(:id, GITHUB_BODY)
# 		if !element.nil?
# 			element1 = element.text

# 			driver.get BSDOCS_AUTOMATE_SELENIUM_LINK+BSDOCS_PAGES[i]
# 			element = driver.find_element(:css, BSDOCS_BODY)
# 			wait.until{ element.displayed? }
# 			element2 = element.text
# 			e2 = element2

# 			if element1.include?(github_osx_text)
# 				element1 = element1.gsub(github_osx_text, "")
# 			end

# 			if element1.include?(feedback_text)
# 				element1 = element1.gsub(feedback_text, "")
# 			end

# 			if element2.include?(bsdocs_osx_text)
# 				e2 = element2.gsub(bsdocs_osx_text, "")
# 			end

# 		# begin
# 			assert_equal(e1, e2, "Content not correct")

# 			print driver.title
# 			a = element1.eql? element2
# 			if a
# 				print " ----- Content Correct"
# 			elsif a.nil?
# 				print " ----- Got Nil"
# 			else
# 				print " ----- Content Incorrect"
# 			end
# 		end

# 	rescue Exception => e
# 		puts "#{driver.title}: Empty Data"
# 	end

# end


	# puts "Content not correct" if !element1.should == element2
# assert_equal(element1, element2, "Content not correct")
# rescue Exception => e
# 	puts e.message
# end

# driver.find_element(:link_text, sign_in).click

# element = driver.find_element(:id, uname) 

# wait.until{ element.displayed? && element.enabled?}


# element.send_keys(email) 

# element = driver.find_element(:id, password) 

# wait.until{ element.displayed? && element.enabled?}
 
# element.send_keys(pwd) 

# element = driver.find_element(:id, submit).click

# # sleep(5)

# element = driver.find_element(:css, "a[title='Chirag Test']")

# wait.until{ element.displayed? && element.enabled?}

# element.click
# element = driver.find_element(:class, completed)
# txt = element.text
# puts "Completed"
@driver.quit