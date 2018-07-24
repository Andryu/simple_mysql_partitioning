ActiveRecord::Base.configurations = { 'test' => { adapter: 'mysql2', database: ':memory:' } }
ActiveRecord::Base.establish_connection :test

class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:daily_reports, id: false, primary_key: %i[id day]) do |t|
      t.column :id, 'BIGINT AUTO_INCREMENT'
      t.date   :day
      t.text   :content
    end
    partition = "ALTER TABLE daily_reports
                  PARTITION BY RANGE  COLUMNS(`day`)  (
                  PARTITION p201804 VALUES LESS THAN ('2018-05-01') ENGINE = InnoDB,
                  PARTITION p201805 VALUES LESS THAN ('2018-06-01') ENGINE = InnoDB,
                  PARTITION p201806 VALUES LESS THAN ('2018-07-01') ENGINE = InnoDB,
                  PARTITION p999999 VALUES LESS THAN (MAXVALUE) ENGINE = InnoDB
             )
    "
    execute partition
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.up
