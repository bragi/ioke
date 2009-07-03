/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang;

import java.math.BigDecimal;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;

import java.util.Arrays;
import java.util.Locale;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import ioke.lang.exceptions.ControlFlow;

import gnu.math.RatNum;

/**
 *
 * @author <a href="mailto:ola.bini@gmail.com">Ola Bini</a>
 */
public class Decimal extends IokeData implements Inspectable {
    private final static DecimalFormatSymbols SYMBOLS = new DecimalFormatSymbols(Locale.US);
    private final BigDecimal value;

    public Decimal(String textRepresentation) {
        this.value = new BigDecimal(textRepresentation).stripTrailingZeros();
    }

    public Decimal(BigDecimal value) {
        this.value = value;
    }

    public static Decimal decimal(String val) {
        return new Decimal(val);
    }

    public static Decimal decimal(RatNum val) {
        return new Decimal(val.asBigDecimal());
    }

    public static Decimal decimal(BigDecimal val) {
        return new Decimal(val);
    }

    public static BigDecimal value(Object number) {
        return ((Decimal)IokeObject.data(number)).value;
    }

    public String asJavaString() {
        DecimalFormat format = new DecimalFormat("0.0", SYMBOLS);
        format.setMaximumFractionDigits(340);
        return format.format(value);
    }

    @Override
    public String toString() {
        return asJavaString();
    }

    @Override
    public String toString(IokeObject obj) {
        return asJavaString();
    }

    @Override
    public IokeObject convertToDecimal(IokeObject self, IokeObject m, final IokeObject context, boolean signalCondition) throws ControlFlow {
        return self;
    }

    public static String getInspect(Object on) throws ControlFlow {
        return ((Decimal)(IokeObject.data(on))).inspect(on);
    }

    public String inspect(Object obj)  throws ControlFlow {
        return asJavaString();
    }

	public String notice(Object self) throws ControlFlow {
		return asJavaString();
	}

    @Override
    public void init(IokeObject obj) throws ControlFlow {
        final Runtime runtime = obj.runtime;
        final IokeObject decimal = obj;

        decimal.setKind("Number Decimal");
        runtime.decimal = decimal;

        decimal.registerMethod(runtime.newNativeMethod("Returns a text representation of the object", new NativeMethod.WithNoArguments("asText") {
                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                    return runtime.newText(on.toString());
                }
            }));

        decimal.registerMethod(obj.runtime.newNativeMethod(new CommonMethods.Inspect()));

