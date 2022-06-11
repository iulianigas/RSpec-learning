class Tea 
  def flavour 
    :earl_gray
  end

  def temperature 
    205.0
  end
end

RSpec.configure do |config| 
  config.example_status_persistence_file_path = 'spec/examples.txt'
end

RSpec.describe Tea do 
  let(:tea) { Tea.new }

  it 'tastes like Earl Gray' do
    expect(tea.flavour).to be :earl_gray
  end

  it 'is hot' do 
    expect(tea.temperature).to be > 200.0
  end
end