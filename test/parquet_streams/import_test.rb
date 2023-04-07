require "test_helper"
require "tempfile"

module ParquetStreams
  class ImportTest < ActiveSupport::TestCase
    def setup
      @tempfile = Tempfile.new(["test", ".parquet"])
      Arrow::Table.new(id: [1, 2], name: ["Alice", "Bob"]).save(@tempfile.path, format: :parquet)
      @test_model = Class.new(ActiveRecord::Base) { self.table_name = "test_models" }
    end

    def teardown
      @tempfile.close
      @tempfile.unlink
    end

    test "imports parquet data into model" do
      importer = ParquetStreams::Import.new(@tempfile.path, @test_model, chunk_size: 1)

      assert_difference("@test_model.count", 2) do
        importer.import
      end

      assert_equal "Alice", @test_model.find(1).name
      assert_equal "Bob", @test_model.find(2).name
    end

    test "raises error when file path or model is nil" do
      assert_raises ArgumentError do
        ParquetStreams::Import.new(nil, @test_model)
      end

      assert_raises ArgumentError do
        ParquetStreams::Import.new(@tempfile.path, nil)
      end
    end
  end
end