        decimal.registerMethod(obj.runtime.newNativeMethod("Returns a brief text inspection of the object", new TypeCheckingNativeMethod.WithNoArguments("notice", decimal) {
                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                    return method.runtime.newText(Decimal.getInspect(on));
                }
            }));

        decimal.registerMethod(runtime.newNativeMethod("compares this number against the argument, true if this number is the same, otherwise false", new TypeCheckingNativeMethod("==") {
                private final TypeCheckingArgumentsDefinition ARGUMENTS = TypeCheckingArgumentsDefinition
                    .builder()
                    .receiverMustMimic(decimal)
                    .withRequiredPositional("other")
                    .getArguments();

                @Override
                public TypeCheckingArgumentsDefinition getArguments() {
                    return ARGUMENTS;
                }

                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                    Object arg = args.get(0);
                    if(IokeObject.data(arg) instanceof Number) {
                        return (Decimal.value(on).compareTo(Number.value(arg).asBigDecimal()) == 0) ? context.runtime._true : context.runtime._false;
                    } else if(IokeObject.data(arg) instanceof Decimal) {
                        return (Decimal.value(on).compareTo(Decimal.value(arg)) == 0) ? context.runtime._true : context.runtime._false;
                    } else {
                        return context.runtime._false;
                    }
                }
            }));

        decimal.registerMethod(runtime.newNativeMethod("compares this number against the argument, returning -1, 0 or 1 based on which one is larger. if the argument is a rational, it will be converted into a form suitable for comparing against a decimal, and then compared. if the argument is neither a Rational nor a Decimal, it tries to call asDecimal, and if that doesn't work it returns nil.", new TypeCheckingNativeMethod("<=>") {
                private final TypeCheckingArgumentsDefinition ARGUMENTS = TypeCheckingArgumentsDefinition
                    .builder()
                    .receiverMustMimic(decimal)
                    .withRequiredPositional("other")
                    .getArguments();

                @Override
                public TypeCheckingArgumentsDefinition getArguments() {
                    return ARGUMENTS;
                }

                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                    Object arg = args.get(0);

                    IokeData data = IokeObject.data(arg);
                    
                    if(data instanceof Number) {
                        return context.runtime.newNumber(Decimal.value(on).compareTo(Number.value(arg).asBigDecimal()));
                    } else {
                        if(!(data instanceof Decimal)) {
                            arg = IokeObject.convertToDecimal(arg, message, context, false);
                            if(!(IokeObject.data(arg) instanceof Decimal)) {
                                // Can't compare, so bail out
                                return context.runtime.nil;
                            }
                        }

                        if(on == context.runtime.decimal || arg == context.runtime.decimal) {
                            if(arg == on) {
                                return context.runtime.newNumber(0);
                            }
                            return context.runtime.nil;
                        }

                        return context.runtime.newNumber(Decimal.value(on).compareTo(Decimal.value(arg)));
                    }
                }
            }));

        decimal.registerMethod(runtime.newNativeMethod("returns the difference between this number and the argument. if the argument is a rational, it will be converted into a form suitable for subtracting against a decimal, and then subtracted. if the argument is neither a Rational nor a Decimal, it tries to call asDecimal, and if that fails it signals a condition.", new TypeCheckingNativeMethod("-") {
                private final TypeCheckingArgumentsDefinition ARGUMENTS = TypeCheckingArgumentsDefinition
                    .builder()
                    .receiverMustMimic(decimal)
                    .withRequiredPositional("subtrahend")
                    .getArguments();

                @Override
                public TypeCheckingArgumentsDefinition getArguments() {
                    return ARGUMENTS;
                }

                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                    Object arg = args.get(0);

                    IokeData data = IokeObject.data(arg);
                    
                    if(data instanceof Number) {
                        return context.runtime.newDecimal(Decimal.value(on).subtract(Number.value(arg).asBigDecimal()));
                    } else {
                        if(!(data instanceof Decimal)) {
                            arg = IokeObject.convertToDecimal(arg, message, context, true);
                        }

                        return context.runtime.newDecimal(Decimal.value(on).subtract(Decimal.value(arg)));
                    }
                }
            }));

        decimal.registerMethod(runtime.newNativeMethod("returns the sum of this number and the argument. if the argument is a rational, it will be converted into a form suitable for addition against a decimal, and then added. if the argument is neither a Rational nor a Decimal, it tries to call asDecimal, and if that fails it signals a condition.", new TypeCheckingNativeMethod("+") {
                private final TypeCheckingArgumentsDefinition ARGUMENTS = TypeCheckingArgumentsDefinition
                    .builder()
                    .receiverMustMimic(decimal)
                    .withRequiredPositional("addend")
                    .getArguments();

                @Override
                public TypeCheckingArgumentsDefinition getArguments() {
                    return ARGUMENTS;
                }

                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                    Object arg = args.get(0);

                    IokeData data = IokeObject.data(arg);
                    
                    if(data instanceof Number) {
                        return context.runtime.newDecimal(Decimal.value(on).add(Number.value(arg).asBigDecimal()));
                    } else {
                        if(!(data instanceof Decimal)) {
                            arg = IokeObject.convertToDecimal(arg, message, context, true);
                        }

                        return context.runtime.newDecimal(Decimal.value(on).add(Decimal.value(arg)));
                    }
                }
            }));

        decimal.registerMethod(runtime.newNativeMethod("returns the product of this number and the argument. if the argument is a rational, the receiver will be converted into a form suitable for multiplying against a decimal, and then multiplied. if the argument is neither a Rational nor a Decimal, it tries to call asDecimal, and if that fails it signals a condition.", new TypeCheckingNativeMethod("*") {
                private final TypeCheckingArgumentsDefinition ARGUMENTS = TypeCheckingArgumentsDefinition
                    .builder()
                    .receiverMustMimic(decimal)
                    .withRequiredPositional("multiplier")
                    .getArguments();

                @Override
                public TypeCheckingArgumentsDefinition getArguments() {
                    return ARGUMENTS;
                }

                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, IokeObject context, IokeObject message) throws ControlFlow {
                    Object arg = args.get(0);

                    IokeData data = IokeObject.data(arg);
                    
                    if(data instanceof Number) {
                        return context.runtime.newDecimal(Decimal.value(on).multiply(Number.value(arg).asBigDecimal()));
                    } else {
                        if(!(data instanceof Decimal)) {
                            arg = IokeObject.convertToDecimal(arg, message, context, true);
                        }

                        return context.runtime.newDecimal(Decimal.value(on).multiply(Decimal.value(arg)));
                    }
                }
            }));

        decimal.registerMethod(runtime.newNativeMethod("returns the quotient of this number and the argument.", new TypeCheckingNativeMethod("/") {
                private final TypeCheckingArgumentsDefinition ARGUMENTS = TypeCheckingArgumentsDefinition
                    .builder()
                    .receiverMustMimic(decimal)
                    .withRequiredPositional("divisor")
                    .getArguments();

                @Override
                public TypeCheckingArgumentsDefinition getArguments() {
                    return ARGUMENTS;
                }

                @Override
                public Object activate(IokeObject method, Object on, List<Object> args, Map<String, Object> keywords, final IokeObject context, IokeObject message) throws ControlFlow {
                    Object arg = args.get(0);

                    IokeData data = IokeObject.data(arg);
                    
                    if(data instanceof Number) {
                        return context.runtime.newDecimal(Decimal.value(on).divide(Number.value(arg).asBigDecimal()).stripTrailingZeros());
                    } else {
                        if(!(data instanceof Decimal)) {
                            arg = IokeObject.convertToDecimal(arg, message, context, true);
                        }

                        while(Decimal.value(arg).compareTo(BigDecimal.ZERO) == 0) {
                            final IokeObject condition = IokeObject.as(IokeObject.getCellChain(context.runtime.condition, 
                                                                                               message, 
                                                                                               context, 
                                                                                               "Error", 
                                                                                               "Arithmetic",
                                                                                               "DivisionByZero"), context).mimic(message, context);
                            condition.setCell("message", message);
                            condition.setCell("context", context);
                            condition.setCell("receiver", on);

                            final Object[] newCell = new Object[]{arg};

                            context.runtime.withRestartReturningArguments(new RunnableWithErrorCondition(condition), 
                                context,
                                new Restart.UseValueRestart(newCell));
                        
                            arg = newCell[0];
                        }

                        BigDecimal result = null;
                        try {
                            result = Decimal.value(on).divide(Decimal.value(arg));
                        } catch(ArithmeticException e) {
                            result = Decimal.value(on).divide(Decimal.value(arg), java.math.MathContext.DECIMAL128);
                        }
                        return context.runtime.newDecimal(result.stripTrailingZeros());
                    }
                }
            }));
    }
    
    @Override
    public boolean isEqualTo(IokeObject self, Object other) {
        return ((other instanceof IokeObject) && 
                (IokeObject.data(other) instanceof Decimal) 
                && ((self == self.runtime.decimal && other == self) ||
                    this.value.equals(((Decimal)IokeObject.data(other)).value)));
    }

    @Override
    public int hashCode(IokeObject self) {
        return this.value.hashCode();
    }
}// Decimal
