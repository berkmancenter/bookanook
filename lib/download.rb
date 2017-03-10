module Download
  
  def download
      directory = "#{Rails.root}/public/reports"
      filename = "#{current_user.id}-reservations.csv"
      file = File.join(directory, filename)

      File.open(file, 'w') do |f|
        f.write Reservation.to_csv(@reservations)
      end

      send_file file,
              filename: "Reservations.csv",
              type: "application/csv"
  end
end
