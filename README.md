# Parquet Streams

ParquetStreams is a Rails engine that provides functionality for reading and importing Parquet files into your Ruby on Rails application. It includes `Parquet::Reader` and `Parquet::Importer` classes for easy integration and handling of large Parquet files.

## Installation

Add this line to your main Rails application's `Gemfile`:

```ruby
gem "parquet_streams"
```

And then execute:

```bash
bundle install
```

## Usage

### Parquet::Reader
The Parquet::Reader class is responsible for reading Parquet files in chunks. It supports configurable chunk sizes and yields chunks of records as arrays of hashes.

Example:

```ruby
reader = ParquetConsumer::Parquet::Reader.new("path/to/your/parquet_file.parquet")
reader.read_in_chunks do |chunk|
  # Process the chunk
end
```

### Parquet::Importer
The Parquet::Importer class is responsible for importing data from a Parquet file into an ActiveRecord model. It supports configurable chunk sizes for efficient import of large files.

Example:

```ruby
class MyModel < ApplicationRecord
  # ...
end

importer = ParquetStreams::Import.new("path/to/your/parquet_file.parquet", MyModel)
importer.import
```

### Running Tests
To run the tests for the ParquetStreams engine, navigate to the engine's root directory and execute:

```bash
bin/test
```

### Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/mjcloutier/parquet_streams.

### License
The engine is available as open-source under the terms of the MIT License.
