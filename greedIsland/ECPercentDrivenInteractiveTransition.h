// ECPercentDrivenInteractiveTransition.h
// ECSlidingViewController 2
//
// Copyright (c) 2013, Michael Enriquez (http://enriquez.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Used to create a percent-driven interactive transition. Analogous to `UIPercentDrivenInteractiveTransition` except that it is compatible with `ECSlidingViewController`.
 
 See `ECSlidingInteractiveTransition` as an example subclass that uses a panning gesture to drive the percentage.
 
 You can subclass `ECPercentDrivenInteractiveTransition`, but if you do so you must start each of your method overrides with a call to the super implementation of the method.
 */
@interface ECPercentDrivenInteractiveTransition : NSObject <UIViewControllerInteractiveTransitioning>

/**
 The animator object that will be percent-driven. The animation will be triggered when the interactive transition is triggered, but instead of playing from start to finish it will be controlled by the calls to `updateInteractiveTransition:`, `cancelInteractiveTransition`, and `finishInteractiveTransition`.
 */
@property (nonatomic, strong) id<UIViewControllerAnimatedTransitioning> animationController;

/**
 　过渡(指定的比例总体持续时间)完成。
 　　
 　　这个属性的值反映了最后一个值传递到“更新互动过渡:”方法。
 　　
 　　* / */
@property (nonatomic, assign, readonly) CGFloat percentComplete;

/**
 　　更新完成过渡的百分比。概括地说,这个方法是用来“擦洗播放头”定义的动画“animationController”。
 　　
 　　跟踪用户事件时,您的代码应该调用这个方法定期更新当前的进展完成过渡。在跟踪,如果交互跨一个阈值,你考虑表示完成或取消过渡,停止跟踪事件和调用finishInteractiveTransition或cancelInteractiveTransition方法。

 */
- (void)updateInteractiveTransition:(CGFloat)percentComplete;

/**
使动画定义的“animationController”玩从当前“percentComplete”百分之零。你必须调用这个方法或“finishInteractiveTransition”在互动,以确保一切都结束在一个一致的状态。
 */
- (void)cancelInteractiveTransition;

/**
 Causes the animation defined by the `animationController` to play from current `percentComplete` to 100 percent. You must call this method or `cancelInteractiveTransition` at some point during the interaction to ensure everything ends in a consistent state.
 */
- (void)finishInteractiveTransition;
@end
