require 'spec_helper'

class DailyReport < ActiveRecord::Base
  include SimpleMySQLPartitioning
  self.table_name = 'daily_reports'

  partition :day, by: :range
end

RSpec.describe SimpleMySQLPartitioning::Executor do
  let(:table_name) { 'daily_reports' }

  describe '#add' do
    pending 'skip'
  end

  describe '#reorganize' do
    let(:partiion_name) { 'p201808' }
    let(:value)         { '2018-09-01' }
    let(:instance)      { SimpleMySQLPartitioning::Executor.new(DailyReport, partiion_name) }

    it 'has new partition' do
      instance.reorganize(value, 'p999999')
      expect(instance.exist?).to eq true
    end
  end

  describe '#drop' do
    let(:partiion_name) { 'p201808' }
    let(:instance)      { SimpleMySQLPartitioning::Executor.new(DailyReport, partiion_name) }

    it 'has new partition' do
      instance.drop
      expect(instance.exist?).to eq false
    end
  end

  describe '.partition' do
    it 'include module' do
      expect(DailyReport.respond_to?(:partition)).to eq true
      expect(DailyReport.partition_config[:column]).to eq :day
      expect(DailyReport.partition_config[:by]).to eq :range
    end
  end
end
