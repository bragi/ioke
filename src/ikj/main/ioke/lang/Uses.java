/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang;

import ioke.lang.exceptions.ControlFlow;
import ioke.lang.java.IokeClassLoader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Keeps track of files use()d in current runtime.
 *
 * @author <a href="mailto:bragi@ragnarson.com">Łukasz Piestrzeniewicz</a>
 */
public class Uses {

    private static final String[] SUFFIXES = {".ik", ".jar"};
    private static final String[] SUFFIXES_WITH_BLANK = {"", ".ik", ".jar"};
    private Set<String> loaded = new HashSet<String>();
    private IokeObject loadPath;
    private String currentWorkingDirectory;
    private boolean onWindows;
    private IokeClassLoader classLoader;

    public void setCurrentWorkingDirectory(String currentWorkingDirectory) {
        this.currentWorkingDirectory = currentWorkingDirectory;
    }

    public void setLoadPath(IokeObject loadPath) {
        this.loadPath = loadPath;
    }

    public void setClassLoader(IokeClassLoader classLoader) {
        this.classLoader = classLoader;
    }

    public void setOnWindows(boolean onWindows) {
        this.onWindows = onWindows;
    }

    public boolean isAbsoluteFileName(String name) {
        if (onWindows) {
            return name.length() > 2 && name.charAt(1) == ':' && name.charAt(2) == '\\';
        } else {
            return name.length() > 0 && name.charAt(0) == '/';
        }
    }

    public Uses() {
    }

    private void log(String message) {
        System.out.println(message);
    }
    
    private boolean restartLoadingCondition(IokeObject self, IokeObject context, IokeObject message, String name, Throwable e) throws ControlFlow {
        final Runtime runtime = self.runtime;

        final IokeObject condition = IokeObject.as(IokeObject.getCellChain(runtime.condition,
                message,
                context,
                "Error",
                "Load"), context).mimic(message, context);
        condition.setCell("message", message);
        condition.setCell("context", context);
        condition.setCell("receiver", self);
        condition.setCell("moduleName", runtime.newText(name));
        condition.setCell("exceptionMessage", runtime.newText(e.getMessage()));
        List<Object> ob = new ArrayList<Object>();
        for (StackTraceElement ste : e.getStackTrace()) {
            ob.add(runtime.newText(ste.toString()));
        }

        condition.setCell("exceptionStackTrace", runtime.newList(ob));

        final boolean[] continueLoadChain = new boolean[]{false};

        runtime.withRestartReturningArguments(new RunnableWithControlFlow() {

            public void run() throws ControlFlow {
                runtime.errorCondition(condition);
            }
        },
                context,
                new Restart.ArgumentGivingRestart("continueLoadChain") {

                    public List<String> getArgumentNames() {
                        return new ArrayList<String>();
                    }

                    public IokeObject invoke(IokeObject context, List<Object> arguments) throws ControlFlow {
                        continueLoadChain[0] = true;
                        return runtime.nil;
                    }
                },
                new Restart.ArgumentGivingRestart("ignoreLoadError") {

                    public List<String> getArgumentNames() {
                        return new ArrayList<String>();
                    }

                    public IokeObject invoke(IokeObject context, List<Object> arguments) throws ControlFlow {
                        continueLoadChain[0] = false;
                        return runtime.nil;
                    }
                });
        return ! !continueLoadChain[0];
    }
    
    private Builtin builtinForName(Runtime runtime, String name) {
    	return runtime.getBuiltin(name);
    }

    private boolean findBuiltin(IokeObject self, IokeObject context, IokeObject message, String name) throws ControlFlow {

    	Builtin b = builtinForName(context.runtime, name);

        if (loaded.contains(name)) {
            return false;
        } else {
            try {
                b.load(context.runtime, context, message);
                loaded.add(name);
                return true;
            } catch (Throwable e) {
                boolean result = restartLoadingCondition(self, context, message, name, e);
                if (!result) {
                    return false;
                }
            }
        }
        return true;
    }

    private String normalizedPath(String name, String suffix) {
        if(name.startsWith(("/"))) {
            return name + suffix;
        } else {
            return "/" + name + suffix;
        }
    }

