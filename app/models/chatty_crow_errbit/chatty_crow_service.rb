require 'chatty_crow'

module ChattyCrowErrbit
  # Chatty crow notification service for Errbit
  class ChattyCrowService < ::NotificationService
    Label = 'chattycrow'

    SERVICES = %w(ios android skype jabber mail sms)

    Fields += [
      [:service_url, { placeholder: 'http://chattycrow.com/api/v1', label: 'API URL' }],
      [:service, { placeholder: "#{SERVICES.join(', ')}", label: "Service (valid options: #{SERVICES.join(', ')})" }],
      [:api_token, { placeholder: 'Application token', label: 'APP Token' }],
      [:sender_name, { placeholder: 'Channel token', label: 'Channel Token' }],
      [:user_id, { placeholder: 'test@jabbim.com, test2@jabbim.com', label: 'Contacts separated by comma' }]
    ]

    def check_params
      # Validation without room id, it's optional!
      if Fields[0...-1].find { |f| self[f[0]].blank? && self[f[2]].blank? }
        errors.add :base, 'You must specify your Service url, application token and channel token'
      end

      # Validate services
      errors.add :base, 'Invalid service' unless SERVICES.include?(service.to_s)
    end

    def create_notification(problem)
      # Get message for problem
      payload = payload(problem)

      # Contacts?
      contacts = user_id.blank? ? nil : user_id.gsub(/;/i, ",").split(",").map(&:strip).reject(&:empty?)

      # Set URL
      ::ChattyCrow.configure do |config|
        config.host  = service_url
      end

      # Send message!
      if payload.is_a?(Hash)
        ::ChattyCrow.send("send_#{service.downcase}", payload.merge(channel: sender_name, contacts: contacts, token: api_token))
      else
        ::ChattyCrow.send("send_#{service.downcase}", payload, channel: sender_name, contacts: contacts, token: api_token)
      end
    end

    private

    def payload(problem)
      res = message(problem)
      case service.downcase
      when 'android'
        res = { payload: { data: { alert: res } } }
      when 'ios'
        res = { payload: { aps: { alert: res } } }
      when 'mail'
        res = { html_body: res, subject: "Problem #{problem.app.name}" }
      end

      res
    end

    def message(problem)
      <<-MESSAGE
      #{problem.app.name}
      #{config_protocol}://#{Errbit::Config.host}/apps/#{problem.app.id}
      #{notification_description problem}
      MESSAGE
    end

    def config_protocol
      Errbit::Config.protocol || 'http'
    end
  end
end
