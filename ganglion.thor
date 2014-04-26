class Ganglion < Thor
  desc "export [DASHBOARD_URL]", "Exports ganglia dashboard with specified params"
  def export(dashboard_url = "http://localhost:5000/dashboard")
    system "phantomjs scripts/download.js #{dashboard_url}"
  end
end