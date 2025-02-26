require "sqlite3"
require "./spec_helper"

module Orma::UniqueSpec
  class MyRecord < Orma::Record
    id_column id : Int64
    column name : String, unique: true

    def self.db_connection_string
      "sqlite3://./test.db"
    end
  end

  describe "MyRecord#save" do
    before_all do
      MyRecord.continuous_migration!
    end

    after_all do
      File.delete("./test.db")
    end

    it "raises on attempted uniqueness violation" do
      record1 = MyRecord.create(name: "Test")

      expect_raises(Orma::DBError) do
        record2 = MyRecord.create(name: "Test")
      end
    end

    it "doesn't raise on the next continuous migration run" do
      MyRecord.continuous_migration!
    end
  end
end
