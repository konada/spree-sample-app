Spree::Admin::ReportsController.class_eval do

  def initialize
    super
    Spree::Admin::ReportsController.add_available_report!(:sales_total)
    Spree::Admin::ReportsController.add_available_report!(:users_csv)
  end

  def users_csv
    send_data Spree::CSVExporter::UsersReport.new.to_csv, type: 'text/csv; charset=utf-8; header=present',
      disposition: "attachment; filename=users_report.csv"
  end
end
