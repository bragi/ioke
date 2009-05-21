/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang.extensions;

import ioke.lang.exceptions.ControlFlow;
import ioke.lang.Runtime;

/**
 * Serves as an entry point for Java-based Ioke extensions.
 *
 * When you create pure Java-based extension for Ioke create a class that
 * extends Extension. Then register your extension within
 * Ioke runtime using:
 *
 *   Extension register("org.example.JavaExtension")
 *
 * from init.ik file in the extension jar file.
 *
 * @author <a href="mailto:bragi@ragnarson.com">Łukasz Piestrzeniewicz</a>
 */
public abstract class Extension {

    /**
     * Called when Extension is registered in given +runtime+.
     *
     * @param runtime Runtime of the interpreter instance that loaded this Extension.
     * @throws ioke.lang.exceptions.ControlFlow when something goes wrong.
     */
    public void init(Runtime runtime) throws ControlFlow {
        // Do nothing on purpose.
    }

    /**
     * Called when extension is de-registered.
     */
    public void shutdown() {
        // Do nothing on purpose
    }
}
