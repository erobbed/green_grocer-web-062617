require "pry"

def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |item|
    item.each do |item_name, data|
      data.each do |key, value|
        if cart_hash[item_name]
          cart_hash[item_name][key] = value
        else
          cart_hash[item_name] = {key => value}
        end
      end
      cart_hash[item_name][:count] = cart.count(item)
    end
  end
  cart_hash
  #binding.pry
end

def apply_coupons(cart, coupons)
  #binding.pry
  coupons.each do |coupon|
    if cart.has_key?(coupon[:item]) && coupon[:num] <= cart[coupon[:item]][:count]
      coupon_item = "#{coupon[:item]} W/COUPON"
      cart[coupon[:item]][:count] -= coupon[:num]
      if cart.has_key?("#{coupon[:item]} W/COUPON")
        cart[coupon_item][:count] += 1
      else
        cart[coupon_item] = {:price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :count => 1}
      end
    else
      return cart
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, item_data|
    if item_data[:clearance] == true
      item_data[:price] -= (item_data[:price] * 0.2)
    else
      cart
    end
  end
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart_total = 0
  cart.each do |item, data|
    cart_total += (data[:price].to_f * data[:count]).to_f
  end
  cart_total > 100 ? cart_total * 0.9 : cart_total
end
