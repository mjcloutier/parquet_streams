require_relative "lib/parquet_streams/version"

Gem::Specification.new do |spec|
  spec.name        = "parquet_streams"
  spec.version     = ParquetStreams::VERSION
  spec.authors     = ["Michael Cloutier"]
  spec.email       = ["viotech@comcast.net"]
  spec.homepage    = "https://github.com/mjcloutier/parquet_streams"
  spec.summary     = "ParquetStreams is a Rails engine that simplifies reading and importing Parquet files into Ruby on Rails applications."
  spec.description = "ParquetStreams is a Rails engine that streamlines the process of reading and importing Parquet files into Ruby on Rails applications. It includes the Parquet::Reader and Parquet::Importer classes, allowing for efficient handling of large Parquet files with customizable chunk sizes. With easy integration and robust functionality, ParquetConsumer enables developers to focus on their core application features without worrying about the complexities of working with Parquet files."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mjcloutier/parquet_streams"
  spec.metadata["changelog_uri"] = "https://github.com/mjcloutier/parquet_streams/blob/master/CHANGELOG.md"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 6"
end
