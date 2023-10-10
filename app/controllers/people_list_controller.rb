class PeopleListController < ApplicationController
    def people_list
    end

    def form
      EventRemainderMailer.with(email: params[:email]).remainder_email.deliver_now
      # render template: "people_list/people_list"
      #render template: root
      redirect_to home_path
    end


  end
  