data "http" "webui" {
  # Get the CLIENT ID
  url    = "https://b6f1c02be2074a299622430b2c40c19b-dot-us-central1.composer.googleusercontent.com"
  method = "GET"
}

output "url" {
    value = data.http.webui.response_headers
}