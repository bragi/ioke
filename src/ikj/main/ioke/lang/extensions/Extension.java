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
 * implements this interface. Then register your extension within
 * Ioke runtime using:
 *
 *   extension(org:example:JavaExtension)
 *
 * from init.ik file in the extension jar file.
 *
 * @author <a href="mailto:bragi@ragnarson.com">Łukasz Piestrzeniewicz</a>
 */
public interface Extension {
    public void init(Runtime runtime) throws ControlFlow;
}
