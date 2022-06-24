# frozen_string_literal: true

# dependency injection (DI)
class API < Sinatra::Base
  def initialize(ledger:)
    @ledger = ledger
    super()
  end
end

app = API.new(ledger: Ledger.new)
