# CombineUIKit

The Combine framework provides a declarative Swift API for processing values over time. These values can represent many kinds of asynchronous events. Combine declares publishers to expose values that can change over time, and subscribers to receive those values from the publishers.

The Publisher protocol declares a type that can deliver a sequence of values over time. Publishers have operators to act on the values received from upstream publishers and republish them.

At the end of a chain of publishers, a Subscriber acts on elements as it receives them. Publishers only emit values when explicitly requested to do so by subscribers. This puts your subscriber code in control of how fast it receives events from the publishers it’s connected to.

Several Foundation types expose their functionality through publishers, including Timer, NotificationCenter, and URLSession. 
# Combine also provides a built-in publisher for any property that’s compliant with Key-Value Observing.

# Subject Demo Recording

![combine subject's demo](https://github.com/nbnitin/CombineUIKit/assets/5785670/1f54de2b-f001-4bb2-b3c8-e419ec825538)


# Combine Publisher Latest Demo

![Combine Latest Demo](https://github.com/nbnitin/CombineUIKit/assets/5785670/b973fbc5-a68a-41e0-b8ef-147d930d25e5)
