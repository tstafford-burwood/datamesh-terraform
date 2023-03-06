data "http" "webui" {
    url = "https://xfa0d78138fc714fcp-tp.appspot.com"
    method = "GET"
}

output "client_id" {
  value = trimprefix(regex( "[A-Za-z0-9-]*\\.apps\\.googleusercontent\\.com", data.http.webui.response_headers["X-Auto-Login"]), "253D" )
}
