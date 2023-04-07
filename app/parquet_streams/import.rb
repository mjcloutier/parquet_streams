module ParquetStreams
  class Import
    attr_reader :file_path, :model, :chunk_size

    def initialize(file_path, model, chunk_size: nil)
      @file_path = file_path
      @model = model
      @chunk_size = chunk_size || SecretConfig.fetch("parquet_streams/default_chunk_size")
    end

    def import
      raise ArgumentError, "File path and model cannot be nil" if file_path.nil? || model.nil?

      reader = ParquetStreams::Read.new(file_path, chunk_size: chunk_size)
      reader.read_in_chunks do |chunk|
        model.import chunk
      end
    rescue => e
      logger.measure_info "parquet_streams/import_error", metric: "parquet_streams/import/error" do
        Rails.logger.error "ParquetStreams::Import: Error importing parquet file: #{e.message}"
      end
      raise e
    end
  end
end
