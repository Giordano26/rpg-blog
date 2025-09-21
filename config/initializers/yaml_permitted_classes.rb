Rails.application.config.after_initialize do
  if defined?(Psych)
    Psych.add_domain_type("yaml.org,2002", "ruby/time") do |type, val|
      Time.parse(val)
    end
  end
end
