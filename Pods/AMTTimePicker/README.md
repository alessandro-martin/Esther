AMTTimePicker
=============

A UIPickerView subclass helpful to pick time intervals in Days, Hours and Minutes

##How to use it

Import "AMTTimePicker.h" and conform to the "AMTTimePickerDelegate" protocol which features just one @required method which has the following signature:

- (void) amtTimePicker:(__unused AMTTimePicker *)picker
		 didSelectTime:(NSTimeInterval)timeInterval

This method will fire every time a new value is selected passing to the "deleguee" the current time interval in seconds.
Of course the user will have to set the appropriate delegate programmatically or in Interface Builder.

If the user wishes to instantiate the picker programmatically, the designated initializer is:

- (instancetype)initWithMaxDays:(NSUInteger)days

Note that days has to be greater than 0, otherwise the default value of 45 will be used.

If the user wants to set the picker to a certain value she can send the message:

- (void) setTimeInterval:(NSTimeInterval)timeInterval

Once again, NSTimeInterval is in seconds.

##Install instructions

Just use cocoapods and add

- pod 'AMTTimePicker'

to your podfile.

Of course you may also add the library manually, in which case you'll have to import the library with double quotes; use angle brackets if you install the pod.




