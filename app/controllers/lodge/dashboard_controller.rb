class Lodge::DashboardController < Lodge::LodgeController
  expose(:unchecked_treads_count)  { Tread.unchecked.count }

  def statistics
    respond_to do |format|
      format.json do
        render json: { posting: Board.get_posting_summary_statistic, visits: Board.get_visits_summary_statistic }
      end
      format.any { render nothing: true }
    end
  end
end
