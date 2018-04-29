require 'simplecov'
require 'codeclimate-test-reporter'

class SimpleCovHelpers
  SKIPPED_FILES = %w[].freeze

  class << self
    def report_coverage(base_dir: './coverage_results')
      puts "report_coverage base_dir: #{base_dir}"
      setup_coverage
      SimpleCov.start 'rails'
      new(base_dir: base_dir).merge_results
    end

    def setup_coverage
      check_coverage = ENV.fetch('SKIP_COVERAGE_CHECK', 'false') == 'false'
      SimpleCov.minimum_coverage(86) if check_coverage
      SimpleCov.merge_timeout(3600)

      SKIPPED_FILES.each do |file|
        SimpleCov.add_filter(file)
      end

      # Dir.glob(File.join('.', 'app', '*')).select { |f| File.directory?(f) && (f !~ /(admin|assets)\z/) }.each do |dirname|
      #   item = File.basename(dirname)
      #   next if item == 'admin'
      #   SimpleCov.add_group item.capitalize, "app/#{item}"
      # end
    end
  end

  attr_reader :base_dir

  def initialize(base_dir:)
    @base_dir = base_dir
    puts "initialize base_dir: #{@base_dir}"
    @base_dir
  end

  def all_results
    res = Dir["#{base_dir}/*.json"]
    puts "all_results res: #{res.inspect}"
    res
  end

  def merge_results
    results = []
    all_results.each do |result_file_name|
      Rails.logger.info "Processing #{result_file_name}"
      result_number = File.basename(result_file_name, '.json').gsub('resultset-', '')
      result_hash = JSON.parse(File.read(result_file_name))
      result_hash["RSpec#{result_number}"] = result_hash.delete('RSpec')
      results << SimpleCov::Result.from_hash(result_hash)
    end
    merged = SimpleCov::RawCoverage.merge_results(*results.map(&:original_result))
    result = SimpleCov::Result.new(merged)
    result.command_name = 'RSpec'
    result.format!
    CodeClimate::TestReporter.run(result.to_hash)
  end
end
