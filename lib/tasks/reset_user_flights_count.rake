desc 'Counter cache for users has many flights'

task flights_counter: :environment do
  User.ids.each do |user_id|
    User.reset_counters(user_id, :flights)
    puts "User #{user_id} was updated"
  end
  puts "Flights counter was updated for all users"
end
