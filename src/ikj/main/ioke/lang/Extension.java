/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang;

import ioke.lang.IokeObject;
import ioke.lang.Runtime;
import ioke.lang.Text;
import ioke.lang.TypeCheckingArgumentsDefinition;
import ioke.lang.TypeCheckingNativeMethod;
import ioke.lang.exceptions.ControlFlow;
import java.util.List;
import java.util.Map;

/**
 * Manages native Java extensions for Ioke.
 *
 * @author <a href="mailto:bragi@ragnarson.com">Łukasz Piestrzeniewicz</a>
 */
public class Extension {

    static void init(IokeObject extension) throws ControlFlow {
        final Runtime runtime = extension.runtime;
        extension.setKind("Extension");
        extension.mimicsWithoutCheck(IokeObject.as(runtime.defaultBehavior, null));

        extension.registerMethod(runtime.newNativeMethod("naively registers a native Java extension with given class name. should not be used directly, rather register method should be used", new TypeCheckingNativeMethod("_register") {

            private final TypeCheckingArgumentsDefinition ARGUMENTS = TypeCheckingArgumentsDefinition.builder().withRequiredPositional("className").whichMustMimic(runtime.text).getArguments();

            @Override
            public TypeCheckingArgumentsDefinition getArguments() {
                return ARGUMENTS;
            }

            @Override
            public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                Object arg = args.get(0);
                String className = Text.getText(arg);
                Class<?> c = null;
                try {
                    c = context.runtime.classRegistry.getClassLoader().loadClass(className);
                    ((ioke.lang.extensions.Extension) c.newInstance()).init(runtime);
                } catch (Exception e) {
                    runtime.reportNativeException(e, message, context);
                }
                return runtime._true;
            }
        }));
    }
}
