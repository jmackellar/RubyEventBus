# Basket Module

module Basket
	@itemsInBasket = {
		"apple" => 1.99,
		"avocado" => 5.35,
		"soda" => 0.99,
	}

	# Hook into the eventBus
	def Basket.initialize(eventBusHook, args)
		@eventBusHook = eventBusHook
		@eventBusHook.subscribe(self, 'priceUpdate')
	end

	# Listen for subscribed channels through the eventBus
	def Basket.listen(eventName, sender, args)
		puts "[Basket]Recieved event " + eventName + " from " + sender
		case eventName
		when 'priceUpdate'
			Basket.priceUpdate(args)
		end
	end

	# Recieving an update about the price of items held
	# in the customers basket
	def Basket.priceUpdate(args)
		puts "[Basket]Updating price of items in basket"
		args.each do |k, v|
			if @itemsInBasket[k] 
				@itemsInBasket[k] = v 
			end 
		end
	end

	# Customer finishes checking out and begins to pay.
	# Dont allow the price of items in their cart to be 
	# adjusted anymore
	def Basket.finalizeCheckout()
		puts "[Basket]Checkout finalized, locking price of customer\'s basket"
		@eventBusHook.unsubscribe(self, 'priceUpdate')
	end

	def Basket.displayBasket()
		puts "[Basket]"
		@itemsInBasket.each do |k, v|
			puts "  Item: %s Price: $%.2f\n" % [k.ljust(15).capitalize, v]
		end
	end

	def Basket.getName() return 'Basket' end
end