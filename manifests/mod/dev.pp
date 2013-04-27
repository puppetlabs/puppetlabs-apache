class apache::mod::dev inherits apache::params {
  # Development packages are not apache modules
  warning('apache::mod::dev is deprecated; please use apache::dev')
  include apache::dev
}
