class UserMailer < ApplicationMailer

  def admin_email(admin_id, coin_name, coin_value, coin_count_status)
    empty = ''
    if admin_id != empty
        @admin = Admin.find(admin_id)
        @coin_name = coin_name 
        @coin_value = coin_value
        @coin_count_status = coin_count_status

        mail(:to => @admin.email, :subject => "Coin status") do |format|
            format.text
            format.html
        end
    end
  end
end