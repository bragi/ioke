/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang;

import ioke.lang.exceptions.ControlFlow;
import ioke.lang.java.IokeClassLoader;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
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

    private boolean useBuiltin(IokeObject self, IokeObject context, IokeObject message, String name) throws ControlFlow {

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

    private boolean canUseFile(File f) {
    	return f.exists() && f.isFile();
    }
    
    private void evaluateJarInitFile(File f, IokeObject message, IokeObject context) throws ControlFlow {
    	try {
        	URL url = new URL("jar:" + f.toURI().toURL().toString() + "!/init.ik");
        	InputStream is = url.openStream();
        	if(is != null){
        		context.runtime.evaluateStream(url.toString(), new InputStreamReader(is, "UTF-8"), message, context);    		
        	}
    	} catch(IOException e) {
    		// Hopefully the init.ik file does not exist, let's ignore it
    	}
    	 
    }
    
    private void useJar(File f, IokeObject message, IokeObject context) throws IOException, ControlFlow {
    	classLoader.addURL(f.toURI().toURL());
    	loaded.add(f.getCanonicalPath());
    	evaluateJarInitFile(f, message, context);
    }
    
    private boolean useFile(File f, IokeObject message, IokeObject context) throws IOException, ControlFlow {
    	String canonicalPath = f.getCanonicalPath(); 
        if (loaded.contains(canonicalPath)) {
            return false;
        } else {
            if (canonicalPath.endsWith(".jar")) {
                useJar(f, message, context);
            } else {
                context.runtime.evaluateFile(f, message, context);
                loaded.add(canonicalPath);
            }
            return true;
        }
    }
    
    private boolean canUseResource(String resourceName) {
    	return classLoader.getResourceAsStream(resourceName) != null;
    }
    
    private boolean useResource(String resourceName, IokeObject message, IokeObject context) throws IOException, ControlFlow {
        if (loaded.contains(resourceName)) {
            return false;
        } else {
            if ((resourceName).endsWith(".jar")) {
                // load jar here - can't do it correctly at the moment, though.
            } else {
                context.runtime.evaluateStream(resourceName, new InputStreamReader(classLoader.getResourceAsStream(resourceName), "UTF-8"), message, context);
            }
            loaded.add(resourceName);
            return true;
        }
    }
    
    private List<String> loadPaths(IokeObject loadPath) {
    	List<String> result = new ArrayList<String>();
    	for(Object o : ((IokeList) IokeObject.data(loadPath)).getList()) {
    		result.add(Text.getText(o));
    	}
    	return result;
    }

    public boolean use(IokeObject self, IokeObject context, IokeObject message, String name) throws ControlFlow {
        final Runtime runtime = context.runtime;
        if(builtinForName(runtime, name) != null) {
        	return useBuiltin(self, context, message, name);
        }

        String[] suffixes = (name.endsWith(".ik") || name.endsWith(".jar")) ? SUFFIXES_WITH_BLANK : SUFFIXES;

        // Absolute path
        for (String suffix : suffixes) {
            try {
            	String resourceName = name + suffix;
            	
                File f = new File(resourceName);

                if (canUseFile(f)) {
                	return useFile(f, message, context);
                }
                
                if (canUseResource(resourceName)) {
                	return useResource(resourceName, message, context);
                }
            } catch (Throwable e) {
                boolean result = restartLoadingCondition(self, context, message, name, e);
                if (!result) {
                    return false;
                }
            }
        }

        for (String path : loadPaths(loadPath)) {
            for (String suffix : suffixes) {
                try {
                    File f;

                    if (isAbsoluteFileName(path)) {
                        f = new File(path, name + suffix);
                    } else {
                        f = new File(new File(currentWorkingDirectory, path), name + suffix);
                    }

                    if (canUseFile(f)) {
                    	return useFile(f, message, context);
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
