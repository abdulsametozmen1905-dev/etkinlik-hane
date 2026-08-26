module Admin
class DashboardController < ApplicationController
    before_action :require_admin

    def index
    @total_users = User.count
    @total_events = Event.count
    @published_events = Event.published.count
    @draft_events = Event.drafts.count
    @total_registrations = Registration.count
    @confirmed_registrations = Registration.confirmed.count
    @waitlisted_registrations = Registration.waitlisted.count
    @total_ratings = Rating.count

    @recent_events = Event.order(created_at: :desc).limit(5)

    @popular_events = Event.joins(:registrations)
                            .group("events.id")
                            .order("COUNT(registrations.id) DESC")
                            .limit(5)
    end

    private

    def require_admin
        unless current_user&.admin?
        redirect_to root_path, alert: "Bu sayfaya erişim yetkiniz bulunmuyor."
        end
    end
end
end
