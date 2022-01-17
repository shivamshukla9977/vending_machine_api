require 'rails_helper'

RSpec.describe BuyProduct do
  it 'buy product change' do
    buyer = create(:user, role: :buyer)
    buyer.deposit = {"cent5": "10", "cent10": "10", "cent20": "10", "cent50": "1", "cent100": "10"}
    buyer.save
    product = create(:product, amount_available: "5", cost: 100)

    expect(product.amount_available).to match("5")
    expect(buyer.total_money_deposited).to match(1400)


    BuyProduct.run(buyer, product, 300, 3)
    product.reload
    buyer.reload
    expect(product.amount_available).to match("2")
    expect(buyer.total_money_deposited).to match(1100)
  end
end
