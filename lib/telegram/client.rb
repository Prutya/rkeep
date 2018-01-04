class Telegram::Client
  def self.send_message(
    message:,
    title: nil,
    ts: DateTime.now.utc.iso8601,
    bot_key: Rails.configuration.telegram_key,
    chat_id: Rails.configuration.telegram_channel_id
  )
    text = <<~MD
      #{title.nil? ? nil : "*#{title}*"}
      #{message}
    MD

    request = RestClient::Request.new({
      method: :post,
      url: "https://api.telegram.org/bot#{bot_key}/sendMessage",
      payload: { chat_id: chat_id.to_s, parse_mode: 'Markdown', text: text }
    })

    begin
      response = request.execute
    rescue RestClient::ExceptionWithResponse => e
      response = e.response
    end

    response
  end
end
