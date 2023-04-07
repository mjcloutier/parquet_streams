require "test_helper"
require "tempfile"

module ParquetStreams
  class ReadTest < ActiveSupport::TestCase
    def setup
      @tempfile = Tempfile.new(["test", ".parquet"])
      Arrow::Table.new(id: [1, 2], name: ["Alice", "Bob"]).save(@tempfile.path, format: :parquet)
    end

    def teardown
      @tempfile.close
      @tempfile.unlink
    end

    test "reads parquet file in chunks" do
      reader = ParquetStreams::Read.new(@tempfile.path, chunk_size: 1)
      expected_chunks = [
        [{ "id" => 1, "name" => "Alice" }],
        [{ "id" => 2, "name" => "Bob" }]
      ]

      reader.read_in_chunks do |chunk|
        assert_equal expected_chunks.shift, chunk
      end

      assert expected_chunks.empty?, "All expected chunks should have been yielded"
    end

    test "raises error when file path is nil" do
      assert_raises ArgumentError do
        ParquetStreams::Read.new(nil)
      end
    end
  end
end
