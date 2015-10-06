json.array! @talks do |talk|
  json.title talk.title
  json.abstract talk.abstract
  json.track_id talk.track_id
  json.track_name talk.track.name
  json.event_id talk.id
  json.event_type talk.event_type.name
end
