class ApplicationMailer < ActionMailer::Base
  default from: "Pinwheel <notifications@pinwheel.test>"
  layout "mailer"
end
