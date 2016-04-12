/**
 * Copyright (C) 2012 Digital Primates
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **/
package com.mbxdigital.ane.TorchControl
{
	// import com.mbxdigital.ane.TorchControl.events.TorchControlEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	/**
	 * A controller used to interact with the system volume on iOS and
	 * Android devices.  Ways to change the volume programmatically
	 * and to respond to the hardware volume buttons are included.
	 *  
	 * @author Nathan Weber
	 */	
	public class TorchControlController extends EventDispatcher
	{
		//----------------------------------------
		//
		// Variables
		//
		//----------------------------------------
		
		private static var _instance:TorchControlController;
		private var extContext:ExtensionContext;
		
		//----------------------------------------
		//
		// Properties
		//
		//----------------------------------------
		
		private var _systemVolume:Number = NaN;
		
		public function get systemVolume():Number {
			return _systemVolume;
		}
		
		public function set systemVolume( value:Number ):void {
			if ( _systemVolume == value ) {
				return;
			}
			
			_systemVolume = value;
		}
		
		//----------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------
		
		public static function get instance():TorchControlController {
			if ( !_instance ) {
				_instance = new TorchControlController( new SingletonEnforcer() );
				_instance.init();
			}
			
			return _instance;
		}
		
		/**
		 * Changes the device's system volume.
		 *  
		 * @param newVolume The new system volume.  This value should be between 0 and 1.
		 */		
		public function setTorch( newVolume:Number ):void {
			if ( isNaN(newVolume) )  {
				newVolume = 1;
			}
			
			if ( newVolume < 0 ) {
				newVolume = 0;
			}
			
			if ( newVolume > 1 ) {
				newVolume = 1;
			}
			
			extContext.call( "setTorchLevel", newVolume );
			
			systemVolume = newVolume;
		}
		
		/**
		 * Cleans up the instance of the native extension. 
		 */		
		public function dispose():void { 
			extContext.dispose(); 
		}
		
		//----------------------------------------
		//
		// Handlers
		//
		//----------------------------------------
		
		private function init():void {
			extContext.call( "init" );
		}
		
		//----------------------------------------
		//
		// Handlers
		//
		//----------------------------------------
		
		// Handle feedback from the ane
		private function onStatus( event:StatusEvent ):void {
			systemVolume = Number(event.level);
//			dispatchEvent( new TorchControlEvent( TorchControlEvent.VOLUME_CHANGED, systemVolume, false, false ) );
		}
		
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------
		
		/**
		 * Constructor. 
		 */		
		public function TorchControlController( enforcer:SingletonEnforcer ) {
			super();
			
			extContext = ExtensionContext.createExtensionContext( "com.mbxdigital.ane.TorchControl", "" );
			
			if ( !extContext ) {
				throw new Error( "Volume native extension is not supported on this platform." );
			}
			
			// Don't care about feedback so don't listen for anything...
			// extContext.addEventListener( StatusEvent.STATUS, onStatus );
		}
	}
}

class SingletonEnforcer {
	
}