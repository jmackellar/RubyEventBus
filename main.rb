# EventBus 
# Entity Messaging

# Modules
require "./mod/Inventory"
require "./mod/Basket"

# Class EventBus
# Handles messaging between entities by opening channels
# that entites may subscribe to or publish events through.
class EventBus
	def initialize(args)
		@subscriptions = { }
	end

	# Publish an event to all entites that are subscribed.
	# Subscribed entites are assumed to have a function listen
	# that will have data sent through
	def publish(eventName, sender, eventArgs)
		if @subscriptions[eventName] 
			@subscriptions[eventName].each do |k, v|
				if k 
					puts '[eventBus]Publishing event ' + eventName + ' to entity ' + k.getName() + ' sent from ' + sender
					k.listen(eventName, sender, eventArgs)
				end
			end
		end
	end

	# Subscribes an entity to channel eventName.  If the channel
	# doesn't exist then create it
	def subscribe(entity, eventName)
		if not @subscriptions[eventName] 
			@subscriptions[eventName] = [ ] 
		end
		puts "[eventBus]Subscribing " + entity.getName() + " to channel " + eventName
		@subscriptions[eventName].push(entity)
	end

	# Unsubscribes an entity from a chennel
	def unsubscribe(entity, eventName)
		if @subscriptions[eventName] 
			for i in 0..@subscriptions[eventName].length() - 1
				if entity == @subscriptions[eventName][i]
					puts "[eventBus]Unsubscribing " + entity.getName() + " from channel " + eventName
					@subscriptions[eventName][i] = nil 
					break 
				end
			end
		end
	end
end

def start()
	# Initialize eventBus and Modules
	eventBus = EventBus.new([])
	Inventory.initialize(eventBus, [])
	Basket.initialize(eventBus, [])
	# Display the starting price of all items
	Inventory.displayCatalog()
	Basket.displayBasket()
	# Send an adjustPrices message through the 
	# eventBus.  The price of items in both
	# the inventory and basket will be adjusted
	eventBus.publish('adjustPrices', 'System', [-0.15])
	Inventory.displayCatalog()
	Basket.displayBasket()
	# Customer finalized their basket and begins to
	# check out.  Adjust prices again but this time
	# only the inventory will be affected.  The basket
	# will not have its items adjusted.
	Basket.finalizeCheckout()
	eventBus.publish('adjustPrices', 'System', [0.45])
	Inventory.displayCatalog()
	Basket.displayBasket()
end

start()
gets