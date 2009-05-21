/*
 * Adds a single method to Text mimic.
 */

package ioke.lang.test;

import ioke.lang.IokeObject;
import ioke.lang.NativeMethod;
import ioke.lang.Runtime;
import ioke.lang.exceptions.ControlFlow;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author bragi
 */
public class TextExtension implements ioke.lang.extensions.Extension {

    public void init(final Runtime runtime) throws ControlFlow {
        runtime.text.registerMethod(runtime.newNativeMethod("Native extension method always returning true", new NativeMethod.WithNoArguments("extended_via_native_extension?") {
                @Override
                public Object activate(IokeObject method, IokeObject context, IokeObject message, Object on) throws ControlFlow {
                    getArguments().getEvaluatedArguments(context, message, on, new ArrayList<Object>(), new HashMap<String, Object>());
                    return runtime._true;
                }
        }));
        
    }

}
