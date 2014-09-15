module ChattyCrowErrbit
  # Rails engine
  class Engine < ::Rails::Engine
    isolate_namespace ChattyCrowErrbit

    initializer 'chatty_crow_errbit.require_model' do
      # Very ugly workaround to force ruby discover NotificationService sublcass!
      ChattyCrowErrbit::ChattyCrowService
    end
  end
end
