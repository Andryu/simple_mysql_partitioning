require 'spec_helper'

class DailyReport < ActiveRecord::Base
  self.table_name = 'daily_reports'
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
end
