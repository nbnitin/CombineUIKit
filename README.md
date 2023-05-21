# CombineUIKit https://developer.apple.com/documentation/combine

The Combine framework provides a declarative Swift API for processing values over time. These values can represent many kinds of asynchronous events. Combine declares publishers to expose values that can change over time, and subscribers to receive those values from the publishers.

The Publisher protocol declares a type that can deliver a sequence of values over time. Publishers have operators to act on the values received from upstream publishers and republish them.

At the end of a chain of publishers, a Subscriber acts on elements as it receives them. Publishers only emit values when explicitly requested to do so by subscribers. This puts your subscriber code in control of how fast it receives events from the publishers it’s connected to.

Several Foundation types expose their functionality through publishers, including Timer, NotificationCenter, and URLSession. 
# Combine also provides a built-in publisher for any property that’s compliant with Key-Value Observing.

# Subject Demo Recording

![combine subject's demo](https://github.com/nbnitin/CombineUIKit/assets/5785670/1f54de2b-f001-4bb2-b3c8-e419ec825538)


# Combine Publisher Latest Demo

https://github.com/nbnitin/CombineUIKit/assets/5785670/4c70e58b-cf0c-45de-9197-f9569bada01e


# Other Combine Operators

1. Prepend
    ![image](https://github.com/nbnitin/CombineUIKit/assets/5785670/19634540-9134-46a9-833b-0e5b43efb360)

var subscriptions = Set<AnyCancellable>()
let publisher = [5, 6].publisher
publisher
    .prepend(3, 4)
    .sink(receiveValue: { print($0) }
    .store(in: &subscriptions)
Output:
3, 4, 5, 6

  Here, the result must be the same type as items i.e if you have the publisher of Integer, you can not get String as a result.

Similarly, we have the Append operator which works the same as Prepend
 
2. ReplaceNil
    ![image](https://github.com/nbnitin/CombineUIKit/assets/5785670/16e91be7-f650-48e7-a089-4742410b4446)
[1, 2, nil, 6].publisher
    .replaceNil(with: 5)
    .sink(receiveValue: { print($0!) }
    .store(in: &subscriptions)
Output:
1, 2, 5, 6
As a result, we can see that the nil value is replaced with the given number 5.

An important difference between ?? and replaceNil(with:) is that the former can return another optional, while the latter can’t.

3. switchToLatest
  ![image](https://github.com/nbnitin/CombineUIKit/assets/5785670/7a49960f-cdf1-4438-8a6b-c1bd9f9fb2b2)
  
  We can only use it on publishers that themselves emit publishers.

Let’s understand it with an example.

let subject1 = PassthroughSubject<Int, Never>()
let subject2 = PassthroughSubject<Int, Never>()
let subject3 = PassthroughSubject<Int, Never>()
let subjects = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
subjects.switchToLatest()
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
subjects.send(subject1)
subject1.send(1)
subjects.send(subject2)
subject1.send(2)
subject2.send(3)
subject2.send(4)
subjects.send(subject3)
subject2.send(5)
subject2.send(6)
subject3.send(7)
Output:
1
3
4
7
What happens is that each time you send a publisher through publishers, you switch to the new one and cancel the previous subscription.

Consider a real-world example where we have a search text field that is used to detect if an item is available. Once the user inputs something, we want to trigger a request. Our goal is to cancel the previous request if the user has inputted a new value. This can be done with the help of .switchToLatest.

4. merge(with:)
This operator combines two Publishers as if we’re receiving values from just one.
![image](https://github.com/nbnitin/CombineUIKit/assets/5785670/41cd5015-db63-45b6-93f9-21943454bb6d)

let stringSubject1 = PassthroughSubject<String, Never>()
let stringSubject2 = PassthroughSubject<String, Never>()
stringSubject1
    .merge(with: stringSubject2)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
stringSubject1.send("Hello")
stringSubject2.send("World")
stringSubject2.send("Good")
stringSubject1.send("Morning")
Output:
Hello
World
Good
Morning
  
As shown here, we can see that all values print as a single stream publisher.

Note: Here, it requires that both publishers must be of the same type.
  
5. CombineLatest
It combines different publishers of different value types. The emitted output is a tuple with the latest values of all publishers whenever any of them emit a value.
  ![image](https://github.com/nbnitin/CombineUIKit/assets/5785670/40151943-bd91-4988-97c7-f53aaec1c2de)
Before .combineLatest emits something, each publisher must emit at least a value.

Let’s understand it with an example.

let subject1 = PassthroughSubject<Int, Never>()
let subject2 = PassthroughSubject<String, Never>()
subject1
    .combineLatest(subject2)
    .sink(receiveValue: { print("\($0) = \($1)") })
    .store(in: &subscriptions)
subject1.send(1)
subject1.send(2)
subject2.send("A")
subject2.send("B")
subject1.send(3)
subject2.send("C")
Output:
2 = A
2 = B
3 = B
3 = C
As shown here, the original publisher combines with the latest value of another publisher and makes combinations accordingly.

Consider a real-world example where we have a phone number and country name UITextFields and a button for allowing us to go ahead with the further process. We want to disable that button until we have enough digits of a phone number and the correct country. We can easily achieve this by using the .combineLatest operator.

6. zip
It works similar to the .combineLatest but in this case, it emits a tuple of paired values in the same indexes only after each publisher has emitted a value at the current index.

![image](https://github.com/nbnitin/CombineUIKit/assets/5785670/2fde7b54-6b67-445a-9f4a-5176edb1ea39)
Let’s understand it with an example.

let subject1 = PassthroughSubject<String, Never>()
let subject2 = PassthroughSubject<String, Never>()
subject1
    .zip(subject2)
    .sink(receiveValue: { (string1, string2) in
        print("String1: \(string1), String2: \(string2)")
    })
    .store(in: &subscriptions)
subject1.send("Hello")
subject1.send("World")
subject2.send("Nice")
subject1.send("Cool")
subject2.send("Rock")
subject2.send("Cool")
subject2.send("Awesome")
Output:
String1: Hello, String2: Nice
String1: World, String2: Rock
String1: Cool, String2: Cool

As shown here, only two zipped items are emitted from the resulting publisher as subject1 has only 3 items. That’s why the Awesome value is not printed, because there’s no item to pair it with in subject1.

7. map
As the name suggests, this operator maps or transforms the elements a publisher emits.

  ![image](https://github.com/nbnitin/CombineUIKit/assets/5785670/913276da-6119-4ed7-a62e-a7629060c442)


It uses a closure to transform each element it receives from the upstream publisher. We can use map(_:) to transform from one kind of element to another.

Let’s understand it with an example.

[10, 20, 30]
   .publisher
   .map { $0 * 2 }
   .sink { print($0) }
Output:
20
40
60
Here, we can see that publisher values are mapped one by one and are multiplied by two as we specified.

8. collect
It is a powerful operator that allows us to receive all items at once from a publisher. It collects all received elements and emits a single array of the collection when the upstream publisher finishes.

  ![image](https://github.com/nbnitin/CombineUIKit/assets/5785670/97674afd-ed12-4076-89e5-d75208b30b9f)


Let’s understand it with an example.

[1, 2, 3, 4].publisher
    .collect()
    .sink { (output) in
        print(output)
    }.store(in: &subscriptions)
Output:
[1, 2, 3, 4]
Here, we can see that publisher values are displayed as a single element.

Note: If we don’t use .collect() operator here then it will simply print as a separate element in a new line instead of a single array.

9. Reduce
This operator iteratively accumulates a new value based on the emissions of the upstream publisher.

![image](https://github.com/nbnitin/CombineUIKit/assets/5785670/01e94b52-a111-43da-8ba4-1d3400a49c71)
  


It returns the publisher that applies the closure to all received elements and produces an accumulated value when the upstream publisher finishes.

Let’s understand it with an example.

let publisher = ["Hello!", " ", "How ", "Are ", "You?"].publisher
publisher
    .reduce("👋🏻 ", +)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
Output:
👋🏻 Hello! How Are You?
Here we can see that it reduces the separate array elements in a single element by prepending all values.

10. Debounce
It waits for a specific time span from the emission of the last value before emitting the last value received.

![image](https://github.com/nbnitin/CombineUIKit/assets/5785670/9c343738-45d5-459f-9f44-b30d9170bba7)

For example, we are implementing search in our app and we only want to fire a search query if the user does not type for 500ms, otherwise, we may have too many unwanted query call continuously along with the user type any single character in the search box.

So, we can do this as given in the following example,

let bounces: [(Int, TimeInterval)] = [
    (0, 0),
    (1, 0.25),  // 0.25s interval since last index
    (2, 1),     // 0.75s interval since last index
    (3, 1.25),  // 0.25s interval since last index
    (4, 1.5),   // 0.25s interval since last index
    (5, 2)      // 0.5s interval since last index
]
let subject = PassthroughSubject<Int, Never>()
subject
    .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
for bounce in bounces {
    DispatchQueue.main.asyncAfter(deadline: .now() + bounce.1) {
        subject.send(bounce.0)
    }
}
Output:
1
4
5
Here, some indexes are waiting until the debounce period ends and after its completion, they again start publishing the index.

11. Throttle
Throttle works similar to Debounce, but it waits for the specified interval repeatedly, and at the end of each interval, it will emit either the first or the last of the values depending on what is passed for its latest parameter.

![image](https://github.com/nbnitin/CombineUIKit/assets/5785670/fcb332c3-a0b6-411f-930a-497e2b74772f)

In short, throttle does not pause after receiving values.

Let’s understand it with an example.

let bounces: [(Int, TimeInterval)] = [
    (0, 0), (1, 1), (2, 1.1), (3, 1.2), (4, 1.3), (5, 2)
]
let subject = PassthroughSubject<Int, Never>()
subject
    .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: false)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
for bounce in bounces {
    DispatchQueue.main.asyncAfter(deadline: .now() + bounce.1) {
        subject.send(bounce.0)
    }
}
Output:
0
1
2
5
Here, values of index 2, 3, and 4 are emitted in the given interval, so it took the very first emitted value from three of them which is 2, and then took the next value which is of the next interval.

After each given interval, throttle sends the first value it received during that interval.



