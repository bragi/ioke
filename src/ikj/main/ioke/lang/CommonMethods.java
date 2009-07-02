package ioke.lang;

import ioke.lang.exceptions.ControlFlow;

import java.util.ArrayList;
import java.util.HashMap;

public abstract class CommonMethods {
    public static String getInspect(Object on) throws ControlFlow {
        return ((Inspectable) (IokeObject.data(on))).inspect(on);
    }

    public static String getNotice(Object on) throws ControlFlow {
        return ((Inspectable) (IokeObject.data(on))).notice(on);
    }

    public static class Name extends NativeMethod.WithNoArguments {
        public Name() {
            super("name");
        }

        @Override
        public Object activate(IokeObject self, IokeObject context,
                IokeObject message, Object on) throws ControlFlow {
            getArguments().getEvaluatedArguments(context, message, on,
                    new ArrayList<Object>(), new HashMap<String, Object>());

            return context.runtime.newText(((Named) IokeObject.data(on))
                    .getName());
        }
    }

    public static class Inspect extends NativeMethod.WithNoArguments {
        public Inspect() {
            super("inspect");
        }

        @Override
        public String getDefaultDocumentation() {
            return "Returns a text inspection of the object";
        }

        @Override
        public Object activate(IokeObject self, IokeObject context,
                IokeObject message, Object on) throws ControlFlow {
            getArguments().getEvaluatedArguments(context, message, on,
                    new ArrayList<Object>(), new HashMap<String, Object>());

            return context.runtime.newText(CommonMethods.getInspect(on));
        }
    }

    public static class Notice extends NativeMethod.WithNoArguments {
        @Override
        public String getDefaultDocumentation() {
            return "Returns a brief text inspection of the object";
        }

        public Notice() {
            super("notice");
        }

        @Override
        public Object activate(IokeObject self, IokeObject context,
                IokeObject message, Object on) throws ControlFlow {
            getArguments().getEvaluatedArguments(context, message, on,
                    new ArrayList<Object>(), new HashMap<String, Object>());

            return context.runtime.newText(CommonMethods.getNotice(on));
        }
    }
}
