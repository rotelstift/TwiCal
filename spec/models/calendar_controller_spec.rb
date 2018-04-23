require 'rails_helper'

describe CalendarController, type: :controller do

  describe 'GET #home' do
    context 'without params[:display_time]' do
      it "renders the :home template" do
        get :home
        expect(response).to render_template :home
      end
    end
  end

  describe 'GET #calendar' do
    context 'with params[:display_time]' do
      it "renders the :calendar template" do
        get :calendar, display_time: '2017-03-31'
        expect(response).to render_template :calendar
      end

      it "redirect_to / insted of render :calendar template" do
        get :calendar, display_time: '2017-02-31'
        expect(response).to redirect_to '/'
      end
    end
  end

  describe 'GET #schedule' do
    context 'with params[:schedule_day]' do
      it "renders the :schedule template" do
        get :schedule, schedule_day: '2017-03-31'
        expect(response).to render_template :schedule
      end
    end
  end
end
