require_relative '../../spec/simple_cov_helpers'
namespace :simplecov do
  desc 'merge results'
  task report_coverage: :environment do
    SimpleCovHelpers.report_coverage
  end
end
