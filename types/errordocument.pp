# @summary A mapping for an error code and a document
type Apache::Errordocument = Struct[
  error_code => Variant[String[3, 3], Integer[400, 599]],
  document   => String[1],
]
