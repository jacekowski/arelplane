class UploadErrorMailer < ApplicationMailer
  default from: 'error@arelplane.com'

  def error(user, file)
    @user = user
    @file = file

    attachments[@file.original_filename] = File.read(@file.tempfile)
    mail(to: 'arelenglish@gmail.com', subject: 'another upload error')
  end
end
