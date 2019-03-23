# Event Manager

This project was mostly a walkthrough through the process of parsing through a local CSV with Ruby. This project is part of The Odin Project's curriculum.

**Iteration #1: Clean Phone Numbers**
>We were asked to clean up the phone numbers by removing entries with too many or too few digits, and generally cleaning it up.

For this, I created a new method called `clean_phone_numbers`. Since some raw numbers were entered with dashes and some weren't, I extracted only the digits from the entries with `scan`. Then I used simple `if` logic to identify which numbers are valid and which are invalid. I also included a case to remove the `1` from the phone number if the number was more than 10 digits, but started with a 1, since it's the US leading number for phone numbers.


**Iteration #2: Time Targeting**
>Using the registration date and time we want to find out what the peak registration hours are.

This taught me a whole lot about working with DateTime objects in Ruby. I started by creating a method called `rubified_date` which basically translates the format of the date in the spreadsheet to a Ruby DateTime object. In the spreadsheet, dates were entered like `11/12/08 10:47` which can't be worked with directly. Then, lower in my script, I passed this method to the `registration_date` variable I created to hold each date.

Then I created `most_freq_reg_hours` and passed in the `registration_date` variable. I wanted to create an array to hold just the hours that entries were submitted, so I created an empty array named `reg_times` and then added just the hour to the array.

Once I had just the hours in their own array, I created a hash that tracks how many times per hour an entry was submitted. Then, in my `freq` variable, I identify which key-value pair has the highest value. I know a key-value pair will always return an array of two items, so I grab the first item to `puts` the hour and then I grab the `value` to `puts` the number of occurrences.

**Iteration #3: Day of the Week Targeting**	
>Using the registration date, we want to find out what day is most popular with registration.

For this, I took a similar approach to time targeting. I created an empty array called `dates_arr` in the `contents.each` loop and I created an array of pure DateTime objects. I passed the `dates_arr` into my new method called `most_freq_reg_dates`. 

Then I created a hash consisting of days of the week as keys and 0 as their values. I was hoping there was an easy `DateTime` method to get the day of the week, but I found some documentation saying you can use `date.monday?` to return true or false for each case and I decided to go with that. Inside of my numerator, I used `if` logic to identify which day of the week it was, and if it returned `true`, it added `1` to the value of the matching key. This left me with a hash of days and a number for how many registrations were submitted on that day. 

Finally, similarly to the second iteration, I used the variable `freq` to pick the key with the highest value and `puts`ed it the same way. 

As for the future of this exercise, I'd like to revisit what happens if there are two matching highest keys, and what the output would look like and how it would effect the `puts` statement variables I decided to use. I will revisit.