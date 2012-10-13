# RAReactionKit

Reactions for Cocoa Touch.  Includes Bindings, Observations, and Deallocation Monitors.  Spliced from [IRFoundations](http://github.com/iridia/IRFoundations).


## Using RAReactionKit

There are three major parts of the Reaction Kit: **Bindings**, **Observings**, and **Deallocation Monitors**.  The entire project is built upon ARC and mandates support for weak references.  It does not swizzle your `-dealloc` methods, and work nicely with `NSManagedObject` instances.

### Bindings

In `NSObject+RABindings.h` you’ll find these methods added to `NSObject`:

	- (void) ra_bind:(NSString *)aKeyPath toObject:(id)anObservedObject keyPath:(NSString *)remoteKeyPath options:(NSDictionary *)options;
	- (void) ra_unbind:(NSString *)aKeyPath;

For now, the binding is **strictly one-way**.  Two-way bindings are very interesting to have, though.  :)

You use the binding mechanism like this:

	[cell ra_bind:@"someView.elements" 
		toObject:modelObject 
		keyPath:@"someOtherElements"
		options:@{
			RABindingsMainQueueGravityOption: @YES
	}];

There are currently two options keys:

*	**RABindingsMainQueueGravityOption**: If it is set to `@YES`, `RABindings` will take care to asynchronously set the value on the receiver from the main queue.  If you have an non-atomic object that gets hit from all the places (mediated with a serial dispatch queue), this can be handy.

*	**RABindingsValueTransformerOption**: You can pass a `RABindingsValueTransformer` block:

		typedef id (^RABindingsValueTransformer) (NSDictionary *change, NSKeyValueChange kind, id fromValue, id toValue);
	
	This allows you to do some very cheap value transforming, for example between `NSDate` and `NSString`.


### Observings

In `NSObject+RAObservings.h` you’ll find a bunch of methods added to `NSObject`:

	- (id) ra_observe:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context withBlock:(RAObservingsCallback)block;
	
	- (void) ra_removeObservingsHelper:(id)aHelper;
	- (void) ra_removeObserverBlocksForKeyPath:(NSString *)keyPath;
	- (void) ra_removeObserverBlocksForKeyPath:(NSString *)keyPath context:(void *)context;
	
	- (NSMutableArray *) ra_observingsHelperBlocksForKeyPath:(NSString *)aKeyPath;
	
	- (void) ra_observeObject:(id)target keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context withBlock:(RAObservingsCallback)block;

The main reason for exposure are two-fold:

*	The code was written by a more naïve version of myself
*	Observings are assumed to be frequently made and broken.

You use the Observing mechanism by invoking `ra_observe:options:context:withBlock:`.  It spins up a temporary, private KVO listener which forwards incoming communication from the Key-Value Binding mechanism to your handler block.


### Deallocation Monitors

The Deallocation Monitor is provided in `NSObject+RALifetimeHelper.h`:

	- (void) ra_performOnDeallocation:(void(^)(void))aBlock;
	
If you pass a block to `-ra_performOnDeallocation:`, the block will be called when the object is deallocated.

Please note that for static NSString instances (the `@""` string literals you specified in code), or special cases like `@YES` and `@NO`, they will never be deallocated.

If you have zombies on, nothing will be deallocated — as well.


## Licensing

This project is in the public domain.  You can use it and embed it in whatever application you sell, and you can use it for evil.  However, it is appreciated if you provide attribution, by linking to the project page ([https://github.com/evadne/RAReactionKit](https://github.com/evadne/RAReactionKit)) from your application.


## Credits

*	[Evadne Wu](http://twitter.com/evadne) at Radius ([Info](http://radi.ws))