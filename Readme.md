# HTTP Status Code
Check an url for http status codes in your Github Actions.

## Usage

Create your Github Workflow configuration in `.github/workflows/http_status.yml` or similar.

Example: [http_status.yml](.github/workflows/http_status.yml)

```yml
name: Workflow for checking http status codes

on:
  push:
    branches: [ main ]
    tags: [ '*.*.*' ]

jobs:
  build:
    name: HTTP Status
    runs-on: ubuntu-latest
    steps:
      # ... uses ....
      - name: Check HTTP status
        uses: gerdemann/http-status-code@1.0.0
        with:
          url: https://github.com
          code: 200 # optional
          timeout: 60 # optional
          interval: 10 # optional
          username: ${{ secrets.USERNAME }} # optional
          password: ${{ secrets.PASSWORD }} # optional
      # ... uses ....
```

## Inputs

The following configuration options are available:

* `url` The url to check (e.g. "https://github.com")
* `code` The HTTP status code (eg: 200)
* `timeout` Timeout before giving up in seconds
* `interval` Interval between polling in seconds
* `username` Basic auth username
* `password` Basic auth password
