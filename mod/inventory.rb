# Inventory Module

module Inventory
	@itemCatalog = {
		"apple" => 1.99,
		"banana" => 2.99,
		"avocado" => 5.35,
		"pear" => 3.55,
		"candy" => 0.99,
		"soda" => 0.99,
	}

	# Hook into the eventBus
	def Inventory.initialize(eventBusHook, args)
		@eventBusHook = eventBusHook
		@eventBusHook.subscribe(self, 'adjustPrices')
	end

	# Listen for subscribed channels through the eventBus
	def Inventory.listen(eventName, sender, args)
		puts "[Inventory]Recieved event " + eventName + " from " + sender
		case eventName 
		when 'adjustPrices'
			Inventory.adjustPrices(args)
		end
	end

	# Adjust the price of all items by first passed item in 
	# array args
	def Inventory.adjustPrices(args)
		adjustment = 1 + args[0]
		puts "[Inventory]Adjusting price of all items to " + (adjustment * 100).to_s + "\% of original value"
		@itemCatalog.each do |k, v|
			@itemCatalog[k] = v * adjustment
		end
		@eventBusHook.publish('priceUpdate', 'Inventory', @itemCatalog)
	end

	def Inventory.displayCatalog()
		puts "[Inventory]"
		@itemCatalog.each do |k, v|
			puts "  Item: %s Price: $%.2f\n" % [k.ljust(15).capitalize(), v]
		end
	end

	def Inventory.getName() return 'Inventory' end
end