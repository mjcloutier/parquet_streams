require "arrow"
require "parquet"

module ParquetStreams
  class Import
    attr_reader :file_path, :model, :chunk_size

    def initialize(file_path, model, chunk_size: 1_000)
      @file_path  = file_path
      @model      = model
      @chunk_size = SecretConfig.fetch("parquet_streams/chunk_size") || chunk_size

      begin
        raise ArgumentError, "File path and model cannot be nil." if file_path.nil? || model.nil?
        parquet_reader = ParquetStreams::Read.new(file_path, chunk_size: chunk_size)
        table          = parquet_reader.table
        import_data(table, model)
      rescue => e
        logger.measure_info "parquet_streams.import.error", metric: "parquet_streams/import/error" do
          Rails.logger.error("ParquetStreams::Import error: #{e.message}")
        end
      end
    end

    private

    def import_data(table, model)
      table.each_record_batch do |record_batch|
        model.import(record_batch.to_h, validate: false)
      end
    end

    def logger
      @logger ||= ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
    end
  end
end
