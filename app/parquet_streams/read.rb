module ParquetStreams
  class Read
    attr_reader :file_path, :chunk_size

    def initialize(file_path, chunk_size: nil)
      @file_path = file_path
      @chunk_size = chunk_size || SecretConfig.fetch("parquet_streams/default_chunk_size")
    end

    def read_in_chunks
      raise ArgumentError, "File path cannot be nil" if file_path.nil?

      Arrow::Table.load(file_path, batch_size: chunk_size) do |table_chunk|
        yield table_chunk.to_h.to_a
      end
    rescue => e
      logger.measure_info 'parquet_streams/read_error', metric: 'parquet_streams/read/error' do
        Rails.logger.error "ParquetStreams::Read: Error reading parquet file: #{e.message}"
      end
      raise e
    end
  end
end
