# Seed the RottenPotatoes DB with some singular_event.
singular_events = [
  {:singular_event => 'Movie-Screeing', :name => 'Test',
    :date => '16-Apr-1988'},
    {:singular_event => 'Movie-Screeing-2', :name => 'Test-1',
    :date => '16-Apr-1988'},
]

singular_events.each do |singular_event|
  Singular_Event.create!(singular_event)
end
