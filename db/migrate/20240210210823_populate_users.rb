class PopulateUsers < ActiveRecord::Migration[7.0]
  def up
    User.create(serial_no: 1, email: 'contact_pankaj@tamu.edu', password: '1234')
    User.create(serial_no: 2, email: 'ermcgonagle@tamu.edu', password: '1234')
    User.create(serial_no: 3, email: 'debal_goswami@tamu.edu', password: '1234')
    User.create(serial_no: 4, email: 'prakhar2@tamu.edu', password: '1234')
    User.create(serial_no: 5, email: 'cmeisel101@tamu.edu', password: '1234')
    User.create(serial_no: 6, email: 'ewang41@tamu.edu', password: '1234')
    User.create(serial_no: 7, email: 'gdbrowne85@tamu.edu', password: '1234')
    User.create(serial_no: 8, email: 'anirith@tamu.edu', password: '1234')
    User.create(serial_no: 9, email: 'pcr@tamu.edu', password: '1234')
  end
end
