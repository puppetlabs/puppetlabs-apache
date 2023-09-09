# frozen_string_literal: true

# @summary this function populates and returns the string of arguments which later gets injected in template.
# arguments that return string holds is conditional and decided by the the input given to function.

Puppet::Functions.create_function(:'apache::error_document') do
  # @param args
  #   String backupuser
  #   Boolean backupcompress
  #   String backuppassword_unsensitive
  #   Array backupdatabases
  #   Array optional_args
  #
  # @return String
  #   Generated on the basis of provided values.
  #
  dispatch :error_document do
    required_param 'Variant[Array[Hash], String]', :error_documents
    return_type 'Variant[String]'
  end

  def error_document(error_documents)
    error_doc += ''
    if error_documents && !error_documents.empty?
      [error_documents].flatten.compact.each do |error_document|
        error_doc = "ErrorDocument  #{error_document['error_code']} #{error_document['document']}" if error_document['error_code'] != '' && error_document['document'] != ''
      end
    end

    error_doc
  end
end
