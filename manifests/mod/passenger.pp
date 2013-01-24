class apache::mod::passenger {
  include 'apache'

  apache::mod { 'passenger': }
}
