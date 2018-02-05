module Spree
  module CSVExporter
    class UsersReport
      require 'csv'

      def initialize(users = Spree::User.order(:id))
        @users = users.preload(:ship_address, :bill_address, :orders)
      end

      def to_csv
        CSV.generate do |csv|
          csv << header
          @users.each { |user| csv << line(user) }
        end
      end

      private

      def header
        [
          'ID',
          'Email',
          'Registration date',
          'Order count',
          *address_header('Ship'),
          *address_header('Bill')
        ]
      end

      def address_header(kind)
        [
          "#{kind}-to firstname",
          "#{kind}-to lastname",
          "#{kind}-to address1",
          "#{kind}-to address2",
          "#{kind}-to phone",
          "#{kind}-to zipcode",
          "#{kind}-to city",
          "#{kind}-to state"
        ]
      end

      def line(user)
        [
          user.id,
          user.email,
          user.created_at.strftime('%x'),
          user.orders.complete.count,
          *address_line(user.ship_address),
          *address_line(user.bill_address)
        ]
      end

      def address_line(address)
        [
          address&.firstname,
          address&.lastname,
          address&.address1,
          address&.address2,
          address&.phone,
          address&.zipcode,
          address&.city,
          address&.state&.abbr
        ]
      end
    end
  end
end
