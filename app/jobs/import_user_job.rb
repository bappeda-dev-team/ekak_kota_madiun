class ImportUserJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    CsvImportService.new.import_user(file_path)
  ensure
    FileUtils.rm_f(file_path)
  end
end
