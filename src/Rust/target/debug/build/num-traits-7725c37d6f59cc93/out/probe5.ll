; ModuleID = 'probe5.4e658dc1-cgu.0'
source_filename = "probe5.4e658dc1-cgu.0"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@alloc_7fedfd5467b2336d7f072a28077fddf9 = private unnamed_addr constant <{ [75 x i8] }> <{ [75 x i8] c"/rustc/4a04d086cac54a41517d5657b59d5fe2caca2d71\\library\\core\\src\\num\\mod.rs" }>, align 1
@alloc_4f10f9d282e39f619e1019939603b4b9 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_7fedfd5467b2336d7f072a28077fddf9, [16 x i8] c"K\00\00\00\00\00\00\00/\04\00\00\05\00\00\00" }>, align 8
@str.0 = internal constant [25 x i8] c"attempt to divide by zero"

; probe5::probe
; Function Attrs: uwtable
define void @_ZN6probe55probe17hb1c6fdb69727971aE() unnamed_addr #0 {
start:
  %0 = call i1 @llvm.expect.i1(i1 false, i1 false)
  br i1 %0, label %panic.i, label %"_ZN4core3num21_$LT$impl$u20$u32$GT$10div_euclid17h498e4155c2734487E.exit"

panic.i:                                          ; preds = %start
; call core::panicking::panic
  call void @_ZN4core9panicking5panic17hdaae6108b852b6e5E(ptr align 1 @str.0, i64 25, ptr align 8 @alloc_4f10f9d282e39f619e1019939603b4b9) #3
  unreachable

"_ZN4core3num21_$LT$impl$u20$u32$GT$10div_euclid17h498e4155c2734487E.exit": ; preds = %start
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare i1 @llvm.expect.i1(i1, i1) #1

; core::panicking::panic
; Function Attrs: cold noinline noreturn uwtable
declare void @_ZN4core9panicking5panic17hdaae6108b852b6e5E(ptr align 1, i64, ptr align 8) unnamed_addr #2

attributes #0 = { uwtable "target-cpu"="x86-64" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(none) }
attributes #2 = { cold noinline noreturn uwtable "target-cpu"="x86-64" }
attributes #3 = { noreturn }

!llvm.module.flags = !{!0}

!0 = !{i32 8, !"PIC Level", i32 2}
