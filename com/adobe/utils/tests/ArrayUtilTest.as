/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.adobe.utils.tests
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import com.adobe.utils.ArrayUtil;

	public class ArrayUtilTest extends TestCase
	{	
		private var o:Object;
		private var arr:Array;
		
	    public function ArrayUtilTest(methodName:String = null)
        {
            super(methodName);
            
			o = {foo:"bar"};
			
			arr = new Array();
				arr.push("AAA");//0
				arr.push(5);//1
				arr.push("5");//2
				arr.push({foo:"bar"});//3
				arr.push(o);//4
				arr.push(new String("AAA"));//5
				arr.push("AAA");//6    
				arr.push("10");//7        
        }
		
		public function testArraysAreEqual():void
		{
			var arr2:Array = ArrayUtil.copyArray(arr);
			
			assertTrue("ArrayUtil.arraysAreEqual(arr, arr2)",
											ArrayUtil.arraysAreEqual(arr, arr2));
											
			assertTrue("!ArrayUtil.arraysAreEqual(arr, new Array())",
											!ArrayUtil.arraysAreEqual(arr, new Array()));
											
			var tArr:Array = new Array(arr.length);						
											
			assertTrue("!ArrayUtil.arraysAreEqual(arr, tArr)",
											!ArrayUtil.arraysAreEqual(arr, tArr));
		}		
		
		public function testCreateUniqueCopy():void
		{
			var arr2:Array = ArrayUtil.copyArray(arr);
			
			var arr3:Array = ArrayUtil.createUniqueCopy(arr2);
			
			assertTrue("arr3.length == 6", arr3.length == 6);
			assertTrue("arr3.length != arr2.length", arr3.length != arr2.length);
			
			var indexArr:Array = [0,1,2,3,4,7];
			
			var len:uint = arr3.length;
			
			for(var i:Number = 0; i < len; i++)
			{
				assertTrue("arr3["+i+"] === arr[indexArr["+i+"]]", arr3[i] === arr[indexArr[i]]);
			}
		}
		
		public function testCopyArray():void
		{
			var len:uint = arr.length;
			var arr2:Array = ArrayUtil.copyArray(arr);
			
			
			var len2:uint = arr2.length;
			
			assertTrue("len2 == arr.length", len2 == arr.length);
			
			for(var i:uint = 0; i < len2; i++)
			{
				assertTrue("arr["+i+"] == arr2["+i+"]", arr[i] == arr2[i]);
			}
			
			ArrayUtil.removeValueFromArray(arr2, "AAA");
			
			assertTrue("arr.length == len", arr.length == len);
		}		
		
		public function testRemoveValueFromArray():void
		{
			var arr2:Array = ArrayUtil.copyArray(arr);
			
			var len2:Number = arr2.length;
			
			ArrayUtil.removeValueFromArray(arr2, o);
			
			assertNotNull("arr2 is null", arr2);
			assertTrue("(len2 - 1) == arr2.length", (len2 - 1) == arr2.length);
			assertTrue("arr2[4] != o", arr2[4] != o);
			
			assertTrue("!ArrayUtil.arrayContainsValue(arr3, o)",
									!ArrayUtil.arrayContainsValue(arr2, o));			
			
			var arr3:Array = ArrayUtil.copyArray(arr);
			var len3:Number = arr3.length;
			
			ArrayUtil.removeValueFromArray(arr3, "AAA");	
			
			assertTrue("arr3.length == (len3 - 3)", arr3.length == (len3 - 3));
			assertTrue("!ArrayUtil.arrayContainsValue(arr3, \"AAA\")",
									!ArrayUtil.arrayContainsValue(arr3, "AAA"));
									
			var arr4:Array = ArrayUtil.copyArray(arr);
			var len4:Number = arr4.length;
			
			ArrayUtil.removeValueFromArray(arr3, "XHJSDHKJHKJSD");	
			
			assertTrue("len4 == arr4.length", len4 == arr4.length);
				
		}

		public function testArrayContainsValue():void
		{
			
			assertTrue("ArrayUtil.arrayContainsValue(arr, \"AAA\")",
									ArrayUtil.arrayContainsValue(arr, "AAA"));
										
			assertTrue("ArrayUtil.arrayContainsValue(arr, 5)",
										ArrayUtil.arrayContainsValue(arr, 5));
										
			assertTrue("!ArrayUtil.arrayContainsValue(arr, new Object())",
							!ArrayUtil.arrayContainsValue(arr, new Object()));
										
			assertTrue("ArrayUtil.arrayContainsValue(arr, o)",
										ArrayUtil.arrayContainsValue(arr, o));
										
			assertTrue("!ArrayUtil.arrayContainsValue(arr, {foo:\"bar\"})",
							!ArrayUtil.arrayContainsValue(arr, {foo:"bar"}));		
							
			assertTrue("!ArrayUtil.arrayContainsValue(arr, 10)", 
										!ArrayUtil.arrayContainsValue(arr, 10));
		}

	}
}