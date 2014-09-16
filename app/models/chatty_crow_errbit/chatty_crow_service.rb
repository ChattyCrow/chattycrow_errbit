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
      [:room_id, { placeholder: 'test@jabbim.com, test2@jabbim.com', label: 'Contacts separated by comma' }]
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
      m = message(problem)

      # Contacts?
      contacts = room_id.blank? ? nil : room_id.split(', ')

      # Set URL
      # TODO: Modify in gem!
      ChattyCrow.configure do |config|
        config.host  = service_url
        config.token = api_token
      end

      # Send message!
      ChattyCrow.send("send_#{service.downcase}", m, channel: sender_name, contacts: contacts)
    end

    private

    def message(problem)
      """#{problem.app.name}
      #{Errbit::Config.protocol}://#{Errbit::Config.host}/apps/#{problem.app.id}
      #{notification_description problem}"""
    end
  end
end
