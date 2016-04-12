# TorchControl-ANE

Control the camera LED / Torch brightness on iOS devices.

Allows setting of them at a 0-1 level where supported.

Alpha version that works for my purposes, use at your own risk!

# Usage
Grab the ane file from /build

Install ANE into your project in the usual way (look for other tutorials online for this.)


Then something like:
```
var _lamp:TorchControlController;	
public function Main()
{
	super();

	_lamp = TorchControlController.instance;
	_lamp.setTorch(0.5);
}
```

setTorch(Number) accepts a value from 0 to 1 with 0 being off and 1 being full.

## Notes
This is only available for iOS devices with a torch (LED) on the camera. Android does not support levels of brightness unfortunately.

The variance in output is not great... a setting of 0.001 is still pretty bright. As far as I am aware this cannot be set to be any lower.