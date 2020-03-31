module Populator
  module Stores

    def create_stores
      stores = {'Carnegie Mellon' => '4800 Forbes Avenue;15213', 'Convention Center' => '1000 Fort Duquesne Blvd;15222', 'Point State Park' => '101 Commonwealth Place;15222', 'Greenfield' => '3981 Beachwood Blvd;15217', 'Oakland' => '135 N Bellefield Ave;15260', 'Shadyside' => '5230 Centre Ave;15232', 'Squirrel Hill' => '5604 Solway St;15217'}
      all_stores = Array.new
      stores.each do |store|
        str = Store.new
        str.name = store[0]
        street, zip = store[1].split(';')
        str.street = street
        str.city = 'Pittsburgh'
        str.state = 'PA'
        str.zip = zip
        str.phone = rand(10 ** 10).to_s.rjust(10,'0')
        str.active = true
        str.save!
        all_stores << str
      end

      all_stores  # return the array of all store objects

    end
    
  end
end