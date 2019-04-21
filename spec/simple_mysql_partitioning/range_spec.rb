require 'spec_helper'

class DailyReport < ActiveRecord::Base
  include SimpleMySQLPartitioning
  self.table_name = 'daily_reports'

  partitioning_by :day, type: :range
end

RSpec.describe SimpleMySQLPartitioning::Range do
  let(:klass)                    { DailyReport }
  let(:table_name)               { 'daily_reports' }
  let(:max_value_partition_name) { 'pmax' }

  describe '.partition_by' do
    it {
      expect(DailyReport.respond_to?(:partitioning_by)).to be_truthy
      expect(DailyReport.partition_config[:column]).to eq :day
      expect(DailyReport.partition_config[:type]).to eq :range
    }
  end

  describe '.partition' do
    it {
      expect(DailyReport.respond_to?(:partition)).to be_truthy
      expect(
        DailyReport.partition.instance_of?(SimpleMySQLPartitioning::Range)
      ).to be_truthy
    }
  end

  describe '#create' do
    let(:partition_name) { 'p201806' }
    let(:value)          { '2018-07-01' }

    it 'has new partition' do
      klass.partition.create([[partition_name, value]])
      expect(klass.partition.exists?(partition_name)).to be_truthy
    end
  end

  describe '#add' do
    context 'MAXVALUEではない' do
      let(:partition_name) { 'p201807' }
      let(:value)          { '2018-08-01' }
      it 'has new partition' do
        klass.partition.add([[partition_name, value]])
        expect(klass.partition.exists?(partition_name)).to be_truthy
      end
    end

    context 'MAXVALUE' do
      let(:value) { 'MAXVALUE' }
      it 'has new partition' do
        klass.partition.add([[max_value_partition_name, value]])
        expect(klass.partition.exists?(max_value_partition_name)).to be_truthy
      end
    end
  end

  describe '#reorganize' do
    let(:partition_name) { 'p201808' }
    let(:value)          { '2018-09-01' }
    let(:reorganize_partition_name) { max_value_partition_name }
    let(:reorganize_partition_value) { 'MAXVALUE' }

    before do
      unless klass.partition.exists?(reorganize_partition_name)
        klass.partition.add(
          [[reorganize_partition_name, reorganize_partition_value]]
        )
      end
    end

    it 'has reorganized partition' do
      klass.partition.reorganize(
        [
          [partition_name, value]
        ],
        reorganize_partition_name,
        reorganize_partition_value
      )

      expect(klass.partition.exists?(partition_name)).to be_truthy
      expect(klass.partition.exists?(reorganize_partition_name)).to be_truthy
    end
  end

  describe '#drop' do
    let(:partition_name) { 'p201808' }
    let(:value)          { '2018-09-01' }
    before do
      klass.partition.add([[partition_name, value]]) \
        unless klass.partition.exists?(partition_name)
    end

    it 'dropped partition' do
      klass.partition.drop(partition_name)
      expect(klass.partition.exists?(partition_name)).to be_falsey
    end
  end
end
