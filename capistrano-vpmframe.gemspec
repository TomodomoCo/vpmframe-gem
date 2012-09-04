Gem::Specification.new do |gem|
  gem.name          = "capistrano-vpmframe"
  gem.version       = "0.0.1"

  gem.authors       = ["Chris Van Patten"]
  gem.email         = ["info@vanpattenmedia.com"]
  gem.description   = "vpmframe Ruby tools"
  gem.summary       = "General vpmframe Ruby utilities and requirements"
  gem.homepage      = "http://github.com/vanpattenmedia/capistrano-vpmframe"

  gem.files         = `git ls-files`.split("\n")
  gem.require_paths = ["lib"]
end
