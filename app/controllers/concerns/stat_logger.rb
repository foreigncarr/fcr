module StatLogger
  extend ActiveSupport::Concern
  included do
    def stat(action_detail, action_category='페이지뷰', extra={})
      start_time = Time.now()

      brand = extra.delete(:brand).presence || extra.delete('brand').presence || params[:brand].presence || ''
      model = extra.delete(:model).presence || extra.delete('model').presence || params[:model].presence || ''
      from  = extra.delete(:from).presence || extra.delete('from').presence || params[:from].presence || ''
      area  = extra.delete(:from).presence || extra.delete('area').presence || params[:area].presence || ''

      Rails.logger(:stat).info({
                                   date_id:         start_time.to_s.split[0] || '',
                                   time_id:         start_time.to_s.split[1] || '',
                                   fcr_user:        @fcr_user || '',
                                   action_category: action_category,
                                   action_detail:   action_detail,
                                   from:            from,
                                   area:            area,
                                   brand:           brand,
                                   model:           model,
                                   extra:           extra || {},

                                   ip:              request.env['HTTP_X_REAL_IP'].presence || request.remote_ip || '',
                                   user_agent:      request.user_agent || '',
                                   referer:         request.referer || '',
                                   request_method:  request.method || '',
                                   request_path:    request.path || ''


                               }.to_json)
    end
  end
end