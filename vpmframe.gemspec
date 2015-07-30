Gem::Specification.new do |gem|
  gem.name          = "vpmframe"
  gem.version       = "0.9.4"

  gem.authors       = ["Chris Van Patten"]
  gem.email         = ["info@vanpattenmedia.com"]
  gem.description   = "vpmframe Ruby tools"
  gem.summary       = "General vpmframe Ruby utilities and requirements"
  gem.homepage      = "http://github.com/vanpattenmedia/vpmframe-gem"

  gem.files         = `git ls-files`.split("\n")
  gem.require_paths = ["lib"]
end
