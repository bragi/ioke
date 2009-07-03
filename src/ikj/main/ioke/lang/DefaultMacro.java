/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import ioke.lang.exceptions.ControlFlow;

/**
 *
 * @author <a href="mailto:ola.bini@gmail.com">Ola Bini</a>
 */
public class DefaultMacro extends IokeData implements Named, AssociatedCode {
    String name;
    private IokeObject code;

    public DefaultMacro(String name) {
        this.name = name;
    }

    public DefaultMacro(IokeObject context, IokeObject code) {
        this((String)null);

        this.code = code;
    }

    public IokeObject getCode() {
        return code;
    }

    public String getCodeString() {
        return "macro(" + Message.code(code) + ")";

    }

    public String getFormattedCode(Object self) throws ControlFlow {
        return "macro(\n  " + Message.formattedCode(code, 2, (IokeObject)self) + ")";
    }
    
    @Override
    public void init(IokeObject macro) throws ControlFlow {
        macro.setKind("DefaultMacro");
        macro.registerCell("activatable", macro.runtime._true);

        macro.registerMethod(macro.runtime.newNativeMethod("returns the name of the macro", new TypeCheckingNativeMethod.WithNoArguments("name", macro) {
                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                    return context.runtime.newText(((DefaultMacro)IokeObject.data(on)).name);
                }
            }));
        
        macro.registerMethod(macro.runtime.newNativeMethod("activates this macro with the arguments given to call", new NativeMethod("call") {
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
        
        macro.registerMethod(macro.runtime.newNativeMethod("returns the message chain for this macro", new TypeCheckingNativeMethod.WithNoArguments("message", macro) {
                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                    return ((AssociatedCode)IokeObject.data(on)).getCode();
                }
            }));
        
        macro.registerMethod(macro.runtime.newNativeMethod("returns the code for the argument definition", new TypeCheckingNativeMethod.WithNoArguments("argumentsCode", macro) {
                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                    return context.runtime.newText(((AssociatedCode)IokeObject.data(on)).getArgumentsCode());
                }
            }));
        
        macro.registerMethod(macro.runtime.newNativeMethod(new CommonMethods.Inspect()));
        
        macro.registerMethod(macro.runtime.newNativeMethod(new CommonMethods.Notice()));
        
        macro.registerMethod(macro.runtime.newNativeMethod("returns the full code of this macro, as a Text", new TypeCheckingNativeMethod.WithNoArguments("code", macro) {
                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                    IokeData data = IokeObject.data(on);

                    if(data instanceof DefaultMacro) {
                        return context.runtime.newText(((DefaultMacro)data).getCodeString());
                    } else {
                        return context.runtime.newText(((AliasMethod)data).getCodeString());
                    }
                }
            }));

        macro.registerMethod(macro.runtime.newNativeMethod("returns idiomatically formatted code for this macro", new TypeCheckingNativeMethod.WithNoArguments("formattedCode", macro) {
                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                    return context.runtime.newText(((AssociatedCode)IokeObject.data(on)).getFormattedCode(method));
                }
            }));
    }

    public String getArgumentsCode() {
        return "...";
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String inspect(Object self) {
        if(name == null) {
            return "macro(" + Message.code(code) + ")";
        } else {
            return name + ":macro(" + Message.code(code) + ")";
        }
    }

    public String notice(Object self) {
        if(name == null) {
            return "macro(...)";
        } else {
            return name + ":macro(...)";
        }
    }

    public Object errorNotActivatableCondition(IokeObject method, IokeObject context, IokeObject message, Object on)  throws ControlFlow {
    	return context.runtime.errorNotActivatableCondition(method, context, message, on,
    			"You tried to activate a method without any code - did you by any chance activate the DefaultMacro kind by referring to it without wrapping it inside a call to cell?");
    }

    @Override
    public Object activateWithCallAndData(final IokeObject self, IokeObject context, IokeObject message, Object on, Object call, Map<String, Object> data) throws ControlFlow {
        if(code == null) {
        	return errorNotActivatableCondition(self, context, message, on);
        }

        IokeObject c = context.runtime.locals.mimic(message, context);
        c.setCell("self", on);
        c.setCell("@", on);
        c.registerMethod(c.runtime.newNativeMethod("will return the currently executing macro receiver", new NativeMethod.WithNoArguments("@@") {
                @Override
                public Object activate(IokeObject method, IokeObject context, IokeObject message, Object on) throws ControlFlow {
                    getArguments().getEvaluatedArguments(context, message, on, new ArrayList<Object>(), new HashMap<String, Object>());
                    return self;
                }
            }));
        c.setCell("currentMessage", message);
        c.setCell("surroundingContext", context);
        if(call == null) {
        	c.setCell("call", context.runtime.newCallFrom(c, message, context, IokeObject.as(on, context)));
        } else {
            c.setCell("call", call);
        }
        if(data != null) {
            for(Map.Entry<String, Object> d : data.entrySet()) {
                String s = d.getKey();
                c.setCell(s.substring(0, s.length()-1), d.getValue());
            }
        }

        try {
            return ((Message)IokeObject.data(code)).evaluateCompleteWith(code, c, on);
        } catch(ControlFlow.Return e) {
            if(e.context == c) {
                return e.getValue();
            } else {
                throw e;
            }
        }
    }

    @Override
    public Object activateWithCall(final IokeObject self, IokeObject context, IokeObject message, Object on, Object call) throws ControlFlow {
    	return activateWithCallAndData(self, context, message, on, call, null);
    }

    @Override
    public Object activate(final IokeObject self, IokeObject context, IokeObject message, Object on) throws ControlFlow {
    	return activateWithCallAndData(self, context, message, on, null, null);
    }

    @Override
    public Object activateWithData(final IokeObject self, IokeObject context, IokeObject message, Object on, Map<String, Object> data) throws ControlFlow {
    	return activateWithCallAndData(self, context, message, on, null, data);
    }
}// DefaultMacro
