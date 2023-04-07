require "test_helper"
require "tempfile"
require "arrow"
require "parquet"

class VirtualModel
  def self.import(*)
  end
end

module ParquetStreams
  class ImportTest < ActiveSupport::TestCase
    def setup
      @tempfile = Tempfile.new(["test", ".parquet"])
      record_batch1 = Arrow::RecordBatch.new([id: 1, name: "Alice"])
      record_batch2 = Arrow::RecordBatch.new([id: 2, name: "Charlie"])
      Arrow::Table.new([record_batch1, record_batch2]).save(@tempfile.path, format: :parquet)
      @parquet_file_path = @tempfile.path
      @model = VirtualModel
    end

    def teardown
      @tempfile.close
      @tempfile.unlink
    end

    test "imports parquet data into model successfully" do
      assert_nothing_raised do
        ParquetStreams::Import.new(@parquet_file_path, @model)
      end
    end

    test "raises error when file path is nil" do
      assert_raises(ArgumentError) do
        ParquetStreams::Import.new(nil, @model)
      end
    end

    test "raises error when model is nil" do
      assert_raises(ArgumentError) do
        ParquetStreams::Import.new(@parquet_file_path, nil)
      end
    end
  end
end
