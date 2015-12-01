require 'rails_helper'

describe 'surviving api', type: :request do
    before :example do
      host! 'api.example.com'
    end

  it 'returns list of all zombies' do
    get '/zombies'

    expect(response.status).to eq 200
    expect(response.body).to_not be_empty
  end

  context 'listing zombies by id' do
    it 'returns a zombie with that specific id' do
      zombie = Zombie.create!( name: 'John', weapon: 'axe')
      get "/zombies/#{zombie.id}"
      expect(response.status).to eq 200

      zombie_response = json(response.body)
      expect(zombie_response[:name]).to eq zombie.name
    end
  end

  context 'filtering zombies by weapon' do
    it 'returns a zombie with that specific weapon' do
      paul = Zombie.create!( name: 'Paul', weapon: 'axe')
      joanna = Zombie.create!( name: 'Joanna', weapon: 'shotgun')

      get "/zombies?weapon=axe"
      expect(response.status).to eq 200

      zombies = json(response.body).collect { |z| z[:name]}

      expect(zombies).to include 'Paul'
      expect(zombies).to_not include 'Joanna'
    end
  end


end
