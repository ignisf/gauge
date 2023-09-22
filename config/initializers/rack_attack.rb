require "net/http"

Net::HTTP.get(URI("https://lists.fissionrelays.net/tor/exits.txt")).split("\n").each do |tor_exit|
  Rack::Attack.blocklist_ip(tor_exit)
end
