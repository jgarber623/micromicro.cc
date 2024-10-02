# frozen_string_literal: true

require_relative "models/refined_uri"

class App < Roda
  class InvalidURIError < StandardError; end

  HTTP_HEADERS_OPTS = {
    accept: "*/*",
    user_agent: "microformats2 Discovery (https://micromicro.cc)"
  }.freeze

  # Routing plugins
  plugin :head
  plugin :not_allowed
  plugin :status_handler
  plugin :type_routing, exclude: [:xml]

  # Rendering plugins
  plugin :h
  plugin :link_to
  plugin :public
  plugin :render, engine: "html.erb"

  # Request/Response plugins
  plugin :caching
  plugin :halt

  plugin :content_security_policy do |csp|
    csp.base_uri :self
    csp.block_all_mixed_content
    csp.default_src :none
    csp.font_src :self, "https://fonts.gstatic.com"
    csp.form_action :self
    csp.frame_ancestors :none
    csp.img_src :self
    csp.script_src :self
    csp.style_src :self, "https://fonts.googleapis.com"
  end

  plugin :permissions_policy, default: :none

  # Other plugins
  plugin :environments
  plugin :heartbeat

  # Third-party plugins
  plugin :sprockets,
         css_compressor: :sass_embedded,
         debug: false,
         precompile: ["application.css", "apple-touch-icon-180x180.png", "icon.png"]

  configure do
    use Rack::CommonLogger
    use Rack::ContentType
    use Rack::Deflater
    use Rack::ETag
  end

  # :nocov:
  configure :production do
    use Rack::HostRedirect, [ENV.fetch("HOSTNAME", nil), "www.micromicro.cc"].compact => "micromicro.cc"
    use Rack::Static,
        urls: ["/assets"],
        root: "public",
        header_rules: [
          [:all, { "cache-control": "max-age=31536000, immutable" }]
        ]
  end
  # :nocov:

  route do |r|
    r.public
    r.sprockets unless opts[:environment] == "production"

    r.on "" do
      # GET /
      r.get do
        response.cache_control public: true

        view :index
      end

      # POST /
      r.post do
        query = RefinedURI.new(r.params["url"])

        raise InvalidURIError if query.invalid?

        r.redirect "/u/#{query.url}"
      rescue InvalidURIError, URI::InvalidURIError
        r.halt 400
      end
    end

    # GET /u/https://example.com
    r.get "u", /(#{URI::DEFAULT_PARSER.make_regexp(["http", "https"])})/io do |url|
      query = RefinedURI.new(url)

      raise InvalidURIError if query.invalid?

      rsp = HTTP.follow(max_hops: 20).headers(HTTP_HEADERS_OPTS).timeout(connect: 5, read: 5).get(query.url)

      canonical_url = rsp.uri.to_s
      document = MicroMicro.parse(rsp.body.to_s, canonical_url)

      r.json { document.to_h.to_json }

      view :search, locals: { canonical_url: canonical_url, document: document }
    rescue InvalidURIError, Addressable::URI::InvalidURIError
      r.halt 400
    rescue HTTP::Error, OpenSSL::SSL::SSLError
      r.halt 408
    end
  end

  status_handler(400) do |r|
    error = { message: "Parameter url is required and must be a valid URL (e.g. https://example.com)" }

    r.json { error.to_json }

    view :bad_request, locals: error
  end

  status_handler(404) do |r|
    response.cache_control public: true

    error = { message: "The requested URL could not be found" }

    r.json { error.to_json }

    view :not_found, locals: error
  end

  status_handler(405, keep_headers: ["Allow"]) do |r|
    error = { message: "The requested method is not allowed" }

    r.json { error.to_json }

    error[:message]
  end

  status_handler(408) do |r|
    error = { message: "The request timed out and could not be completed" }

    r.json { error.to_json }

    view :request_timeout, locals: error
  end
end