    public boolean use(IokeObject self, IokeObject context, IokeObject message, String name) throws ControlFlow {
        final Runtime runtime = context.runtime;
        if(builtinForName(runtime, name) != null) {
        	return findBuiltin(self, context, message, name);
        }

        String[] suffixes = (name.endsWith(".ik") || name.endsWith(".jar")) ? SUFFIXES_WITH_BLANK : SUFFIXES;

        log("Trying absolute paths");

        // Absolute path
        for (String suffix : suffixes) {
            try {
                log("Trying to see if file " + name + suffix + " exists");
                File f = new File(name + suffix);

                if (f.exists() && f.isFile()) {
                    log("File " + name + suffix + " exists");
                    if (loaded.contains(f.getCanonicalPath())) {
                        log("File was already loaded as " + f.getCanonicalPath() + ", returning false");
                        return false;
                    } else {
                        log("File was not loaded before");
                        if (f.getCanonicalPath().endsWith(".jar")) {
                            log("File " + f.getCanonicalPath() + " is a jar, putting it in class path");
                            classLoader.addURL(f.toURI().toURL());
                        } else {
                            log("File " + f.getCanonicalPath() + "is not a jar, evaluating it now");
                            context.runtime.evaluateFile(f, message, context);
                        }

                        log("Adding file " + f.getCanonicalPath() + " to loaded files and returning true");
                        loaded.add(f.getCanonicalPath());
                        return true;
                    }
                }

                log("File " + name + suffix + " does not exist, trying resource " + normalizedPath(name, suffix));

                InputStream is = classLoader.getResourceAsStream(name + suffix);
                if (null != is) {
                    log("Resource " + name + suffix + " exists");
                    if (loaded.contains(name + suffix)) {
                        log("Resource " + name + suffix + " is loaded already");
                        return false;
                    } else {
                        if ((name + suffix).endsWith(".jar")) {
                            // load jar here - can't do it correctly at the moment, though.
                            log("Resource " + name + suffix + " is a jar, do not know how to load it");
                        } else {
                            log("Resource " + name + suffix + " is not a jar, evaluating it");
                            context.runtime.evaluateStream(name + suffix, new InputStreamReader(is, "UTF-8"), message, context);
                        }
                        log("Adding resource " + name + suffix + " to loaded files");
                        loaded.add(name + suffix);
                        return true;
                    }
                }
            } catch (Throwable e) {
                boolean result = restartLoadingCondition(self, context, message, name, e);
                if (!result) {
                    return false;
                }
            }
        }



        List<Object> paths = ((IokeList) IokeObject.data(loadPath)).getList();

        for (Object o : paths) {
            String currentS = Text.getText(o);

            for (String suffix : suffixes) {
                String before = "/";
                if (name.startsWith("/")) {
                    before = "";
                }

                InputStream is = IokeSystem.class.getResourceAsStream(before + name + suffix);
                try {
                    File f;

                    if (isAbsoluteFileName(currentS)) {
                        f = new File(currentS, name + suffix);
                    } else {
                        f = new File(new File(currentWorkingDirectory, currentS), name + suffix);
                    }

//                     System.err.println("trying: " + f);

                    if (f.exists() && f.isFile()) {
                        if (loaded.contains(f.getCanonicalPath())) {
                            return false;
                        } else {
                            if (f.getCanonicalPath().endsWith(".jar")) {
                                context.runtime.classRegistry.getClassLoader().addURL(f.toURI().toURL());
                            } else {
                                context.runtime.evaluateFile(f, message, context);
                            }

                            loaded.add(f.getCanonicalPath());
                            return true;
                        }
                    }

                    if (null != is) {
                        if (loaded.contains(name + suffix)) {
                            return false;
                        } else {
                            if ((name + suffix).endsWith(".jar")) {
                                // load jar here - can't do it correctly at the moment, though.
                            } else {
                                context.runtime.evaluateStream(name + suffix, new InputStreamReader(is, "UTF-8"), message, context);
                            }
                            loaded.add(name + suffix);
                            return true;
                        }
                    }
                } catch (Throwable e) {
                    boolean result = restartLoadingCondition(self, context, message, name, e);
                    if (!result) {
                        return false;
                    }
                }
            }
        }

        final IokeObject condition = IokeObject.as(IokeObject.getCellChain(runtime.condition,
                message,
                context,
                "Error",
                "Load"), context).mimic(message, context);
        condition.setCell("message", message);
        condition.setCell("context", context);
        condition.setCell("receiver", self);
        condition.setCell("moduleName", runtime.newText(name));

        runtime.withReturningRestart("ignoreLoadError", context, new RunnableWithControlFlow() {

            public void run() throws ControlFlow {
                runtime.errorCondition(condition);
            }
        });
        return false;
    }
}
