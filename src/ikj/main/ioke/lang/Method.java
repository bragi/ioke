/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import ioke.lang.exceptions.ControlFlow;

/**
 *
 * @author <a href="mailto:ola.bini@gmail.com">Ola Bini</a>
 */
public class Method extends IokeData implements Named, Inspectable {
    String name;

    public Method(String name) {
        this.name = name;
    }

    public Method(IokeObject context) {
        this((String)null);
    }
    
    @Override
    public void init(IokeObject method) throws ControlFlow {
        method.setKind("Method");
        method.registerCell("activatable", method.runtime._true);

        method.registerMethod(method.runtime.newNativeMethod("returns the name of the method", new NativeMethod.WithNoArguments("name") {
                @Override
                public Object activate(IokeObject self, IokeObject context, IokeObject message, Object on) throws ControlFlow {
                    getArguments().getEvaluatedArguments(context, message, on, new ArrayList<Object>(), new HashMap<String, Object>());

                    return context.runtime.newText(((Method)IokeObject.data(on)).name);
                }
            }));
        method.registerMethod(method.runtime.newNativeMethod("Returns a text inspection of the object", new NativeMethod.WithNoArguments("inspect") {
                @Override
                public Object activate(IokeObject self, IokeObject context, IokeObject message, Object on) throws ControlFlow {
                    getArguments().getEvaluatedArguments(context, message, on, new ArrayList<Object>(), new HashMap<String, Object>());

                    return context.runtime.newText(Method.getInspect(on));
                }
            }));
        method.registerMethod(method.runtime.newNativeMethod("Returns a brief text inspection of the object", new NativeMethod.WithNoArguments("notice") {
                @Override
                public Object activate(IokeObject self, IokeObject context, IokeObject message, Object on) throws ControlFlow {
                    getArguments().getEvaluatedArguments(context, message, on, new ArrayList<Object>(), new HashMap<String, Object>());

                    return context.runtime.newText(Method.getNotice(on));
                }
            }));
        method.registerMethod(method.runtime.newNativeMethod("activates this method with the arguments given to call", new NativeMethod("call") {
                private final DefaultArgumentsDefinition ARGUMENTS = DefaultArgumentsDefinition
                    .builder()
                    .withRestUnevaluated("arguments")
                    .getArguments();

                @Override
                public DefaultArgumentsDefinition getArguments() {
                    return ARGUMENTS;
                }

                @Override
                public Object activate(IokeObject self, IokeObject context, IokeObject message, Object on) throws ControlFlow {
                    return IokeObject.as(on, context).activate(context, message, context.getRealContext());
                }
            }));

        method.registerMethod(method.runtime.newNativeMethod("returns the full code of this method, as a Text", new NativeMethod.WithNoArguments("code") {
                @Override
                public Object activate(IokeObject self, IokeObject dynamicContext, IokeObject message, Object on) throws ControlFlow {
                    getArguments().getEvaluatedArguments(dynamicContext, message, on, new ArrayList<Object>(), new HashMap<String, Object>());

                    IokeData data = IokeObject.data(on);
                    if(data instanceof Method) {
                        return dynamicContext.runtime.newText(((Method)data).getCodeString());
                    } else {
                        return dynamicContext.runtime.newText(((AliasMethod)data).getCodeString());
                    }
                }
            }));
    }

    public String getName() {
        return name;
    }

    public String getCodeString() {
        return "method(nil)";
    }

    public void setName(String name) {
        this.name = name;
    }
    
    public Object errorNotActivatableCondition(IokeObject method, IokeObject context, IokeObject message, Object on)  throws ControlFlow {
    	return context.runtime.errorNotActivatableCondition(method, context, message, on, 
    			"You tried to activate a method without any code - did you by any chance activate the Method kind by referring to it without wrapping it inside a call to cell?");
    }

    @Override
    public Object activate(IokeObject method, IokeObject context, IokeObject message, Object on) throws ControlFlow {
        return errorNotActivatableCondition(method, context, message, on);
    }

    public static String getInspect(Object on) {
        return ((Inspectable)(IokeObject.data(on))).inspect(on);
    }

    public static String getNotice(Object on) {
        return ((Inspectable)(IokeObject.data(on))).notice(on);
    }

    public String inspect(Object self) {
        return getCodeString();
    }

    public String notice(Object self) {
        if(name == null) {
            return "method(...)";
        } else {
            return name + ":method(...)";
        }
    }
    
    public String getDefaultDocumentation() {
      return null;
    }
}// Method
