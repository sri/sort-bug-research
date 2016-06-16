# sort-bug-research
Research for https://github.com/sri/jruby-sort-benchmark

See sort_bug.rb show the sort bug.

**TLDR: Java's Arrays.sort does the Right Thing, but JRuby doesn't use it and uses its own hand-rolled sort method.**

1. Java's `Arrays.sort` does the right thing and throws a "Comparison method violates its general contract!" exception. When I modified JRuby's `RubyArray.java` to use this sort method instead of its own, this error was thrown.
2. Python & Golang completes the sort successfully. See reference implementation below.
3. JRuby (1.7.22 & 9.1.0.0) both get stuck in an infinite loop. Unfortunately, JRuby doesn't use Java's `Arrays.sort` and instead uses its own version:

###### JRuby's implementation

1. https://github.com/jruby/jruby/blob/master/core/src/main/java/org/jruby/util/Qsort.java
2. Qsort is used here: https://github.com/jruby/jruby/blob/master/core/src/main/java/org/jruby/RubyArray.java#L3278 and https://github.com/jruby/jruby/blob/master/core/src/main/java/org/jruby/RubyArray.java#L3313
3. Compare the above the Java's builtin sort to see how much more readable and defensive it is: https://github.com/openjdk-mirror/jdk7u-jdk/blob/master/src/share/classes/java/util/TimSort.java#L748
4. Converting JRuby to use Java's native sort `Arrays.sort` throws this error:

```
Unhandled Java exception: java.lang.IllegalArgumentException: Comparison method violates its general contract!
java.lang.IllegalArgumentException: Comparison method violates its general contract!
              mergeLo at java/util/TimSort.java:777
              mergeAt at java/util/TimSort.java:514
        mergeCollapse at java/util/TimSort.java:439
                 sort at java/util/TimSort.java:245
                 sort at java/util/Arrays.java:1512
         sortInternal at org/jruby/RubyArray.java:3283
            sort_bang at org/jruby/RubyArray.java:3265
                 sort at org/jruby/RubyArray.java:3249
                 call at org/jruby/internal/runtime/methods/JavaMethod.java:309
         cacheAndCall at org/jruby/runtime/callsite/CachingCallSite.java:293
                 call at org/jruby/runtime/callsite/CachingCallSite.java:131
  invokeWithArguments at java/lang/invoke/MethodHandle.java:627
                 load at org/jruby/ir/Compiler.java:111
            runScript at org/jruby/Ruby.java:833
            runScript at org/jruby/Ruby.java:825
          runNormally at org/jruby/Ruby.java:760
          runFromMain at org/jruby/Ruby.java:579
        doRunFromMain at org/jruby/Main.java:425
          internalRun at org/jruby/Main.java:313
                  run at org/jruby/Main.java:242
                 main at org/jruby/Main.java:204
