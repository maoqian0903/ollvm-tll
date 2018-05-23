; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mcpu=corei7 | FileCheck %s

declare i8 @llvm.ctpop.i8(i8) nounwind readnone
declare i64 @llvm.ctpop.i64(i64) nounwind readnone

define i32 @test1(i64 %x) nounwind readnone {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    leaq -1(%rdi), %rcx
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testq %rcx, %rdi
; CHECK-NEXT:    setne %al
; CHECK-NEXT:    retq
  %count = tail call i64 @llvm.ctpop.i64(i64 %x)
  %cast = trunc i64 %count to i32
  %cmp = icmp ugt i32 %cast, 1
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}


define i32 @test2(i64 %x) nounwind readnone {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    leaq -1(%rdi), %rcx
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testq %rcx, %rdi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %count = tail call i64 @llvm.ctpop.i64(i64 %x)
  %cmp = icmp ult i64 %count, 2
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @test3(i64 %x) nounwind readnone {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    popcntq %rdi, %rcx
; CHECK-NEXT:    andb $63, %cl
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    cmpb $2, %cl
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    retq
  %count = tail call i64 @llvm.ctpop.i64(i64 %x)
  %cast = trunc i64 %count to i6 ; Too small for 0-64
  %cmp = icmp ult i6 %cast, 2
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i8 @test4(i8 %x) nounwind readnone {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andl $127, %edi
; CHECK-NEXT:    popcntl %edi, %eax
; CHECK-NEXT:    # kill: def %al killed %al killed %eax
; CHECK-NEXT:    retq
  %x2 = and i8 %x, 127
  %count = tail call i8 @llvm.ctpop.i8(i8 %x2)
  %and = and i8 %count, 7
  ret i8 %and
}
