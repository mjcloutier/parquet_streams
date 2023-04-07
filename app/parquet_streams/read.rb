require "arrow"
require "parquet"

module ParquetStreams
  class Read
    attr_reader :file_path, :chunk_size

    def initialize(file_path, chunk_size: 1_000)
      @file_path  = file_path
      @chunk_size = SecretConfig.fetch("parquet_streams/chunk_size") || chunk_size

      begin
        raise ArgumentError, "File path cannot be nil." if file_path.nil?
        read_parquet_file(file_path, chunk_size)
      rescue => e
        logger.measure_info "parquet_streams.read.error", metric: "parquet_streams/read/error" do
          Rails.logger.error("ParquetStreams::Read error: #{e.message}")
        end
      end
    end

    private

    def read_parquet_file(file_path, chunk_size)
      chunk_size ||= SecretConfig.fetch("parquet_streams/chunk_size")
      Arrow::Table.load(file_path, format: :parquet, batch_size: chunk_size)
    end

    def logger
      @logger ||= ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
    end
  end
end
