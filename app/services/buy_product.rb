# frozen_string_literal: true

class BuyProduct
  def self.run(buyer, product, total_cost, quantity)
    new(buyer: buyer, product: product, total_cost: total_cost, quantity: quantity).run
  end

  def initialize(buyer:, product:, total_cost:, quantity:)
    @buyer = buyer
    @product = product
    @total_cost = total_cost
    @quantity = quantity
    @change = 0
    @change_hash = {}
  end

  def run
    calculate_deposit_change

    # update product amount available
    update_product

    # update deposit money after buy product
    @buyer.reset_deposit
    remaining_money = @buyer.update_coins({ deposit: @change_hash.to_json })
    @buyer.update(remaining_money)

    # return change
    @change_hash
  end

  private

  attr_reader :buyer, :product, :total_cost, :change, :change_hash, :quantity

  def create_inventory
    inventory = Inventory.create!(product: product, status: :on_shelf)
    InventoryStatusChange.create!(
      inventory: inventory,
      status_from: nil,
      status_to: :on_shelf,
      actor: buyer
    )
  end

  def calculate_deposit_change
    change = buyer.total_money_deposited - total_cost
    return unless change.positive?

    user_deposit = buyer.deposit
    user_deposit.map { |k, v| [k.to_s.gsub('cent', '').to_i, v.to_i] }.reverse.each do |coin, coin_count|
      next unless coin_count.positive? && coin <= change

      rem = change % coin
      next unless rem < change

      hom_many = [coin_count, (change - rem) / coin].min

      amount = hom_many * coin
      change_hash.merge!({ "cent#{coin}": hom_many })
      change -= amount
      break if change.zero?
    end
  end

  def update_product
    remaining_quantity = product.amount_available.to_i - quantity
    product.update(amount_available: remaining_quantity)
  end
end
