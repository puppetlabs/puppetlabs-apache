class apache::mod::headers {
  if ! defined(Apache::Mod['headers']){
    ::apache::mod { 'headers': }
  }
}
