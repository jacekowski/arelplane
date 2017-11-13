class ScreenShot
  PATH_TO_PHANTOM_SCRIPT = Rails.root.join('app', 'assets', 'javascripts', 'screenshot.js')

  def take_screenshot(user)
    # change this to AWS
    Dir.chdir(Rails.root.join('public'))
    system "phantomjs #{PATH_TO_PHANTOM_SCRIPT}
    #{user.id}
    #{user.id}.png"
  end
end
