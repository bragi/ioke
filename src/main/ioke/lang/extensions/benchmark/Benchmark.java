/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang.extensions.benchmark;

import ioke.lang.Runtime;
import ioke.lang.IokeObject;
import ioke.lang.JavaMethod;
import ioke.lang.Message;
import ioke.lang.Number;

import ioke.lang.exceptions.ControlFlow;

/**
 *
 * @author <a href="mailto:ola.bini@gmail.com">Ola Bini</a>
 */
public abstract class Benchmark {
    private Benchmark() {}

    public static IokeObject create(Runtime runtime) {
        IokeObject bm = new IokeObject(runtime, "Benchmark is a module that makes it easy to test the time code takes to run");
        Benchmark.init(bm);
        return bm;
    }

    public static void init(IokeObject bm) {
        Runtime runtime = bm.runtime;
        bm.setKind("Benchmark");
        runtime.ground.setCell("Benchmark", bm);
        
        bm.registerMethod(runtime.newJavaMethod("expects two optional numbers, x (default 10) and y (default 1), and a block of code to run, and will run benchmark this block x times, while looping y times in each benchmark. after each loop will print the timings for this loop", new JavaMethod("report") {
                @Override
                public Object activate(IokeObject method, IokeObject context, IokeObject message, Object on) throws ControlFlow {
                    int count = message.getArgumentCount();
                    int bmRounds = 10;
                    long iterations = 1;
                    int index = 0;
                    if(count > 1) {
                        bmRounds = ((Number)IokeObject.convertToNumber(message.getEvaluatedArgument(index, context), message, context).data).asJavaInteger();
                        index++;
                        if(count > 2) {
                            iterations = ((Number)IokeObject.convertToNumber(message.getEvaluatedArgument(index, context), message, context).data).asJavaLong();
                            index++;
                        }
                    }

                    for(int i=0;i<bmRounds;i++) {
                        long before = System.nanoTime();
                        for(int j=0;j<iterations;j++) {
                            message.getEvaluatedArgument(index, context);
                        }
                        long after = System.nanoTime();
                        long time = after-before;
                        long secs = time/1000000000;
                        long rest = time%1000000000;
                        context.runtime.getOut().println(String.format("%-32.32s %.6s.%09d", Message.thisCode(((IokeObject)message.getArguments().get(index))), secs, rest));
                        context.runtime.getOut().flush();
                    }

                    return context.runtime.nil;
                }
            }));
    }
}// Benchmark